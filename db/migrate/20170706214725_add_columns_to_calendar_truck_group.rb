class AddColumnsToCalendarTruckGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :calendar_truck_groups, :province_id, :integer
    add_column :calendar_truck_groups, :city_id, :integer
    add_column :calendar_truck_groups, :locale_id, :integer
  end
end
