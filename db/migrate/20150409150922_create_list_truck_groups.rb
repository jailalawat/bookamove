class CreateListTruckGroups < ActiveRecord::Migration
  def change
    create_table :list_truck_groups do |t|
      t.integer :account_id
      t.integer :calendar_truck_group_id
      t.integer :truck_id
      t.timestamps
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :calendar_truck_groups
      t.foreign_key :trucks
    end
    add_index :list_truck_groups, :calendar_truck_group_id
    add_index :list_truck_groups, :account_id
    add_index :list_truck_groups, :truck_id
  end
end
