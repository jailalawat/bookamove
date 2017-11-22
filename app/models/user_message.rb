class UserMessage < ActiveRecord::Base
  belongs_to :message, touch: true
  belongs_to :user

  after_create_commit :notification_job
  after_commit :clear_cache

  def self.update_trash_notification(msg)
    NotificationRelayJob.perform_later({type: "personal", recipient_id: msg.user_id, message: msg.message, readed: msg.readed, mode: "trash"})
  end

  def self.update_readed_notification(msg)
    NotificationRelayJob.perform_later({type: "personal", recipient_id: msg.user_id, message: msg.message, readed: msg.readed, mode: "readed"})
  end

  private

  def notification_job
    NotificationRelayJob.perform_later({type: "personal", recipient_id: self.user_id, message: self.message, from_name: self.message.user.name, to_name: self.user.name, readed: self.readed, mode: "create"})
  end

  def clear_cache
    Rails.cache.delete("all_user_messages/#{self.user_id}")
  end

end