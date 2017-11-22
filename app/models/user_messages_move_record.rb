class UserMessagesMoveRecord < ActiveRecord::Base
  belongs_to :messages_move_record, touch: true
  belongs_to :user

  after_create_commit :notification_job
  after_commit :clear_cache

  def self.update_trash_notification(msg)
    NotificationRelayJob.perform_later({type: "personal_move_record", recipient_id: msg.user_id, message: msg.messages_move_record, readed: msg.readed, mode: "trash"})
  end

  def self.update_readed_notification(msg)
    NotificationRelayJob.perform_later({type: "personal_move_record", recipient_id: msg.user_id, message: msg.messages_move_record, readed: msg.readed, mode: "readed"})
  end

  private

  def notification_job
    NotificationRelayJob.perform_later({type: "personal_move_record", recipient_id: self.user_id, message: self.messages_move_record, from_name: self.messages_move_record.user.name, to_name: self.user.name, readed: self.readed, move_record_id: self.messages_move_record.move_record.id, move_record_name: self.messages_move_record.move_record.move_contract_name, mode: "create"})
  end

  def clear_cache
    Rails.cache.delete("all_user_messages/#{self.user_id}")
  end

end
