class QuestionMailer < ActionMailer::Base
  def notification(question_id, recipient_id)
    @question = Question.find(question_id)
    @recipient = User.find(recipient_id)

    mail(to: @recipient.email, subject: "New question posted")
  end
end