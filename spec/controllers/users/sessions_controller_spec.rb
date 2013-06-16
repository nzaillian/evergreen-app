require_relative '../../spec_helper'

describe Users::SessionsController do
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    @user.password = @user.password_confirmation = 'password'
    @user.save!

    @company = FactoryGirl.create(:company)    
    @company2 = FactoryGirl.create(:company)
    
    @team_member = TeamMember.new(
      company_id: @company.id,
      user_id: @user.id
    )
    
    @team_member.save!
  end

  it "redirects a user to the company site he was initially on after he authenticates" do
    request.env["devise.mapping"] = Devise.mappings[:user] 
    
    initial_path = company_questions_path(@company2)    

    get :new, {company_id: @company2.id} # should stash company id in session

    post :create, user: {
        login: @user.username,
        password: 'password'
      }

    response.should redirect_to(initial_path) # should redirect based on stashed company
  end
end