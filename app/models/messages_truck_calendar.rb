class MessagesTruckCalendar < ActiveRecord::Base
  belongs_to :user
  belongs_to :calendar_truck_group

  has_many :task_message_truck_calendar
  has_many :user_message_truck_calendar
  has_many :reminder_calendar_move_record

  def self.get_attachments(account_id, messages_truck_calendar_id)
    TruckCalendarAttachment.where(account_id: account_id, messages_truck_calendar_id: messages_truck_calendar_id)
  end
end
