class Question < ActiveRecord::Base
  include Questions::Visibility, Questions::Search, 
          Questions::Sort, Questions::Tags, Questions::Notifications,
          Common::Uuid

  extend FriendlyId

  friendly_id :uuid

  paginates_per 20

  belongs_to :company, touch: true
  belongs_to :user

  has_many :answers
  has_many :comments, through: :answers
  has_many :votes, as: :votable

  has_many :question_tags
  has_many :tags, through: :question_tags

  belongs_to :accepted_answer, class_name: "Answer"

  accepts_nested_attributes_for :question_tags

  validates :title, presence: true

  validates :body, presence: true
  
  after_initialize :init

  after_save :update_dependent_models

  def update_score!
    update(score: votes.size)
  end

  def self.common_accessible_attributes
    [:title, :body, :update_tags, tag_ids: []]
  end

  def aggregate_votes
    votable_ids = [id] + comments.map(&:id) + answers.map(&:id)
    Vote.where("votable_id IN (?)", votable_ids)
  end

  def self.pagination_window
    10
  end

  def participants
    user_ids = [user_id] + answers.map(&:user_id) + comments.map(&:user_id)
    User.where("id IN (?)", user_ids.uniq)
  end

  private

  def init
    self.score = 0 if score.nil?
    self.last_response_date = current_time_from_proper_timezone if last_response_date.nil?
  end

  def update_dependent_models
    if id.present? && (accepted_answer_id_changed? || accepted_answer_id.nil?)
      answers.update_all(accepted: false)
      accepted_answer.update!(accepted: true) if accepted_answer
    end
  end
end
