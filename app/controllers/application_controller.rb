class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper, RenderHelper, ApplicationHelper

  layout "main"

  before_filter :init

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :bounce_to_login_if_site_private

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :render_to_string

  def login_redirect
    # handle pass-through of question title
    if params[:question][:title].present?
      params[:next] += "?" + {question: params[:question]}.to_param
    end
    require_login
  end

  private

  def init
    @_page_title ||= "Evergreen"
  end

  def self.member_actions(*extras)
    [:show, :edit, :update, :destroy] + extras
  end

  def self.collection_actions(*extras)
    [:index, :new, :create] + extras
  end

  def find_company
    @company = Company.friendly.find(params[:company_id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    bounce_unauthorized_user_to_login
  end

  def bounce_unauthorized_user_to_login
    sign_out(current_user) if current_user
    session[:next] = request.fullpath
    flash[:warning] = "You are trying to access a resource that you aren't authorized to access"
    redirect_to(new_user_session_path) and return
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :login) }
  end  

  def filter_hash(hash, *keys)
    filtered = {}
    
    keys.each do |key|
      filtered[key] = hash[key] if hash[key].present?
    end

    filtered
  end

  def require_login
    unless current_user
      flash[:notice] = "You need to be logged in to do what you are trying to do"

      if request.xhr?
          session[:next] = request.env["HTTP_REFERER"]
          render(status: 418, json: {status: "login_required", redirect_uri: new_user_session_path})
      else
        session[:next] = params[:next].present? ? params[:next] : request.env["PATH_INFO"]
        redirect_to new_user_session_path         
      end
    end
  end

  def bounce_to_login_if_site_private
    if @company
      if !can?(:read, @company)
        flash[:notice] = "The site you are trying to access is only available " + 
                         "to team members. You must login to access it."
        session[:next] = request.path                
        redirect_to new_user_session_path
      end
    end
  end

  def after_sign_in_path_for(resource)
    after_authentication_path_for(resource)
  end    

  def after_sign_up_path_for(resource)
    after_authentication_path_for(resource)
  end
  def after_authentication_path_for(resource)
    redirect_path =  session[:next] || resource.try(:home_path)
    session[:next] = nil
    redirect_path    
  end
end
