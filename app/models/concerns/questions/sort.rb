module Questions
  module Sort
    extend ActiveSupport::Concern

    included do |base|
      scope :sort, ->(sort_order){
        if sort_order == "recently_added"
          order("created_at DESC")
        elsif sort_order == "recently_responded_to"
          order("last_response_date DESC")          
        elsif sort_order == "popular"
          order("score DESC")
        else
          all
        end
      }
    end
  end
end