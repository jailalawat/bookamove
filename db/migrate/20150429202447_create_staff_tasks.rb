class CreateStaffTasks < ActiveRecord::Migration
  def change
    create_table :staff_tasks do |t|
      t.integer :account_id
      t.integer :subtask_staff_group_id
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :hours, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :rate, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :total_pay, :precision => 10, :scale => 2, :default => 0.0
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :subtask_staff_groups
      t.timestamps
    end
    add_index :staff_tasks, :account_id
    add_index :staff_tasks, :subtask_staff_group_id
    add_index :staff_tasks, :user_id
  end
end
