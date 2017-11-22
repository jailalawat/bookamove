class CreateUserMessageTruckCalendars < ActiveRecord::Migration
  def change
    create_table :user_message_truck_calendars do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :messages_truck_calendar_id
      t.boolean :readed
      t.boolean :marked, default: false
      t.boolean :trash, default: false

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :messages_truck_calendars
      t.timestamps
    end
    add_index :user_message_truck_calendars, :account_id
    add_index :user_message_truck_calendars, :user_id
    add_index :user_message_truck_calendars, :messages_truck_calendar_id
  end
end
