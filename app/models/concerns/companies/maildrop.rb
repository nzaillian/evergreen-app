module Companies
  module Maildrop

    extend ActiveSupport::Concern

    included do |base|
    
      before_create :generate_maildrop_address

      def maildrop_address
        raw = read_attribute(:maildrop_address)
        "#{raw}@#{Rails.application.config.domain}"
      end

      private

      def generate_maildrop_address
        prefix = "maildrop"

        self.maildrop_address = loop do
          random_address = prefix + SecureRandom.hex(3)
          break random_address unless self.class.where(maildrop_address: random_address).exists?
        end
      end              
    end
  end
end