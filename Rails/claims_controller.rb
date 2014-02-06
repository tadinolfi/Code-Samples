class ClaimsController < ApplicationController
layout "claims"
before_filter :fetch_user_claims

  def index
    if has_permission?('claim_modify')
    #@claim_reports_due = Claim.find_reports_due(@logged_in_user, (cookies[:diary_due_per_page] ||= '5'), params)
    @claim = Claim.new
    @adjustor_inbox = Folder.find(:first, :conditions => ['parent_id = 3 AND user_id = ?', @logged_in_user.id])
    @inbox_items = @adjustor_inbox.list_files(@logged_in_user, 'filename') if @adjustor_inbox
   end
  end


  def new
    if has_permission?('claim_create')
    @claim = session[:claim_draft] || Claim.new
    @insured = session[:insured_draft] || Insured.new
    @losslocation = session[:losslocation_draft] || Losslocation.new
    @liable = session[:liable_draft] || Liable.new
    @users = User.find(:all, :order => 'fullname')
    @inscos = Insco.find(:all, :order => 'company')
    @policedepts = PoliceDept.find(:all, :order => 'company')
    @firedepts =  FireDept.find(:all, :order => 'company')
    @representatives = Representative.find(:all, :order => 'company')
    @losstypes = Losstype.find(:all, :order => 'losstype')
    render :action => 'new'
    end
  end

  def edit
    if has_permission?('claim_modify')
      @claim = Claim.find(params[:id])
      @insured = @claim.insured
      @losslocation = @claim.losslocation
      @liable = @claim.liable
      @policedepts = PoliceDept.find(:all, :order => 'company')
      @firedepts = FireDept.find(:all, :order => 'company')
      @users = User.find(:all)
      @inscos = Insco.find(:all, :order => 'company')
      @representatives = Representative.find(:all, :order => 'company')
      @losstypes = Losstype.find(:all, :order => 'losstype')
      render :action => 'edit', :layout => 'mainlayout'
   end
  end

  def quickedit
    if has_permission?('claim_quickedit')
      @claim = Claim.find(params[:id])
      @users = User.find(:all, :order => 'fullname')
      @losstypes = Losstype.find(:all, :order => 'losstype')
      if request.post?
        if @claim.update_attributes(params[:claim])
           @claim.insured.update_attributes(params[:insured])
           @claim.losslocation.update_attributes(params[:losslocation])
          flash[:notice] = "Claim successfully updated."
          redirect_to :action => 'viewclaim', :id => @claim.id
        end
      else
        @users = User.find(:all, :order => 'fullname')
        @losstypes = Losstype.find(:all)
        render :layout => 'mainlayout'
      end
   end
  end

  def create
    if has_permission?('claim_create')
    @claim = Claim.new(params[:claim])
    @claim.status = 1
    @claim.claim_diary_date = 10.days.from_now(@claim.assigned_on) unless @claim.assigned_on.blank?
    @insured = @claim.insured = Insured.new(params[:insured])
    @losslocation = @claim.losslocation = Losslocation.new(params[:losslocation])
    @liable = @claim.liable = Liable.new(params[:liable])
    claimuser = User.find(params[:claim][:user_id])
    
    unless params[:time_of_loss_hour].blank? || params[:time_of_loss_minutes].blank? || params[:time_of_loss_merdian].blank?
      time_of_loss = parse_time_of_loss(params[:time_of_loss_hour], params[:time_of_loss_minutes], params[:time_of_loss_merdian])
      @claim.time_of_loss = time_of_loss
    else
      @claim.time_of_loss = nil
    end
    
    @claim.user = claimuser
    @claim.timesheets_rate = TimesheetsRate.find(params[:timesheets_rate][:id])

      if @claim.save
        flash[:notice] = "Claim #: #{@claim.id} was successfully created."
        session[:claim_draft] = nil
        session[:insured_draft] = nil
        session[:losslocation_draft] = nil
        session[:liable_draft] = nil

        @folder = Folder.new
        @folder.name = @claim.id
        @folder.parent_id = 2
        @folder.date_modified = Time.now
        @folder.user = claimuser


        if @folder.save
          copy_permissions_to_new_folder(@folder)
          @claim.update_attributes(:folder_id => @folder.id)
        end

        redirect_to :action => 'index'
      else
        @users = User.find(:all)
        @inscos = Insco.find(:all)
        @representatives = Representative.find(:all)
        @losstypes = Losstype.find(:all)
        @policedepts = PoliceDept.find(:all)
        @firedepts = FireDept.find(:all)
        render :action => "new"
    end
   end
  end

  def update
    if has_permission?('claim_modify')
    @claim = Claim.find(params[:id])
    @claim.attributes = params[:claim]
    @claim.insured.attributes = params[:insured]
    @claim.losslocation.attributes = params[:losslocation]
    @claim.liable.attributes = params[:liable]
    @claim.timesheets_rate = TimesheetsRate.find(params[:timesheets_rate][:id])
    unless params[:time_of_loss_hour].blank? || params[:time_of_loss_minutes].blank? || params[:time_of_loss_merdian].blank?
      time_of_loss = parse_time_of_loss(params[:time_of_loss_hour], params[:time_of_loss_minutes], params[:time_of_loss_merdian])
      @claim.time_of_loss = time_of_loss
    else
      @claim.time_of_loss = nil
    end

      if @claim.valid? && @claim.insured.valid? && @claim.losslocation.valid? && @claim.liable.valid?
        @claim.save!
        @claim.insured.save!
        @claim.losslocation.save!
        @claim.liable.save!
        flash[:notice] = 'Claim was successfully updated.'
        redirect_to :action => 'viewclaim', :id => @claim
      else
      @insured = @claim.insured
      @losslocation = @claim.losslocation
      @liable = @claim.liable
      @policedepts = PoliceDept.find(:all, :order => 'company')
      @firedepts = FireDept.find(:all, :order => 'company')
      @users = User.find(:all)
      @inscos = Insco.find(:all, :order => 'company')
      @representatives = Representative.find(:all, :order => 'company')
      @losstypes = Losstype.find(:all, :order => 'losstype')
       render :action => "edit"
     end
   end
  end

  # DELETE /claims/1
  # DELETE /claims/1.xml
  def destroy
    @claim = Claim.find(params[:id])
    @claim.destroy
    redirect_to :action => 'index'
  end


  def fetch_other_adj_claims
    @claims = Claim.find(:all,:conditions => ['user_id = ? AND status != 8', params[:id]], :order => 'id DESC', :limit => 15)
    @claims_count = Claim.count(:conditions => ['user_id = ? AND status != 8', params[:id]])
    render :update do |page|
     page.replace_html 'user_claims_' + params[:id].to_s, :partial => 'user_claims', :locals => { :claims => @claims, :user_id => params[:id], :claims_count => @claims_count }
     page.toggle 'user_claims_' + params[:id]
    end
  end

  def openclaim
    if has_permission?('claim_modify')
     @searchresults = Claim.paginate(:all, :conditions => ['claims.id LIKE ? OR insureds.firstname LIKE ? OR insureds.lastname LIKE ?', '%' + params[:open_claim_num] + '%', '%' + params[:open_claim_num] + '%', '%' + params[:open_claim_num] + '%'], :joins => [:insured], :page => params[:page], :order => "id DESC") 
      if params[:page].blank? 
       if @searchresults.length == 1
        redirect_to :action => 'viewclaim', :id => @searchresults
      elsif @searchresults.length > 1
        render :layout => 'claims_without_quickjump', :template => 'claims/openclaims'
      else
       flash[:notice] = "The claim you requested does not exist"
       redirect_to :action => 'index'
      end
    else
      render :layout => 'claims_without_quickjump', :template => 'claims/openclaims'
    end
    end
  end

  def viewclaim
    if has_permission?('claim_modify')
    @claim = Claim.find(params[:id])
    render :action => 'viewclaim', :layout => 'mainlayout'
   end
  end

  def addlosstype
    @losstype = Losstype.new
    @losstype.losstype = params[:value]
    if @losstype.save
      render :update do |page|
        page << "var newOption = document.createElement('option');"
        page << "newOption.value ='" + @losstype.id.to_s + "';"
        page << "newOption.appendChild(document.createTextNode('" + @losstype.losstype + "'));"
        page << "$('losslocation_losstype_id').appendChild(newOption);"
        page << "optlength = document.forms[1].losslocation_losstype_id.options.length;"
        page << "document.forms[1].losslocation_losstype_id.selectedIndex = optlength - 1"
        page[:add_loss_type].hide
      end
    end
  end
  
  def removelosstype
    @losstype = Losstype.find(params[:losstype_id])
    if @losstype.destroy
      render :update do |page|
      page << "$F('losslocation_losstype_id').remove();"
      end
    end
  end

  def updatestatus
    @claim = Claim.find(params[:id])
      if params[:status].to_i == 8
        @claim.status = params[:status]
        @claim.claim_closed_date = Time.now.to_s(:db)
      else
        @claim.status = params[:status]
      end
      
      if @claim.save
        render :update do |page|
          page.replace_html 'statusnotice', "Claim Status successfully updated"
        end
      else
          render :update do |page|
          page.replace_html 'statusnotice', "ERROR: This claim cannot be saved due to missing data please check and re-save the claim"
          end
      end
  end

  def email_log
    if has_permission?('claim_email_log')
    @claim = Claim.find(params[:id])
    @email_log = @claim.email_log
    render :layout => 'mainlayout'
   end
  end

  def attach_details
    @claim = Claim.find(params[:id])
    emaillog = EmailLog.find(params[:log_id])
    attach_ids = emaillog.attachments.split(",")
    @attachments = Myfile.find(attach_ids)
    render :layout => 'mainlayout'
  end

  def sendemail
    if has_permission?('claim_sendemail')
    @to_addr = Array.new
    @from_addr = Array.new
    @claim = Claim.find(params[:id])
    if @claim.insco and !@claim.insco.email.blank?
     @to_addr << ["#{@claim.insco.email}"]
    end
    if agent_contact = @claim.agent_contact
      @to_addr << ["#{agent_contact.firstname} #{agent_contact.lastname} - #{agent_contact.email}", agent_contact.email]
    end
    if @claim.insco_contact
      @to_addr << ["#{@claim.insco_contact.firstname} #{@claim.insco_contact.lastname} - (#{@claim.insco_contact.email})", "#{@claim.insco_contact.email}"]
    end
    if @claim.insured_rep && @claim.insured_rep_contact
    @to_addr << ["#{@claim.insured_rep_contact.firstname} #{@claim.insured_rep_contact.lastname} - (#{@claim.insured_rep_contact.email})", "#{@claim.insured_rep_contact.email}"]
    end
    if @claim.claim_rep && @claim.claim_rep_contact
    @to_addr << ["#{@claim.claim_rep_contact.firstname} #{@claim.claim_rep_contact.lastname} - (#{@claim.claim_rep_contact.email})", "#{@claim.claim_rep_contact.email}"]
  end
  
    if @claim.liable && !@claim.liable.email.blank?
      @to_addr << ["#{@claim.liable.firstname} #{@claim.liable.lastname} - (#{@claim.liable.email})", "#{@claim.liable.email}"]
    end
    unless @claim.insured.nil? || @claim.insured.email.blank?
      @to_addr << ["#{@claim.insured.firstname}, #{@claim.insured.lastname} - (#{@claim.insured.email})", "#{@claim.insured.email}"]
    end
    
    unless @claim.insured.nil? ||  @claim.insured.second_email.blank?
      @to_addr << ["#{@claim.insured.second_firstname}, #{@claim.insured.second_lastname} - (#{@claim.insured.second_email})", "#{@claim.insured.second_email}"]
    end
    
    unless @claim.agent.nil? || @claim.agent.email.blank?
      @to_addr << ["#{@claim.agent.print_company_as} - #{@claim.agent.email}", "#{@claim.agent.email}"]
    end
    
    unless @claim.losslocation.nil? || @claim.losslocation.police_dept.nil? || @claim.losslocation.police_dept.email.blank?
      @to_addr << ["#{@claim.losslocation.police_dept.company} - #{@claim.losslocation.police_dept.email}", "#{@claim.losslocation.police_dept.email}"]
    end
    
     unless @claim.losslocation.nil? || @claim.losslocation.fire_dept.nil? || @claim.losslocation.fire_dept.email.blank?
      @to_addr << ["#{@claim.losslocation.fire_dept.company} - #{@claim.losslocation.fire_dept.email}", "#{@claim.losslocation.fire_dept.email}"]
    end
    
    
    @attachments = Myfile.find_all_by_folder_id(@claim.folder_id, :order => 'date_modified DESC')
    if request.post?
      unless params[:to].blank? && params[:addtl_to].blank?
        
        attach_files = params[:attachments].nil? ? Array.new : params[:attachments]
        
          unless params[:to].nil? || params[:to].empty?
            send_to = params[:to].concat(params[:addtl_to].strip.split(','))
          else
            send_to = params[:addtl_to].strip.split(',')
          end
        
      begin
        Sendemail.deliver_claim_email(send_to, params[:from], params[:cc], params[:bcc], params[:subject], params[:body], attach_files)
        # Save this email to the email log
        emaillog = EmailLog.new(:claim_id => params[:id], :from => params[:from], :to => send_to.join(","), :cc => params[:cc], :bcc => params[:bcc], :subject => params[:subject], :body => params[:body], :attachments => attach_files.join(","))
        emaillog.save
  
        # Save a copy to the file system
        filename = "email-#{Time.now.strftime('%m-%d-%Y %I:%M:%S')}.html"
        clean_filename = filename.gsub(" ", "_")
        claim_folder = Folder.fetch_claim_folder(@claim)
        @myfile = Myfile.new
        @myfile.create_email_copy(clean_filename, claim_folder.id, @logged_in_user, attach_files, send_to.join(","), params)
        params.clear
        flash[:notice] = "Your email has been successfully sent"
      rescue Exception => e
            flash[:notice] = e.message
      end
     else
      flash[:notice] = "E-mail recipient cannot be blank"
     end
  end
    render :layout => 'mainlayout'
    end
  end

  def generate_documents
    @claim = Claim.find(params[:id])
    @customreports = Customreport.find(:all, :order => 'formname')
    @reports = Report.find(:all, :order => 'formname')

    render :layout => 'mainlayout'
  end

  def fetch_company_contacts
   case
       when params.has_key?('insco')
        insco = CompanyContact.find_by_id(params[:insco])
        @contacts = insco.contact if insco
          unless @contacts.nil? || @contacts.empty?
            render :update do |page|
            page.replace_html 'insco_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :claim, :insco_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
            page.show 'insco_contacts'
            end
          else
            render :update do |page|
              page.hide 'insco_contacts'
           end
         end
         
       when params.has_key?('insco_rep')
         insco_rep = CompanyContact.find_by_id(params[:insco_rep])
         @contacts = insco_rep.contact if insco_rep
         unless @contacts.nil? || @contacts.empty?
           render :update do |page|
             page.replace_html 'inscorep_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :claim, :inscorep_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
             page.show 'inscorep_contacts'
           end
         else
           render :update do |page|
             page.hide 'inscorep_contacts'
          end
        end
      

        when params.has_key?('insured_rep')
        insured_rep = CompanyContact.find_by_id(params[:insured_rep])
        @contacts = insured_rep.contact if insured_rep
        unless @contacts.nil? || @contacts.empty?
          render :update do |page|
          page.replace_html 'insured_rep_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :claim, :insuredrep_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
          page.show 'insured_rep_contacts'
        end
        else
          render :update do |page|
          page.hide 'insured_rep_contacts'
        end
        end
      when params.has_key?('claimant_rep')
        claim_rep = CompanyContact.find_by_id(params[:claimant_rep])
        @contacts = claim_rep.contact if claim_rep
        unless @contacts.nil? || @contacts.empty?
          render :update do |page|
          page.replace_html 'claimant_rep_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :claim, :claimrep_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
          page.show 'claimant_rep_contacts'
        end
        else
          render :update do |page|
          page.hide 'claimant_rep_contacts'
        end
        end
      when params.has_key?('agent')
        agent = CompanyContact.find_by_id(params[:agent])
        @contacts = agent.contact if agent
         unless @contacts.nil? || @contacts.empty?
          render :update do |page|
          page.replace_html 'agent_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :claim, :agent_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
          page.show 'agent_contacts'
        end
        else
          render :update do |page|
          page.hide 'agent_contacts'
        end
        end
     when params.has_key?('police_dept')
        police_dept = CompanyContact.find_by_id(params[:police_dept])
        @contacts = police_dept.contact if police_dept
       unless @contacts.nil? || @contacts.empty?
          render :update do |page|
          page.replace_html 'police_dept_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :losslocation, :police_dept_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
          page.show 'police_dept_contacts'
        end
        else
          render :update do |page|
          page.hide 'police_dept_contacts'
        end
        end
      when params.has_key?('fire_dept')
        fire_dept = CompanyContact.find_by_id(params[:fire_dept])
        @contacts = fire_dept.contact if fire_dept
       unless @contacts.nil? || @contacts.empty?
          render :update do |page|
          page.replace_html 'fire_dept_contacts', :inline => "<label for='contact'>Contact</label><%= collection_select :losslocation, :fire_dept_contact_id, @contacts, :id, :name_with_email, { :include_blank => true } %><br />"
          page.show 'fire_dept_contacts'
        end
        else
          render :update do |page|
          page.hide 'fire_dept_contacts'
        end
        end
    end
  end

  def diaryahead
    @claim = Claim.find(params[:id])
    diary_date_obj = Date.today + params[:diary_ahead].to_i
    if diary_date_obj.wday == 6 || diary_date_obj.wday == 0
      diary_date = next_weekday(diary_date_obj)
    else
      diary_date = diary_date_obj
    end
    #newdate = Date.today + params[:diary_ahead].to_i
    if @claim.update_attributes(:claim_diary_date => diary_date.to_s(:db))
      redirect_to :action => 'viewclaim', :id => @claim
    end
  end

  def searchclaims
    #@searchresults = Claim.search(params[:searchfield1], :include => ['insured', 'losslocation', 'agent', 'insco', 'user'])
    @searchresults = Claim.advanced_search(params)
    render :layout => 'claims_without_quickjump'
  end

  def next_weekday(timeobj)
    begin
      timeobj += 1
    end until timeobj.wday != 6 && timeobj.wday != 0
    timeobj
    end

  def update_diary_date
    if has_permission('claim_modify')
    @claim = Claim.find(params[:id])
    if @claim.update_attributes(:claim_diary_date => params[:diary_date])
      diary_date = @claim.claim_diary_date
      diff = diary_date - Date.today
      render :update do |page|
        page.replace_html 'diary_status', :inline => 'Diary date successfully updated.'
        page.replace_html 'diary_days_due', :inline => diff.to_s
        page.show 'diary_status'
      end
    end
   end
 end
  
  def save_draft
    session[:claim_draft] = Claim.new(params[:claim])
    session[:insured_draft] = Insured.new(params[:insured])
    session[:losslocation_draft] = Losslocation.new(params[:losslocation])
    session[:liable_draft] = Liable.new(params[:liable])
    render :text => "<i>draft saved at #{Time.now}</i>"
  end

  def closeclaim
    @claim = Claim.find(params[:id])
    if @claim.update_attributes(:status => 8)
      flash[:notice] = "Claim # #{@claim.id} has been successfully closed."
    end
    redirect_to :action => 'index'
  end
  
  def display_open_claims
    user = User.find(params[:id])
    @searchresults = user.open_claims.paginate(:page => params[:page])
    render :action => 'searchclaims', :layout => 'claims_without_quickjump'
  end
  
   def fetch_reports_due
    @claim_reports_due = Claim.find_reports_due(@logged_in_user, (cookies[:diary_due_per_page] || params[:per_page]), params, params[:diary_date])
        render :update do |page|
        page.replace_html 'reports_due', :partial => 'shared/reports_due', :object => @claim_reports_due, :locals => { :diary_date => params[:diary_date] }
    end
  end
  
  def fetch_past_due_reports
    @past_due_reports = Claim.find_past_due_reports(@logged_in_user, (cookies[:diary_due_date] || params[:past_due_per_page]), params)
      render :update do |page|
        page.replace_html 'reports_past_due', :partial => 'shared/reports_past_due', :object => @past_due_reports
      end
  end
  
  def diary_due_per_page
    cookies[:diary_due_per_page] = params[:per_page]
    @claim_reports_due = Claim.find_reports_due(@logged_in_user, params[:per_page], params)
    render :update do |page|
      page.replace_html 'reports_due', :partial => 'shared/reports_due', :object => @claim_reports_due, :locals => { :per_page => params[:per_page] }
    end
  end
  
  def diary_past_due_per_page
    cookies[:diary_past_due_per_page] = params[:past_due_per_page]
    @past_due_reports = Claim.find_past_due_reports(@logged_in_user, params[:past_due_per_page], params)
    render :update do |page|
      page.replace_html 'reports_past_due', :partial => 'shared/reports_past_due', :object => @past_due_reports, :locals => { :past_due_per_page => params[:past_due_per_page] }
    end
  end
  
  def print_summary
    @claim = Claim.find(params[:id])
    render :layout => false
  end
  
  def gross_loss_amt
    find_claim
    if request.xhr?
      if (params[:claim].nil? or params[:claim][:gross_loss_amt].blank?) and (params[:gross_loss_type].nil? or params[:gross_loss_type].blank?)
        render :update do |page|
          page.replace_html 'status', "You must either select a box or enter a value of at least 0 in the Loss Amount"
        end
      else
        if params[:claim][:gross_loss_amt].blank?
          gross_loss = 0
        else
          gross_loss = params[:claim][:gross_loss_amt]
        end
        if @claim.update_attributes(:gross_loss_amt => gross_loss, :gross_loss_type => params[:gross_loss_type])
          render :update do |page|
            page << "window.close()"
          end
        end
      end 
    else
    render :layout => false
    end 
  end

  def reports_due
    @claim_reports_due = Claim.find_reports_due(@logged_in_user, (cookies[:diary_due_per_page] ||= '5'), params)
    render :partial => 'shared/reports_due', :object => @claim_reports_due, :locals => { :diary_date => next_saturday.strftime('%Y-%m-%d') }
  end


private

   def next_saturday(timeobj = Time.now)
    begin
      timeobj += 1
    end until timeobj.wday == 6
    timeobj
   end

  def parse_time_of_loss(hour, minutes, merdian)
    Time.parse("#{hour}:#{minutes} #{merdian}")
  end
  
  
  def copy_permissions_to_new_folder(folder)
    # get the 'parent' GroupPermissions
    GroupPermission.find_all_by_folder_id(folder_id).each do |parent_group_permissions|
      # create the new GroupPermissions
      group_permissions = GroupPermission.new
      group_permissions.folder = folder
      group_permissions.group = parent_group_permissions.group
      group_permissions.can_create = parent_group_permissions.can_create
      group_permissions.can_read = parent_group_permissions.can_read
      group_permissions.can_update = parent_group_permissions.can_update
      group_permissions.can_delete = parent_group_permissions.can_delete
      group_permissions.save
    end
  end

  def fetch_conditions_for_claim_search(searchparams)
     case searchparams
      when "1"
       filter_conditions = "users.fullname LIKE ?"
      when "2"
      filter_conditions = "company_contacts.company LIKE ? AND company_contacts.type = 'Agent'"
      when "3"
      filter_conditions = "claims.claim_num LIKE ?"
      when "4"
      filter_conditions = "company_contacts.company LIKE ? AND company_contacts.type = 'Insco'"
      when "5"
      filter_conditions = "losslocations.city LIKE ?"
      when "6"
      filter_conditions = "claims.policy_num LIKE ?"
      when "7"
      filter_conditions =  "INNER JOIN losstypes as losstypes ON losstypes.id=losslocations.losstype_id WHERE losstypes.losstype LIKE ?"
     end
  end

end
