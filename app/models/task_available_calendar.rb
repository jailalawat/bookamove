class TaskAvailableCalendar < ActiveRecord::Base
  belongs_to :subtask_staff_group
  belongs_to :user
end
