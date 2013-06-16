module Tags
  module Search
    extend ActiveSupport::Concern

    included do
      scope :search, ->(filters){
        items = all

        if filters[:name].present?
          items = items.where("name LIKE ?", "%#{filters[:name]}%")
        end

        items
      }
    end
  end
end