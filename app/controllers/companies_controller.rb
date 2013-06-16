class CompaniesController < ApplicationController
  before_filter :find_company, only: member_actions

  def show
    redirect_to company_questions_path(@company)
  end

  private

  def find_company
    @company = Company.friendly.find(params[:id])
  end  
end