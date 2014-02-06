# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'action_controller/integration'


class ApplicationController < ActionController::Base
helper :all
include ExceptionNotifiable
  require_dependency 'company_contact'
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_woodlandclaims.com_session_id'

before_filter :authorize, :except => [:create_entry, :check_login, :basic_auth, :claim_search, :pending_freeze] # user should be logged in
#before_filter :check_rights

  # Returns the id of the current folder, which is used by the
  # CRUD authorize methods to check the logged in user's permissions.
  def folder_id
    case params[:controller] + '/' + params[:action]
    when 'folder/index', 'folder/list', 'folder/new', 'folder/create', 'folder/update_permissions', 'folder/feed', 'file/upload', 'file/validate_filename'
      current_folder_id = 1 unless current_folder_id = params[:id]
    when 'file/do_the_upload'
      # This prevents a URL like 0.0.0.0/file/do_the_upload/12,
      # which breaks the upload progress. The URL now looks like this:
      # 0.0.0.0/file/do_the_upload/?folder_id=12
      current_folder_id = 1 unless current_folder_id = params[:folder_id]
    when 'folder/rename', 'folder/update', 'folder/destroy'
      current_folder_id = @folder.parent_id if @folder
    when 'file/download', 'file/rename', 'file/update', 'file/destroy', 'file/preview'
      current_folder_id = @myfile.folder.id
    when 'inbox/do_the_upload', 'inbox/index'
      unless params[:user_id].nil?
        current_folder_id = Folder.fetch_user_inbox(params[:user_id]).id 
      else
        current_folder_id = Folder.fetch_user_inbox(@logged_in_user.id).id 
      end
    end

    case params[:controller]
    when 'claims'
      current_folder_id = 2
    end

    return current_folder_id
  end

  # Check if a folder exists before executing an action.
  # If it doesn't exist: redirect to 'list' and show an error message
  def does_folder_exist
    @folder = Folder.find(params[:id]) if params[:id]
  rescue
    flash.now[:folder_error] = 'Someone else deleted the folder you are using. Your action was cancelled and you have been taken back to the root folder.'
    redirect_to :controller => 'folder', :action => 'list' and return false
  end

  # The #authorize method is used as a <tt>before_hook</tt> in most controllers.
  # If the session does not contain a valid user, the method redirects to either
  # AuthenticationController.login or AuthenticationController.create_admin (if no users exist yet).
  def authorize
    @logged_in_user = User.find(session[:user_id])
  rescue
    reset_session
    @logged_in_user = nil
    if User.find(:all).length > 0
      session[:jumpto] = request.parameters
      redirect_to :controller => 'authentication', :action => 'login' and return false
    else
      redirect_to :controller => 'authentication', :action => 'create_admin' and return false
    end
  end
  
  # Check for permissions with redirection
    def has_permission?(location)
      if @logged_in_user.is_admin?
        return true
      end
       if not @logged_in_user.nil?
          groups = @logged_in_user.groups
           groups.each do |g|
            g.rights.detect {|right| 
            if right.area == location
              return true
            end
            }
          end
          flash[:notice] = "You do not have permission to access that area."
          redirect_to :controller => 'main', :action => 'index' and return false
      else
        return false
      end
    end
    
    # Check for permissions without redirection
    def has_permission(location)
      if @logged_in_user.is_admin?
        return true
      end
       if not @logged_in_user.nil?
          groups = @logged_in_user.groups
           groups.each do |g|
            g.rights.detect {|right| 
            if right.area == location
              return true
            end
            }
          end
          #flash[:notice] = "You do not have permission to access that area."
          return false
      else
        return false
      end
    end
  
  def check_rights
    unless @logged_in_user.groups.rights.detect{|group| 
      group.rights.detect{|right| 
        right.action == action_name && right.controller == self.class.controller_path
        }
       }
       flash[:notice] = "You are not authorized to view the page requested"
       request.env["HTTP_REFERER"] ? (redirect_to :back) : (redirect_to :controller => 'main', :action => 'index')
       return false
     end
  end

  # If the session does not contain a user with admin privilages (is in the admins
  # group), the method redirects to /folder/list
  def authorize_admin
    redirect_to(:controller => 'main', :action => 'index') and return false unless @logged_in_user.is_admin?
  end

  # Redirect to the Root folder and show an error message
  # if current user cannot create in current folder
  def authorize_creating
    unless @logged_in_user.can_create(folder_id)
      flash.now[:folder_error] = "You don't have create permissions for this folder."
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id and return false
    end
  end

  # Redirect to the Root folder and show an error message
  # if current user cannot read in current folder
  def authorize_reading
    unless @logged_in_user.can_read(folder_id)
      flash.now[:folder_error] = "You don't have read permissions for this folder."
      redirect_to :controller => 'folder', :action => 'list', :id => nil and return false
    end
  end

  # Redirect to the Root folder and show an error message
  # if current user cannot update in current folder
  def authorize_updating
    unless @logged_in_user.can_update(folder_id)
      flash.now[:folder_error] = "You don't have update permissions for this folder."
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id and return false
    end
  end

  # Check if the logged in user has permission to delete the file
  def authorize_deleting
    unless @logged_in_user.can_delete(folder_id)
      flash.now[:folder_error] = "You don't have delete permissions for this folder."
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id and return false
    end
  end

  def fetch_user_claims
    @userclaims = Claim.find(:all, :conditions => ['status != 8 AND user_id = ?', @logged_in_user.id], :order => 'id DESC', :limit => 15)
    @inbox_count = Folder.user_inbox_count(@logged_in_user)
  end

  def find_claim
    begin
      @claim = Claim.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise "The claim you have requested does not exist"
    end
  end

end
