class ReminderCalendarMoveRecord < ActiveRecord::Base
  belongs_to :users
  belongs_to :truck
  belongs_to :messages_truck_calendar
end
