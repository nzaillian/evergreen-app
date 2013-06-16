class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :for_questions, ->{ where("votable_type = 'Question'") }
  scope :for_question, ->(question){ for_questions.where(votable_id: question.id) }

  scope :for_answers, ->{ where("votable_type = 'Answer'") }
  scope :for_answer, ->(answer){ for_answers.where(votable_id: answer.id) }

  scope :for_comments, ->{ where("votable_type = 'Comment'") }
  scope :for_comment, ->(comment){ for_comments.where(votable_id: comment.id) }  

  after_create :update_dependent!

  after_destroy :update_dependent!

  validate :user_unique_in_votable_scope

  private

  def user_unique_in_votable_scope
    if votable.votes.where(user_id: user_id).size > 0
      self.errors[:base] << "you have already voted on this item"
    else
      true
    end
  end

  def update_dependent!
    votable.send(:update_score!) if votable.respond_to?(:update_score!)
    votable.touch
  end
end