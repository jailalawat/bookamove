class UserMessageTaskCalendar < ActiveRecord::Base
  belongs_to :messages_task_calendar
  belongs_to :user
end
