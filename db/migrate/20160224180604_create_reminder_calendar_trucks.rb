class CreateReminderCalendarTrucks < ActiveRecord::Migration
  def change
    create_table :reminder_calendar_trucks do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :truck_id
      t.integer :messages_truck_available_calendar_id
      t.datetime :date
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :trucks
      t.foreign_key :messages_truck_available_calendars
      t.timestamps
    end
    add_index :reminder_calendar_trucks, :account_id
    add_index :reminder_calendar_trucks, :user_id
    add_index :reminder_calendar_trucks, :truck_id
    add_index :reminder_calendar_trucks, :messages_truck_available_calendar_id, name: 'index_reminder_calendar_on_messages_truck'
  end
end
