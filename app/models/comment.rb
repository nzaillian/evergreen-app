class Comment < ActiveRecord::Base
  include Comments::Notifications

  belongs_to :answer, touch: true
  belongs_to :user
  belongs_to :company

  has_one :question, through: :answer

  has_many :votes, as: :votable

  validates :body, presence: true

  after_initialize :init

  before_create :derive_company

  after_touch :update_score!

  after_create :update_dependent_models

  def update_score!
    update_column :score, votes.size
  end  

  private

  def init
    self.score = 0 if score.nil?
  end

  def derive_company
    self.company = question.company
  end  

  def update_dependent_models
    question.update_attributes(last_response_date: created_at)
  end  
end