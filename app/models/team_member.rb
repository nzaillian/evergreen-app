class TeamMember < ActiveRecord::Base
  include TeamMembers::Roles, Common::Uuid

  delegate :first_name, :last_name, to: :user

  belongs_to :company
  belongs_to :user, touch: true

  symbolize :role, :status

  validates :email, presence: true, uniqueness: {scope: :company_id},
             if: ->(team_member){ team_member.user.nil? }

  validates :user_id, uniqueness: {scope: :company_id}, allow_blank: true

  validates :role, presence: true

  validates :title, presence: true

  scope :admins, ->{ where(role: :admin) }

  scope :question_notifiable, ->{ 
    where("team_members.notify_of_new_questions = ? AND user_id IS NOT NULL", true)
  }

  scope :comment_and_answer_notifiable, ->{ 
    where("team_members.notify_of_new_answers_or_comments = ? AND user_id IS NOT NULL", true)
  }  

  after_initialize :init

  before_destroy :confirm_not_company_owner

  def email
    if user
      user.email
    else
      read_attribute(:email)
    end
  end

  private

  def init
    self.role = :admin if role.nil?
    self.token = gen_token if token.nil?
    self.title = "Team Member" if title.nil?
    self.notify_of_new_questions = true if notify_of_new_questions.nil?
    self.notify_of_new_answers_or_comments = false if notify_of_new_answers_or_comments.nil?
    self.featured = false if featured.nil?
  end

  def gen_token
    loop do
      random_token = String.random_alphanumeric(32)
      break random_token unless self.class.where(token: random_token).exists?      
    end
  end

  def confirm_not_company_owner
    if company.owner == user
      self.errors[:base] << "Team member could not be removed because account is"\
      " primary administrative account for company"
      return false
    end
  end
end
