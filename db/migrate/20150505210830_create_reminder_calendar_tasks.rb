class CreateReminderCalendarTasks < ActiveRecord::Migration
  def change
    create_table :reminder_calendar_tasks do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :subtask_staff_group_id
      t.integer :author
      t.datetime :date
      t.string :comment

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users, column: :user_id
      t.foreign_key :users, column: :author
      t.foreign_key :subtask_staff_groups
      t.timestamps
    end
    add_index :reminder_calendar_tasks, :account_id
    add_index :reminder_calendar_tasks, :user_id
    add_index :reminder_calendar_tasks, :author
    add_index :reminder_calendar_tasks, :subtask_staff_group_id
  end
end
