module Users
  module Search
    extend ActiveSupport::Concern

    included do
      scope :search, ->(term){
        where(
          "first_name LIKE :term OR last_name LIKE :term OR email LIKE :term OR nickname LIKE :term",
          term: "%#{term}%"
        )
      }
    end
  end
end