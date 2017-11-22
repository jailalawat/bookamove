class TaskMessageTaskCalendar < ActiveRecord::Base
  belongs_to :messages_task_calendar
  belongs_to :subtask_staff_group
end
