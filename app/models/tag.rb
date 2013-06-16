class Tag < ActiveRecord::Base
  include Tags::Filter, Tags::Search

  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: {scope: :company_id}, 
            length: {maximum: 34}

  belongs_to :company

  has_many :question_tags, dependent: :destroy
  has_many :questions, through: :question_tags

  after_initialize :init

  scope :none, ->{ where("1 = 0") }

  def name=(val)
    if val.class == String
      write_attribute(:name, val.downcase)
    else
      write_attribute(:name, val)
    end
  end

  def update_score!
    update_column :score, question_tags.size
    update_column :updated_at, current_time_from_proper_timezone
  end

  def init
    self.score = 0 if score.nil?
  end
end
