class Answer < ActiveRecord::Base
  include Answers::Search, Answers::Notifications

  belongs_to :question, touch: true
  belongs_to :user
  belongs_to :company

  has_many :comments
  has_many :votes, as: :votable

  validates :body, presence: true

  validates :question_id, presence: true

  after_initialize :init

  scope :for_company, ->(company){ where(company_id: company.id) }

  # order by score BUT prepend accepted
  # answer for question to front of the set
  # irrespective of score
  scope :by_importance, ->(question){
    ids = order("accepted DESC, score DESC")
  }

  before_create :derive_company

  after_touch :update_score!

  after_save :update_dependent_models

  def update_score!
    update!(score: votes.size)
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