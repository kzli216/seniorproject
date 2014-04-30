class ModelMailer < ActionMailer::Base
  default from: "admin@metamorphosis.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_record_notification.subject
  #
  def new_record_notification(record)
      @record = record
      @phase = Phase.find(record.phase_id)
      @goal = Goal.find(@phase.goal_id)
      @user = User.find(@goal.user_id)

      mail to: @user.email, subject: "Don't Break The Streak!"
    end
end
