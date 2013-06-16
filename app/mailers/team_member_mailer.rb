class TeamMemberMailer < ActionMailer::Base
  def invitation(team_member_id)
    @team_member = TeamMember.find(team_member_id)

    mail(to: @team_member.email, subject: "You have been added to a Evergreen team")
  end
end