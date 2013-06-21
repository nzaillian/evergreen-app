class UsersController < ApplicationController
  layout "application"

  before_filter :find_user

  before_filter :find_company, only: [:edit]
  
  def show
    if params[:show] == "answered"
      @questions = @user.answered_or_commented_questions
    else
      @questions = @user.questions
    end

    @questions = @questions.include_private(team_member?)
                           .sort(params[:sort]).page(params[:page])

    render layout: "box"
  end  

  def edit
    authorize! :modify, @user
    render layout: "plain"
  end

  def update
    authorize! :modify, @user

    if @user.update(user_params)
      flash[:notice] = "Settings updated successfully"
      redirect_to(url_for(action: "edit", id: @user.id, company_id: params[:company_id]) + (params[:section] || ""))
    else
      render "edit", layout: "plain"
    end
  end


  def delete_avatar
    authorize! :modify, @user

    @user.remove_avatar = true

    @user.save!

    flash[:warning] = "Avatar successfully removed"

    redirect_to(url_for(action: "edit", id: @user.id) + "#avatar")
  end    

  private

  def find_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params[:user].present? ? params.require(:user).permit(:email, :nickname, :username, :avatar, :first_name, 
      :last_name, :password, :password_confirmation, :notify_of_responses_to_questions,
      :notify_of_responses_to_participated_in) : {}
  end  

  def find_company
    # may be nil - only used to (optionally) point admin
    # users to their email notification settings page
    # in the admin view (to edit the email notification 
    # related attributes of their associated "TeamMember"
    # record for company)
    @company = params[:company_id].present? ? Company.find_by_id(params[:company_id]) : nil
  end
end