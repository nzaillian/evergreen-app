class Admin::TagsController < Admin::AdminController
  prepend_before_filter :find_company, only: collection_actions
  before_filter :find_tag, only: member_actions
  layout "plain"

  handles_sortable_columns  

  def index
    order = sortable_column_order || "name ASC"
    @tags = @company.tags.search(params[:filters]).order(order).page(params[:page])
    render layout: "admin"
  end

  def new
    @tag = @company.tags.new
  end

  def create
    @tag = @company.tags.new(tag_params)

    if @tag.save
      flash[:notice] = "Tag created successfully"
      redirect_to action: "index", company_id: @company.id
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @tag.update_attributes(tag_params)
      flash[:notice] = "Tag updated successfully"
      redirect_to action: "index", company_id: @company.id
    else
      render "edit"
    end
  end

  def destroy
    @tag.destroy

    flash[:warning] = "Tag \"#{@tag.name}\" deleted successfully"

    redirect_to action: "index", company_id: @company.id
  end

  private

  def find_tag
    @tag = Tag.find(params[:id])
    @company = @tag.company
    authorize! :modify, @tag
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end