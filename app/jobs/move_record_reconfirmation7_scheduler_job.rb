class MoveRecordReconfirmation7SchedulerJob < ApplicationJob
  queue_as :default

  def perform(move_id, url, account_id, user_id)
    reconfirmed7 = MoveRecord.check_reconfirmed7_move_record(move_id, account_id)

    if (reconfirmed7[0]["total"].to_i == 0)
      email = EmailAlert.find_by(description: "Reconfirmation 7", account_id: account_id)

      MoverecordMail.stage_mail_sender(move_id, email.id.to_s, "", "", "", url, "").deliver_later

      move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: move_id, account_id: account_id, email_alert_id: email.id)
      move_status_email.user_id = user_id
      move_status_email.save

      message = MessagesMoveRecord.new
      message.account_id = account_id
      message.user_id = user_id
      message.subject = "Reconfirmation 7 Email"
      message.body = ""
      message.move_record_id = move_id
      message.message_type = 'email'
      message.save
    end

  end
end
