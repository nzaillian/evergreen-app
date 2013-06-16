module Questions
  module Search
    extend ActiveSupport::Concern

    included do
      scope :search, ->(filters){
        items = all

        if filters[:query].present?
          # Query over indexes for question, answer and comment (we consider answer and comment bodies
          # a part of the question entity for purposes of user search)
          join_conditions = "LEFT OUTER JOIN answers answer ON answer.question_id = questions.id " +
                            "LEFT OUTER JOIN comments comment ON comment.answer_id = answer.id"

          sql_conditions = "questions.tsv @@ plainto_tsquery(:query) OR " +
                           "answer.tsv @@ plainto_tsquery(:query) OR " +
                           "comment.tsv @@ plainto_tsquery(:query)"

          # concatenate all columns being queried over into one value
          # we'll call the "document" (so you'll be able to read a Question#document
          # instance attribute on questions and see all text searched over on that instance)
          selects = "DISTINCT ON(questions.id) questions.*, COALESCE(questions.title, '') || '...' || COALESCE(questions.body, '') || " +
          " '...' || COALESCE(answer.body, '') || '...' || COALESCE(comment.body, '') AS document"

          items = items.select(selects)
               .where(sql_conditions, query: filters[:query]).joins(join_conditions)
        end

        if filters[:title].present?
          items = items.where("title LIKE ?", "%#{filters[:title]}%")
        end

        if filters[:author].present?
          user_ids = User.search(filters[:author]).map(&:id)
          items = items.where("user_id IN (?)", user_ids)
        end

        if filters[:min_date].present? && filters[:max_date].present?

          items = items.where("created_at >= :min AND created_at <= :max",
            min: filters[:min_date], max: filters[:max_date])
        end

        items
      }
    end    
  end
end