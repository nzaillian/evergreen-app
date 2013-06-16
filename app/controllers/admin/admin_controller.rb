class Admin::AdminController < ApplicationController
  layout "admin"

  private

  def find_company
    @company = Company.friendly.find(params[:company_id])
    authorize! :read, @company
  end
end
