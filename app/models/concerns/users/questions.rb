module Users
  module Questions
    extend ActiveSupport::Concern

    included do
      def answered_or_commented_questions
        Question.all.joins("LEFT OUTER JOIN answers a ON a.question_id = questions.id " +
                           "LEFT OUTER JOIN comments c ON c.answer_id = a.id")
                    .where("a.user_id = :id OR c.user_id = :id", id: id).uniq
      end
    end
  end
end