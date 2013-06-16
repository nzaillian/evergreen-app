class AnswersController < ApplicationController
  prepend_before_filter :find_company, only: collection_actions
  before_filter :find_answer, only: member_actions
  before_filter :require_login, only: [:votes, :create]
  before_filter :add_edit_breadcrumbs, only: [:edit, :update]

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      answer_partial = render_to_string(partial: "/answers/answer", locals: {answer: @answer}).html_safe
      new_form = render_to_string(partial: "/answers/form", locals: {answer: Answer.new(question_id: @answer.question_id)}).html_safe
      render json: {status: "success", answer: @answer, partial: answer_partial, new_form: new_form}
    else
      form = render_to_string(partial: "/answers/form", locals: {answer: @answer}).html_safe
      render json: {status: "err", answer: @answer, form: form}
    end
  end

  def edit    
    authorize! :modify, @answer
  end

  def update
    @answer.attributes = answer_params

    authorize! :modify, @answer

    if @answer.save
      flash[:notice] = "Answer updated successfully"
      redirect_to question_path(@answer.question)
    else
      render "edit"
    end
  end

  def destroy
    authorize! :modify, @answer

    @answer.destroy

    flash[:warning] = "Answer successfully deleted"

    redirect_to question_path(@answer.question)
  end

  def votes
    @answer = Answer.find(params[:answer_id])
    
    if request.post?
      @vote = @answer.votes.new(user_id: current_user.id)

      if @vote.save
        @answer.reload
        render json: {status: "success", answer: @answer, vote: @vote, total: @answer.score}
      else
        render json: {status: "err", answer: @answer, vote: @vote}
      end

    elsif request.delete?
      @votes = current_user.votes.for_answer(@answer)
      @votes.each do |vote|
        vote.destroy!
      end
      @answer.reload
      render json: {status: "success", answer: @answer, votes: @votes, total: @answer.score}
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
    @company = @answer.company
  end

  def answer_params
    if admin?
      permitted = params.require(:answer).permit(:body, :question_id, :user_id)

      if params[:answer][:user_id].blank?
        permitted[:user_id] = current_user.id
      end
    else
      permitted = params.require(:answer).permit(:body, :question_id).merge(user_id: current_user.id)
    end

    permitted    
  end

  def add_base_breadcrumbs
    add_breadcrumb "Discussions", company_questions_path(@company)
    add_breadcrumb truncate(@answer.question.title, length: 20), question_path(@answer.question)
  end  

  def add_edit_breadcrumbs
    add_base_breadcrumbs
    add_breadcrumb "Edit My Answer", edit_answer_path(@answer)
  end
end