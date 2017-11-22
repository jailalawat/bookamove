class CreateReminderCalendarMoveRecords < ActiveRecord::Migration
  def change
    create_table :reminder_calendar_move_records do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :truck_id
      t.integer :author
      t.datetime :date
      t.string :comment

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users, column: :user_id
      t.foreign_key :users, column: :author
      t.foreign_key :trucks
      t.timestamps
    end
    add_index :reminder_calendar_move_records, :account_id
    add_index :reminder_calendar_move_records, :user_id
    add_index :reminder_calendar_move_records, :author
    add_index :reminder_calendar_move_records, :truck_id
  end
end
