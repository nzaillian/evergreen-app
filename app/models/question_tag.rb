class QuestionTag < ActiveRecord::Base
  belongs_to :question, touch: true
  belongs_to :tag

  validates :question_id, uniqueness: {scope: :tag_id}

  after_create :update_tag_score!

  after_destroy :update_tag_score!

  private

  def update_tag_score!
    tag.update_score!
  end
end
