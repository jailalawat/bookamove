class CreateTaskMessageTaskCalendars < ActiveRecord::Migration
  def change
    create_table :task_message_task_calendars do |t|
      t.integer :account_id
      t.integer :subtask_staff_group_id
      t.integer :messages_task_calendar_id
      t.boolean :readed

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :subtask_staff_groups
      t.foreign_key :messages_task_calendars
      t.timestamps
    end
    add_index :task_message_task_calendars, :account_id
    add_index :task_message_task_calendars, :subtask_staff_group_id
    add_index :task_message_task_calendars, :messages_task_calendar_id
  end
end
