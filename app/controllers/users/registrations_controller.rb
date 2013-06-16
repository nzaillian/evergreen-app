class Users::RegistrationsController < ::Devise::RegistrationsController
  include Users::TeamAssignable

  skip_before_filter :require_no_authentication
  
  layout "plain"

  def new
    if params[:company_id].present?
      session[:next] = company_questions_path(Company.find_by_id(params[:company_id]))
    end
        
    build_resource({})
    respond_with self.resource
  end  

  # POST /resource
  def create
    self.resource = build_resource(sign_up_params)

    if resource.save
      assign_to_team_from_params!(resource, params)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        redirect_to after_sign_in_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def sign_up_params
    params.require(:user).permit(:username, :nickname, :email, :password, 
      :password_confirmation)
  end
end
