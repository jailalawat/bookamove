class CreateTruckAvailable < ActiveRecord::Migration
  def change
    create_table :truck_availables do |t|
      t.integer :account_id
      t.integer :truck_id
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :available
      t.timestamps
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :trucks
    end
    add_index :truck_availables, :account_id
    add_index :truck_availables, :truck_id
  end
end
