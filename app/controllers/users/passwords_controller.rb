class Users::PasswordsController < ::Devise::PasswordsController
  skip_before_filter :require_no_authentication
  layout "application"


  def create
    self.resource = resource_class.find_by_email(params[:user][:email])

    if resource.nil?
      self.resource = resource_class.new

      flash[:warning] = "No account found matching that email"
      
      render "new" and return
    end

    resource.send_reset_password_instructions

    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def resource_params
    params[:user].present? ? params.require(:user).permit(:email, :login, :password,
    :password_confirmation, :reset_password_token) : {}
  end      
end