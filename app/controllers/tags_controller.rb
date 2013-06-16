class TagsController < ApplicationController
  prepend_before_filter :find_company, only: collection_actions
  before_filter :find_tag, only: member_actions

  handles_sortable_columns

  helper_method :sort_order

  layout "site_main"

  def index
    @tags = @company.tags.filter(params[:filters]).order(sort_order).page(params[:page])
    
    @tag = Tag.new

    if request.xhr?
      respond_to do |format|
        format.json { 
          render json: {
            status: :success,
            tags: @tags,
            html: render_content(partial: "/tags/tag_dropdown_content")
          } 
        }
      end
    end
  end

  def show
  end

  def create
    @tag = @company.tags.new(tag_params)

    if @tag.save
      
      render json: {
        status: :success,
        tag: @tag,
        html: render_content(partial: "/tags/removable_tag", locals: {tag: @tag}) 
      }
    else
      @tags = Tag.none
      render json: {
        status: :err,
        tag: @tag,
        html: render_content(partial: "/tags/tag_dropdown_content", locals: {tag: @tag}) 
      }
    end
  end

  private

  def sort_order
    sortable_column_order || "score DESC"
  end
  
  def find_tag
    @tag = Tag.friendly.find(params[:id])
    @company = @tag.company
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end