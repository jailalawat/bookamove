class TaskMessageTruckCalendar < ActiveRecord::Base
  belongs_to :messages_truck_calendar
  belongs_to :subtask_staff_group
end
