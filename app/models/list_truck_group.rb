class ListTruckGroup < ActiveRecord::Base
  belongs_to :calendar_truck_group
  belongs_to :truck
end
