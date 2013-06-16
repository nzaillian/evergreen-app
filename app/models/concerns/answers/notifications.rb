module Answers
  module Notifications
    extend ActiveSupport::Concern

    included do
      after_create :send_notifications

      private

      def send_notifications
        notifiable_team_members = company.team_members.comment_and_answer_notifiable
        
        notifiable_team_members.each do |team_member|
          Delayed::Job.enqueue(MailerJob.new(AnswerMailer, :notification, id, team_member.user_id))
        end

        question.participants.each do |participant|
          # filter out any users we just notified above
          if !notifiable_team_members.map(&:user_id).include?(participant.id) && participant.notify_of_responses_to_questions            
              Delayed::Job.enqueue(MailerJob.new(AnswerMailer, :notification, id, participant.id))
          end        
        end
      end
    end
  end
end