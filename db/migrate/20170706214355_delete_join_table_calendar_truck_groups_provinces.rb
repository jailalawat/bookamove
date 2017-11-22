class DeleteJoinTableCalendarTruckGroupsProvinces < ActiveRecord::Migration[5.0]
  def change
    drop_table :calendar_truck_groups_provinces
  end
end
