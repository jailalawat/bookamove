class AddCalendarTruckGroupLinkToCity < ActiveRecord::Migration
  def change
    add_reference :cities, :calendar_truck_group, index: true, foreign_key: true
  end
end
