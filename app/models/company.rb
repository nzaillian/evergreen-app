class Company < ActiveRecord::Base
  include Companies::Defaults, Companies::Maildrop, Common::Uuid

  extend FriendlyId

  friendly_id :name, use: :slugged

  mount_uploader :logo, CompanyLogoUploader
  mount_uploader :favicon, CompanyFaviconUploader  

  has_many :team_members

  has_many :team_member_users, class_name: "User",
           source: :user, through: :team_members

  has_many :questions

  has_many :answers

  has_many :comments

  has_many :tags

  has_many :links

  accepts_nested_attributes_for :links

  belongs_to :owner, class_name: "User"

  validates :name, presence: true, length: {maximum: 50}

  validates :tagline, length: {maximum: 200}

  validates :description, length: {maximum: 500}

  validates :slug, presence: true, uniqueness: true,
            format: {
              with: /\A[a-z]{1}[a-z0-9\-_]*\Z/, 
              message: "is invalid (only lowercase alphanumeric characters, "+
                        "hyphens and underscores allowed)"
            }

  validate :slug_is_not_reserved_route

  validates :welcome_message, length: {maximum: 400}

  after_initialize :init

  after_update :update_dependent_models

  def self.common_accessible_attributes
    [:name, :description, :tagline, :welcome_message, 
      :auto_create_questions_from_email, :default_questions_to_public,
      :site_public, :logo, :favicon, :styles, :cname, :slug,
      :welcome_message_sidebar_widget_enabled, :site_links_sidebar_widget_enabled,
      :tag_box_sidebar_widget_enabled, :welcome_message_sidebar_widget_title
    ]
  end

  def admin_users
    User.where("id IN (?)", team_members.admins.map(&:user_id))
  end

  private

  def init
    self.auto_create_questions_from_email = true if auto_create_questions_from_email.nil?
    self.default_questions_to_public = true if default_questions_to_public.nil?
    self.site_public = true if site_public.nil?
  end

  def update_dependent_models
    if site_public_changed?
      questions.update_all(site_public: site_public)
    end
    team_member_users.update_all(updated_at: current_time_from_proper_timezone)
  end

  def slug_is_not_reserved_route
    if ["new"].include?(slug)
      errors[:slug] << "conflicts with an existing URL on our site"
    end
  end    
end
