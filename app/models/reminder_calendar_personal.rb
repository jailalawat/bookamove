class ReminderCalendarPersonal < ActiveRecord::Base
  belongs_to :users
  belongs_to :messages_personal_calendar, :class_name => 'MessagesStaffAvailableCalendar', :foreign_key => 'messages_personal_calendar_id'
end
