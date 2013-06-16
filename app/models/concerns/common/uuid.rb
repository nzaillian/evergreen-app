module Common
  module Uuid
    extend ActiveSupport::Concern

    included do
      before_create :generate_uuid

      private

      def generate_uuid(opts={})
        if uuid.blank? || opts[:force] == true
          self.uuid = loop do
            random_uuid = UUIDTools::UUID.random_create.to_s
            break random_uuid unless self.class.where(uuid: random_uuid).exists?
          end
        end
      end
    end
  end
end