class MailPreview < MailView
  def question_notification
    question = Question.first
    user = question.company.team_members.first.user
    mail = QuestionMailer.notification(question.id, user)
    mail
  end
end