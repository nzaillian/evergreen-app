module Questions
  module Tags
    extend ActiveSupport::Concern

    included do

      attr_accessor :update_tags

      validate :has_no_more_than_three_tags

      after_save :derive_tags

      # Allows us to assign tags via the
      # m2m relation (QuestionTag) by just 
      # assigning an array of ID values
      # corresponding to the ids of the tags we want to assign
      def tag_ids=(vals)
        @_tag_ids = vals.map &:to_i
      end

      private

      def derive_tags
        if update_tags
          new_ids = @_tag_ids || []

          existing_ids = tags.map &:id
          to_add = new_ids - existing_ids
          to_remove = existing_ids - new_ids

          to_add.each do |val|
            tag = company.tags.find(val)
            self.tags << tag
          end

          to_remove.each do |val|
            self.tags.destroy(Tag.find(val))
          end

          self.tag_names = tags.map(&:name).join(" ")
        end
      end

      def has_no_more_than_three_tags
        if @_tag_ids && @_tag_ids.length > 3
          self.errors[:base] << "You cannot add more than 3 tags to a question"
        end
      end
    end
  end
end