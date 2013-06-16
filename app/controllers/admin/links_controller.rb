class Admin::LinksController < Admin::AdminController
  prepend_before_filter :find_company, only: collection_actions(:batch_update)
  before_filter :find_link, only: member_actions

  layout "admin"

  def new
    @link = @company.links.new
  end

  def create
    @link = @company.links.new(link_params)

    authorize! :modify, @link

    if @link.save
      flash[:notice] = "New site link has been created successfully"
      redirect_to edit_admin_company_path(@company) + "#links"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    @link.attributes = link_params

    authorize! :modify, @link

    if @link.save
      flash[:notice] = "Site link updated"
      redirect_to edit_admin_company_path(@company) + "#links"
    else
      render action: "edit"
    end
  end

  def batch_update
    @links = params[:links]

    if @links
      @links.each_pair do |key, vals|
        link = Link.find(vals[:id])
        authorize! :modify, link
        link.attributes = batch_params(vals)
        link.save!
      end
    end

    flash[:notice] = "Settings updated successfully"

    render json: {status: :success}
  end

  def destroy
    @link.destroy
    flash[:warning] = "Site link successfully removed"
    redirect_to edit_admin_company_path(@company) + "#links"
  end

  private

  def find_link
    @link = Link.find(params[:id])
    @company = @link.company
    authorize! :modify, @link
  end

  def link_params
    params.require(:link).permit(:title, :url)
  end

  def batch_params(params_hash)
    filter_hash(params_hash, :position)
  end  
end