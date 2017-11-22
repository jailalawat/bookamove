class CreateJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :calendar_truck_groups, :provinces do |t|
      t.index [:calendar_truck_group_id, :province_id], name: :idx_calendar_truck_group_id_province_id
      t.index [:province_id, :calendar_truck_group_id], name: :idx_province_id_calendar_truck_group_id
    end
  end
end
