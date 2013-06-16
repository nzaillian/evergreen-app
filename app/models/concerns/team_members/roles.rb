module TeamMembers
  module Roles
    extend ActiveSupport::Concern

    included do
      validate :forbid_non_admin_roles_for_company_owner

      def self.roles
        [:admin, :team_member]
      end

      def self.role_options
        {"Admin" => :admin, "Team member" => :team_member}
      end    

      def humanized_role
        mappings = {
          admin: "Admin",
          team_member: "Team member"
        }

        mappings[role]
      end

      private

      def forbid_non_admin_roles_for_company_owner
        if role != :admin && company.owner == user
          self.errors[:base] << "This account is designated as " +
            "the company owner and thus MUST have admin privileges."
        end
      end
    end
  end
end