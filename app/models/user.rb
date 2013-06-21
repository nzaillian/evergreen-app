class User < ActiveRecord::Base
  # this is a hack around load order issues in the
  # edge version of devise (https://github.com/rails/rails/issues/10559). 
  # and Rails 4 rc. I consider it smell and
  # will refactor out as soon as devise has addressed the root issue.
  load_concerns "users", "common"

  include Users::LoginAuthenticatable, Users::Urls, Users::Search, 
          Users::Questions, Users::Roles, Common::Uuid

  extend FriendlyId

  friendly_id :nickname, use: :slugged

  devise :database_authenticatable, :registerable, :recoverable, :validatable,
         authentication_keys: [:login]

  validates :nickname, presence: true

  validates :username, presence: true, uniqueness: true, reduce: true

  validates :email, presence: true,
            format: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/,
            uniqueness: true, reduce: true

  after_initialize :init

  mount_uploader :avatar, AvatarUploader

  has_one :owned_company, class_name: "Company", foreign_key: :owner_id

  has_many :team_members, dependent: :destroy #relation
  has_many :companies, through: :team_members

  has_many :questions

  has_many :answers

  has_many :comments

  has_many :votes

  before_destroy :prohibit_destroy

  after_update :update_dependent_models

  private

  def init
    self.company_owner = false if company_owner == nil
    self.notify_of_responses_to_questions = true if notify_of_responses_to_questions.nil?
    self.notify_of_responses_to_participated_in = false if notify_of_responses_to_participated_in.nil?
  end

  # for data integrety reasons, user accounts cannot 
  # be destroyed - they can only be cancelled
  def prohibit_destroy
    errors[:base] << "User accounts cannot be destroyed. " +
      "They can only be cancelled."
    false
  end

  # we want to expire all caches for associated 
  # questions/answers/comments
  def update_dependent_models
    questions.map &:touch
    answers.update_all(updated_at: current_time_from_proper_timezone)
    comments.update_all(updated_at: current_time_from_proper_timezone)
  end

  def should_generate_new_friendly_id?
    nickname_changed? && nickname.present?    
  end
end
