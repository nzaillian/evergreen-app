class Link < ActiveRecord::Base
  belongs_to :company, touch: true

  validates :title, presence: true

  validates :url, presence: true

  validates :company_id, presence: true

  default_scope ->{ order("position ASC") }

  before_create :derive_position

  private

  def derive_position
    self.position = company.links.size
  end
end