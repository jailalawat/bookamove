class UserMessageTruckCalendar < ActiveRecord::Base
  belongs_to :messages_truck_calendar, touch: true
  belongs_to :user

  after_create_commit :notification_job
  after_commit :clear_cache

  def self.update_trash_notification(msg)
    NotificationRelayJob.perform_later({type: "personal_truck_calendar", recipient_id: msg.user_id, message: msg.messages_truck_calendar, readed: msg.readed, mode: "trash"})
  end

  def self.update_readed_notification(msg)
    NotificationRelayJob.perform_later({type: "personal_truck_calendar", recipient_id: msg.user_id, message: msg.messages_truck_calendar, readed: msg.readed, mode: "readed"})
  end

  private

  def notification_job
    NotificationRelayJob.perform_later({type: "personal_truck_calendar", recipient_id: self.user_id, message: self.messages_truck_calendar, from_name: self.messages_truck_calendar.user.name, to_name: self.user.name, readed: self.readed, mode: "create"})
  end

  def clear_cache
    Rails.cache.delete("all_user_messages/#{self.user_id}")
  end

end
