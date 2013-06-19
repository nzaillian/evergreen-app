class Admin::CompaniesController < Admin::AdminController
  prepend_before_filter :find_company, only: member_actions

  set_tab :company_settings

  def index
    @companies = current_user.companies
    render layout: "plain"
  end

  def new
    @company = Company.new
    render layout: "plain"
  end

  def create
    @company = Company.new(company_params.merge(owner_id: current_user.id))

    if @company.save
      current_user.companies << @company
      flash[:notice] = "Company details successfully added"
      redirect_to current_user.home_path
    else
      render "new"
    end
  end

  def update
    @company.attributes = company_params

    authorize! :modify, @company

    if @company.save
      flash[:notice] = "Settings updated successfully"
      redirect_to(url_for(action: "edit", id: @company.id) + (params[:section] || ""))
    else
      render action: "edit", layout: "settings"
    end
  end

  def edit
    authorize! :view_settings, @company

    @team_member = @company.team_members.find_by_user_id(current_user.id)

    # bounce to admin user account edit if not an "admin"-role user
    if @team_member.role != :admin
      redirect_to(edit_admin_user_path(current_user, company_id: @company.id)) and return
    end

    render layout: "settings"
  end

  def delete_logo
    @company = Company.friendly.find(params[:company_id])

    authorize! :modify, @company

    @company.remove_logo = true

    @company.save!

    flash[:warning] = "Logo successfully removed"

    redirect_to(url_for(action: "edit", id: @company.id) + "#branding")
  end

  def delete_favicon
    @company = Company.friendly.find(params[:company_id])

    authorize! :modify, @company

    @company.remove_favicon = true

    @company.save!

    flash[:warning] = "Favicon successfully removed"

    redirect_to(url_for(action: "edit", id: @company.id) + "#branding")
  end

  private

  def company_params
    (params.require(:company).permit(Company.common_accessible_attributes) if params[:company]) || {}
  end

  def find_company
    @company = Company.friendly.find(params[:id])
  end
end
