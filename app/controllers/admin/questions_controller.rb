class Admin::QuestionsController < Admin::AdminController
  prepend_before_filter :find_company, only: collection_actions

  handles_sortable_columns

  def index
    order = sortable_column_order || "last_response_date DESC"
    @questions = @company.questions.search(params[:filters]).order(order).page(params[:page])
  end

  def show
  end

  def edit
  end
end
