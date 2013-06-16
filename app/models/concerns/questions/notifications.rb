module Questions
  module Notifications
    extend ActiveSupport::Concern

    included do
      after_create :send_notifications

      private

      def send_notifications
        # notify watching team members
        company.team_members.question_notifiable.each do |team_member|
          Delayed::Job.enqueue(MailerJob.new(QuestionMailer, :notification, id, team_member.user_id))
        end
      end
    end
  end
end