class CreateStaffAvailables < ActiveRecord::Migration
  def change
    create_table :staff_availables do |t|
      t.integer :account_id
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :available
      t.timestamps
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
    end
    add_index :staff_availables, :account_id
    add_index :staff_availables, :user_id
  end
end
