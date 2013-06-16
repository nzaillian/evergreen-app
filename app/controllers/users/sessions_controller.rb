class Users::SessionsController < ::Devise::SessionsController
  include Users::TeamAssignable
  
  skip_before_filter :require_no_authentication
  
  layout "plain"

  # GET /resource/sign_in
  def new
    if params[:company_id].present?
      session[:next] = company_questions_path(Company.find_by_id(params[:company_id]))
    end
        
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end  

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    assign_to_team_from_params!(resource, params)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end  

  def sign_in_params
    params[:user].present? ? params.require(:user).permit(:username, :email, :password) : {}
  end  
end
