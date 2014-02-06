# The file controller contains the following actions:
# [#download]          downloads a file to the users system
# [#progress]          needed for upload progress
# [#upload]            shows the form for uploading files
# [#do_the_upload]     upload to and create a file in the database
# [#validate_filename] validates file to be uploaded
# [#rename]            show the form for adjusting the name of a file
# [#update]            updates the name of a file
# [#destroy]           delete files
# [#preview]           preview file; possibly with highlighted search words
class FileController < ApplicationController
  uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist},
                           :theme_advanced_buttons2 => %w{tablecontrols seperator emotions iespell print fullscreen forecolor backcolor separator link unlink image undo redo code preview},
                           :paste_auto_cleanup_on_paste => true,
                           :valid_elements => "*[*]",
                           :fullpage_default_xml_pi => false,
                           :plugins => %w{contextmenu emotions paste table fullscreen fullpage iespell preview xhtmlxtras}})

skip_before_filter :authorize, :only => :progress

  before_filter :does_folder_exist, :only => [:upload, :do_the_upload] # if the folder DOES exist, @folder is set to it
  before_filter :does_file_exist, :except => [:upload, :progress, :do_the_upload, :validate_filename] # if the file DOES exist, @myfile is set to it
  before_filter :authorize_creating, :only => :upload
  before_filter :authorize_reading, :only => [:download, :preview]
  before_filter :authorize_updating, :only => [:rename, :update]
  before_filter :authorize_deleting, :only => :destroy

  before_filter :fetch_claim

  session :off, :only => :progress
  layout "filemanager"
  # The requested file will be downloaded to the user's system.
  # Which user downloaded which file at what time will be logged.
  # (adapted from http://wiki.rubyonrails.com/rails/pages/HowtoUploadFiles)
  def download
    # Log the 'usage' and return the file.
    begin
    usage = Usage.new
    usage.download_date_time = Time.now
    usage.user = @logged_in_user
    usage.myfile = @myfile

    if usage.save
      case @myfile.filename
        when /.htm$|.html$|.txt$/i
        send_file @myfile.path, :filename => @myfile.filename, :disposition => 'inline'
      else
      send_file @myfile.path, :filename => @myfile.filename
      end
    end
  rescue ActionController::MissingFile => e
    send_data e.message, :type => 'text/html', :disposition => 'inline'
  end
  end

  # Shows upload progress.
  # For details, see http://mongrel.rubyforge.org/docs/upload_progress.html
  def progress
    render :update do |page|
      @status = Mongrel::Uploads.check(params[:upload_id])
      page.upload_progress.update(@status[:size], @status[:received]) if @status
    end
  end

  # Shows the form where a user can select a new file to upload.
  def upload
    if params[:claim_id]
     @claim = Claim.find(params[:claim_id])
    end
    @myfile = Myfile.new
    if USE_UPLOAD_PROGRESS
      render
    else
      render :template =>'file/upload_without_progress'
    end
  end

  # Upload the file and create a record in the database.
  # The file will be stored in the 'current' folder.
  def do_the_upload
    @myfile = Myfile.new(params[:myfile])
    @myfile.folder_id = folder_id
    @myfile.date_modified = Time.now
    unless params[:user].nil?
      @myfile.user = User.find(params[:user][:id])
    else
      @myfile.user = @logged_in_user
    end
    @myfile.owner_initials = @myfile.user.initials    
    # change the filename if it already exists
    dupe = Myfile.find_by_filename_and_folder_id(@myfile.filename, folder_id)
    if USE_UPLOAD_PROGRESS and not dupe.blank?
      dupe.destroy
      #@myfile.filename = @myfile.filename + ' (' + Time.now.strftime('%Y%m%d%H%M%S') + ')'
    end
  
    unless !has_permission('claim_upload_over_2mb') and @myfile.filesize > 2000
    if @myfile.save
      if USE_UPLOAD_PROGRESS
        if params[:claim_id]
          return_url = url_for(:controller => 'folder', :action => 'list', :id => folder_id, :claim_id => params[:claim_id])
        elsif params[:return]
          case params[:return]
            when 'inbox'
             unless params[:user_id].nil?
                return_url = url_for(:controller => 'inbox', :action => 'index', :user_id => params[:user_id])
              else
                return_url = url_for(:controller => 'inbox', :action => 'index')
              end
          end
        else
          return_url = url_for(:controller => 'folder', :action => 'list', :id => folder_id)
        end
         responds_to_parent do # execute the redirect in the main window
      render :update do |page|
        page << "window.parent.UploadProgress.finish('#{return_url}')"
        #page.delay(2) do # allow the progress bar fade to complete
          #page.redirect_to return_url
        #end
      end  
    end
   #     render :text => %(<script type="text/javascript">window.parent.UploadProgress.finish('#{return_url}');</script>)
      else
        redirect_to :controller => 'folder', :action => 'list', :id => folder_id
      end
    else
      render :template =>'file/upload_without_progress' unless USE_UPLOAD_PROGRESS
    end
   else
    flash[:notice] = "You can only upload files under 2 megs"
    return_url = url_for(:controller => 'main', :action => 'index')
    render :text => %(<script type="text/javascript">window.parent.UploadProgress.finish('#{return_url}');</script>)
   end
   
  end

  # Validates a selected file in a file field via an Ajax call
  def validate_filename
    filename = CGI::unescape(request.raw_post).chomp('=')
    filename = Myfile.base_part_of(filename)
    if Myfile.find_by_filename_and_folder_id(filename, folder_id).blank?
      render :text => %(<script type="text/javascript">document.getElementById('submit_upload').disabled=false;\nElement.hide('error');\nElement.hide('spinner');</script>)
    else
      render :text => %(<script type="text/javascript">document.getElementById('error').style.display='block';\nElement.hide('spinner');</script>\nThis file can not be uploaded, because it already exists in this folder.)
    end
  end

  def edit
    @myfile = Myfile.find(params[:id])
    case @myfile.filename
    when /.txt$/i
      edit_content
    when /.htm$|.html$/i
      edit_content
    else
      #raise "test"
      render :action => 'rename'
    end
  end

  def edit_content
    if request.put?
      @myfile = Myfile.find(params[:id])
      @myfile.update_attributes(:filename => params[:filename], :description => params[:description], :date_modified => Time.now, :owner_initials => @logged_in_user.initials)
      @myfile.update_file_contents(params[:tinymce])
      unless params[:claim_id].nil?
        redirect_to :controller => 'folder', :action => 'list', :id => @myfile.folder_id, :claim_id => params[:claim_id]
      else
        redirect_to :controller => 'folder', :action => 'list', :id => @myfile.folder_id, :claim_id => params[:claim_id]
      end

    else
      @customfields = Customfield.find(:all)
      @file_content = @myfile.fetch_file_for_editing
    end
  end


  # Show a form with the current name of the file in a text field.
  def rename
    render
  end

  # Update the name of the file with the new data.
  def update
    if request.post?
      if @myfile.update_attributes(:filename => Myfile.base_part_of(params[:myfile][:filename]), :description => params[:myfile][:description], :date_modified => Time.now)
        if params[:claim_id]
          return_url = url_for(:controller => 'folder', :action => 'list', :id => folder_id, :claim_id => params[:claim_id])
        else
          return_url = url_for(:controller => 'folder', :action => 'list', :id => folder_id)
        end
        redirect_to return_url
      end
    else
      render :action => 'rename'
    end
  end

  # Preview file; possibly with highlighted search words.
  def preview
    if @myfile.indexed
      if params[:search].blank? # normal case
        @text = @myfile.text
      else # if we come from the search results page
        @text = @myfile.highlight(params[:search], { :field => :text, :excerpt_length => :all, :pre_tag => '[h]', :post_tag => '[/h]' })
      end
    end
  end

  # Delete a file.
  def destroy
    @myfile.destroy
    if params[:claim_id]
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id, :claim_id => params[:claim_id]
    else
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id
    end
  end
  
  def format_file_size(size_in_byte)
    case size_in_byte
      when (1024...1024**2): return "#{(size_in_byte/1024)}Kb"
      when (1024**2...1024**3): return "#{format('%.2f',(size_in_byte/1024**2.to_f))}Mb"
      when (1024**3...1024**4): return "#{format('%.2f',(size_in_byte/1024**3.to_f))}Gb"
    end
  end

  def fetch_claim
    unless params[:claim_id].nil?
      @claim = Claim.find(params[:claim_id])
    end
  end

  # These methods are private:
  # [#does_file_exist] Check if a file exists before executing an action
  private
    # Check if a file exists before executing an action.
    # If it doesn't exist: redirect to 'list' and show an error message
    def does_file_exist
      @myfile = Myfile.find(params[:id])
    rescue
      flash.now[:folder_error] = 'Someone else deleted the file you are using. Your action was cancelled and you have been taken back to the root folder.'
      redirect_to :controller => 'folder', :action => 'list' and return false
    end
end
