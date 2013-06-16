require_relative "../spec_helper"

describe QuestionsController, type: :controller do
  include Devise::TestHelpers

  before do
    @company = FactoryGirl.create(:company)

    @team_member = FactoryGirl.create(:user)

    # (the association)
    TeamMember.create!(
      company: @company, 
      user: @team_member,
      email: @team_member.email
    )

    @question = FactoryGirl.create(:question)
    @question.visibility = :private
    @question.company = @company
    @question.save!

    # user who does not belong to company
    @user = FactoryGirl.create(:user)
  end

  it "will bounce a user to login who tries to view a private question" do
    get :show, id: @question
    
    response.should redirect_to(new_user_session_path)

    flash[:warning].should =~ /you aren't authorized/i    
  end

  it "will let a user view his own private question" do
    sign_in @question.user

    get :show, id: @question

    response.should be_success
  end

  it "will let a team member view a private question" do
    sign_in @team_member

    get :show, id: @question

    response.should be_success    
  end
end