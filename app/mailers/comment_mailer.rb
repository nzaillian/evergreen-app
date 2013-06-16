class CommentMailer < ActionMailer::Base
  def notification(comment_id, recipient_id)
    @comment = Comment.find(comment_id)
    @recipient = User.find(recipient_id)

    mail(to: @recipient.email, subject: "New comment for question: \"#{@comment.question.title}\"")
  end
end