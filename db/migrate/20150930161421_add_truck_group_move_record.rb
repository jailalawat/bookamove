class AddTruckGroupMoveRecord < ActiveRecord::Migration
  def change
    add_column :locations, :calendar_truck_group_id, :integer
    add_foreign_key :locations, :calendar_truck_groups
    add_column :move_record_default_settings, :show_origin_calendar_truck_group, :boolean, default: true
    add_column :move_record_default_settings, :origin_calendar_truck_group_id, :integer, null: true
  end
end
