module Questions
  module Visibility

    extend ActiveSupport::Concern

    included do
      symbolize :visibility

      # make visibility options [:public, :private] readable
      # on both classes and instances
      cattr_reader :visibility_options

      validates :visibility, presence: true, inclusion: {in: :visibility_options}

      after_initialize :set_visibility_options, :set_default_visibility

      scope :include_private, ->(val){
        items = all

        if [nil, false].include?(val)
          items = items.where(visibility: :public)
        end

        items
      }

      def private?
        visibility == :private
      end

      def public?
        visibility == :public
      end

      private

      def set_visibility_options
        @@visibility_options ||= [:public, :private]
      end


      def set_default_visibility
        if visibility.nil?
          if company && company.default_questions_to_public
            self.visibility = :public
          else
            self.visibility = :private
          end
        end
      end
    end
  end
end
