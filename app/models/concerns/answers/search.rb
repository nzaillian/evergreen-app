module Answers
  module Search
    extend ActiveSupport::Concern

    included do
      scope :search, ->(filters){
        if filters[:query].present?
          where("answers.tsv @@ plainto_tsquery('english', ?)", filters[:query])
        else
          all
        end
      }
    end
  end
end