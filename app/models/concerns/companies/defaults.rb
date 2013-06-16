module Companies
  module Defaults

    extend ActiveSupport::Concern

    included do |base|
      after_initialize :set_defaults

      private

      def set_defaults
        if welcome_message.nil?
          msg = <<-eos
            Welcome to our community!
            If you have questions to ask or suggestions 
            to make concerning our product,
            we're here to have a conversation with you!
            If you're not finding what you're looking for,
            refer to the links below.
            We look forward to talking!
          eos
          self.welcome_message = msg.gsub("\n", "").gsub(/\s+/, " ")
        end

        if welcome_message_sidebar_widget_title.nil?
          self.welcome_message_sidebar_widget_title = "Message from #{name}"
        end
      end    
    end
  end
end
