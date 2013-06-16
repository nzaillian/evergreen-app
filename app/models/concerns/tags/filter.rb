module Tags
  module Filter
    extend ActiveSupport::Concern

    included do
      scope :filter, ->(filters) {
        items = all
        
        if filters[:term].present?
          items = items.where("name LIKE :term", term: "%#{filters[:term].downcase}%")
        end

        if filters[:exclude].present?
          items = items.where("id NOT IN (?)", filters[:exclude])
        end

        items
      }
    end
  end
end