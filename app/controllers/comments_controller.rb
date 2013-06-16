class CommentsController < ApplicationController
  prepend_before_filter :find_company, only: collection_actions
  before_filter :find_comment, only: member_actions
  before_filter :require_login, only: [:votes, :new, :edit]

  def new
    @answer = @company.answers.find(params[:answer_id])
    @comment = @answer.comments.new

    render json: {
      status: :success,
      comment: @comment,
      html: render_content(partial: "/comments/new")
    }
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: {
        status: :success,
        comment: @comment,
        html: render_content(partial: "/comments/comment", locals: {comment: @comment})
      }      
    else
      render json: {
        status: :err,
        comment: @comment,
        html: render_content(partial: "/comments/new")
      }            
    end
  end

  def edit    
  end

  def update
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Comment updated successfully"
      redirect_to question_path(@comment.question)
    else
      render action: "edit"
    end
  end

  def destroy
    @comment.destroy

    flash[:warning] = "Comment successfully removed"

    redirect_to question_path(@comment.question)
  end

  def votes
    @comment = Comment.find(params[:comment_id])
    
    if request.post?
      @vote = @comment.votes.new(user_id: current_user.id)

      if @vote.save
        @comment.reload
        render json: {status: "success", comment: @comment, vote: @vote, total: @comment.score}
      else
        render json: {status: "err", comment: @comment, vote: @vote}
      end

    elsif request.delete?
      @votes = current_user.votes.for_comment(@comment)
      @votes.each do |vote|
        vote.destroy!
      end
      @comment.reload
      render json: {status: "success", comment: @comment, votes: [], total: @comment.score}
    end
  end    

  private

  def find_comment
    @comment = Comment.find(params[:id])
    @company = @comment.company
    authorize! :modify, @comment
  end

  def comment_params
    if admin?
      permitted = params.require(:comment).permit(:answer_id, :body, :user_id)

      if params[:comment][:user_id].blank?
        permitted[:user_id] = current_user.id
      end
    else
      permitted = params.require(:comment).permit(:answer_id, :body).merge(user_id: current_user.id)
    end

    permitted
  end
end