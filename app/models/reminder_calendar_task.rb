class ReminderCalendarTask < ActiveRecord::Base
  belongs_to :users
  belongs_to :subtask_staff_group
  belongs_to :messages_task_calendar
end
