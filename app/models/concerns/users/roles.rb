module Users
  module Roles
    extend ActiveSupport::Concern

    included do
      def team_member(company)
        company.team_members.where(user_id: id).first
      end

      def team_member?(company)
        company.team_members.where(user_id: id).size > 0
      end
    end
  end
end