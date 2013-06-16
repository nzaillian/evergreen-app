module Users
  module LoginAuthenticatable
    extend ActiveSupport::Concern

    attr_accessor :login

    included do

      def self.find_for_database_authentication(warden_conditions)
        find_first_by_auth_conditions(warden_conditions)
      end      

      private 

      def self.find_first_by_auth_conditions(warden_conditions)
        conditions = warden_conditions.dup
        if login = conditions.delete(:login)
          where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
        else
          where(conditions).first
        end
      end      
    end
  end
end