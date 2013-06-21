class Admin::UsersController < Admin::AdminController
  prepend_before_filter :find_company, only: member_actions(:delete_avatar)
  before_filter :find_user, only: member_actions
  layout "settings"
  set_tab :account_settings

  def edit
    authorize! :modify, @user
  end

  def update
    @user.attributes = user_params

    authorize! :modify, @user

    if @user.save
      flash[:notice] = "Settings updated successfully"
      redirect_to(url_for(action: "edit", id: @user.id, company_id: @company.id) + (params[:section] || ""))
    else
      render action: "edit", layout: "settings"
    end
  end  

  def delete_avatar
    @user = User.friendly.find(params[:user_id])

    authorize! :modify, @user

    @user.remove_avatar = true

    @user.save!

    flash[:warning] = "Avatar successfully removed"

    redirect_to(url_for(action: "edit", id: @user.id, company_id: @company.id) + "#avatar")
  end  

  private

  def find_user
    @user = User.friendly.find(params[:id])
    @team_member = @company.team_members.where(user_id: @user.id).first!
  end

  def user_params
    params.require(:user).permit(:email, :nickname, :username, :avatar, :first_name, 
      :last_name, :password, :password_confirmation)
  end
end