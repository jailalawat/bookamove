class AddFieldAddressToCalendarTruckGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :calendar_truck_groups, :address, :string
  end
end
