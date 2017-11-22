class CreateTaskAvailableCalendars < ActiveRecord::Migration
  def change
    create_table :task_available_calendars do |t|
      t.integer :account_id
      t.integer :user_id, null: true
      t.integer :author
      t.datetime :start_time
      t.datetime :end_time
      t.integer :subtask_staff_group_id
      t.timestamps
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :subtask_staff_groups
      t.foreign_key :users, column: :user_id
      t.foreign_key :users, column: :author
    end
    add_index :task_available_calendars, :account_id
    add_index :task_available_calendars, :user_id
    add_index :task_available_calendars, :subtask_staff_group_id
  end
end
