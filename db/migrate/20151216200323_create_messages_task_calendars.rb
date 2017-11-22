class CreateMessagesTaskCalendars < ActiveRecord::Migration
  def change
    create_table :messages_task_calendars do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :calendar_staff_group_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.integer :urgent, default: 0
      t.datetime :date_calendar
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :calendar_staff_groups
      t.foreign_key :messages_task_calendars, column: :parent_id
    end
    add_index :messages_task_calendars, :account_id
    add_index :messages_task_calendars, :user_id
    add_index :messages_task_calendars, :parent_id
    add_index :messages_task_calendars, :calendar_staff_group_id
  end
end
