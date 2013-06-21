class QuestionsController < ApplicationController
  prepend_before_filter :find_company, only: collection_actions(:search)
  before_filter :find_question, only: member_actions(:accepted_answer)

  before_filter :add_show_authorizations_to_cookie, only: [:show]

  before_filter :require_login, only: [:votes, :edit]

  before_filter :add_base_breadcrumbs, only: [:new, :create, :show, :edit, :update]
  before_filter :add_member_breadcrumb, only: [:show, :edit, :update]
  before_filter :add_edit_breadcrumb, only: [:edit, :update]

  layout "site_main"

  def index    
    redirect_to(params.merge(sort: "popular")) if params[:sort].blank?
    load_questions
    add_index_authorizations_to_cookie
  end

  def search
    @questions = @company.questions.search(params[:question][:filters]).page(params[:page])
  end

  def new
    add_breadcrumb "New", new_company_question_path(@company)
    @question = @company.questions.new(question_params)
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = "Your question has been added"
      redirect_to question_path(@question)
    else
      add_breadcrumb "New", new_company_question_path(@company)
      render "new"
    end
  end

  def show
    authorize! :read, @question
  end

  def edit
    authorize! :modify, @question
  end

  def update
    @question.attributes = question_params

    authorize! :modify, @question

    if @question.save
      flash[:notice] = "Question updated successfully"
      redirect_to edit_question_path(@question)
    else
      render "edit"
    end
  end

  def destroy
    authorize! :modify, @question

    @question.destroy

    flash[:warning] = "You have successfully deleted your question"

    redirect_to company_questions_path(@question.company)
  end

  def votes
    @question = Question.find(params[:question_id])
    
    if request.post?
      @vote = @question.votes.new(user_id: current_user.id)

      authorize! :post, @vote

      if @vote.save
        @question.reload
        render json: {status: "success", vote: @vote, total: @question.score}
      else
        render json: {status: "err", vote: @vote}
      end

    elsif request.delete?
      @votes = current_user.votes.for_question(@question)
      @votes.each do |vote|
        vote.destroy!
      end
      @question.reload
      render json: {status: "success", votes: @votes, total: @question.score}
    end
  end
  
  def accepted_answer
    authorize! :modify, @question

    if request.post?
      flash[:notice] = "Answer accepted"
      @question.update!(accepted_answer: @question.answers.find(params[:answer_id]))
    elsif request.delete?
      flash[:notice] = "\"Accept Answer\" successfully undone"
      @question.update!(accepted_answer: nil)
    end

    redirect_to question_path(@question)
  end

  private

  def load_questions
    @questions = @company.questions.include_private(team_member?)
                         .includes(:tags).sort(params[:sort]).page(params[:page])
  end

  def find_question
    @question = Question.friendly.find(params[:id])
    @company = @question.company
    @_page_title = @question.title
  end

  def question_params
    permitted = params.require(:question).permit(Question.common_accessible_attributes).merge(company_id: @company.id)

    if team_member?
      permitted[:visibility] = params[:question][:visibility]
    end

    unless request.xhr?
      permitted[:tag_ids] ||= []
    end

    permitted
  end

  def add_index_authorizations_to_cookie
    if current_user
      voted_on = Vote.where("votable_id IN (?) AND user_id = ?", @questions.map(&:id), current_user.id)
                      .map { |v| {votable_id: v.votable_id, votable_type: v.votable_type} }
    else
      voted_on = []
    end

    cookies[:page_authorizations] = {
      value: {voted_on: voted_on}.to_json,
      :expires => 180.seconds.from_now        
    }
  end

  def add_show_authorizations_to_cookie
    if current_user
      if can?(:admin, @question)
        user_answer_ids = @question.answers.map(&:id)
        user_comment_ids = @question.comments.map(&:id)        
        question_ids = [@question.id]
      else
        user_answer_ids = current_user.answers.where(question_id: @question.id).map(&:id)
        user_comment_ids = @question.comments.where(user_id: current_user.id).map(&:id)
        
        if can?(:modify, @question)
          question_ids = [@question.id]
        else
          question_ids = []
        end
      end

      voted_on = @question.aggregate_votes.where(user_id: current_user.id)
                          .map { |v| {votable_id: v.votable_id, votable_type: v.votable_type} }

      cookies[:page_authorizations] = {
          value: {
            answer_ids: user_answer_ids,
            question_ids: question_ids,
            comment_ids: user_comment_ids,
            voted_on: voted_on
          }.to_json,

          :expires => 180.seconds.from_now        
      }

      cookies
    else
      cookies[:page_authorizations] = {
        value: {answer_ids: [], question_ids: [], comment_ids: [], voted_on_ids: []}.to_json,
        :expires => 180.seconds.from_now        
      }
    end
  end    

  def add_base_breadcrumbs
    add_breadcrumb "Discussions", company_questions_path(@company)
  end

  def add_member_breadcrumb
    add_breadcrumb truncate(@question.title, length: 20), question_path(@question)
  end

  def add_edit_breadcrumb
    add_breadcrumb "Edit", edit_question_path(@question)
  end  
end
