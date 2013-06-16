module Users
  module TeamAssignable
    extend ActiveSupport::Concern

    private

    def assign_to_team_from_params!(user, params)
      if params[:team_member_id].present? && params[:team_member_token].present?
        @team_member = TeamMember.find(params[:team_member_id])

        if @team_member.token != params[:team_member_token]
          raise CanCan::AccessDenied.new("Invalid token used for team member assignment")
        end

        existing = @team_member.company.team_members.where(user_id: user.id)

        if existing.size == 0

          @team_member.user = user

          @team_member.save!

        end
      end
    end
  end
end