class ReminderCalendarTruck < ActiveRecord::Base
  belongs_to :users
  belongs_to :truck
  belongs_to :messages_truck_available_calendar
end
