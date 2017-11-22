class MessagesTaskCalendar < ActiveRecord::Base
  belongs_to :user
  belongs_to :calendar_staff_groups

  has_many :task_message_task_calendar
  has_many :user_message_task_calendar
  has_many :reminder_calendar_task

  def self.get_attachments(account_id, messages_task_calendar_id)
    TaskCalendarAttachment.where(account_id: account_id, messages_task_calendar_id: messages_task_calendar_id)
  end
end
