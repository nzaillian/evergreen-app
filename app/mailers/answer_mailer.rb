class AnswerMailer < ActionMailer::Base
  def notification(answer_id, recipient_id)
    @answer = Answer.find(answer_id)
    @recipient = User.find(recipient_id)

    mail(to: @recipient.email, subject: "New answer for question: \"#{@answer.question.title}\"")
  end
end