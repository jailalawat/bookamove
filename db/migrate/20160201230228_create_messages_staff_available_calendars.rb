class CreateMessagesStaffAvailableCalendars < ActiveRecord::Migration
  def change
    create_table :messages_staff_available_calendars do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :staff_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.integer :urgent, default: 0
      t.datetime :date_calendar
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users, column: :user_id
      t.foreign_key :users, column: :staff_id
    end
    add_index :messages_staff_available_calendars, :account_id
    add_index :messages_staff_available_calendars, :user_id
    add_index :messages_staff_available_calendars, :parent_id
    add_index :messages_staff_available_calendars, :staff_id
  end
end
