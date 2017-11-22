class CreateMessagesTruckAvailableCalendars < ActiveRecord::Migration
  def change
    create_table :messages_truck_available_calendars do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :truck_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.integer :urgent, default: 0
      t.datetime :date_calendar
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :trucks
    end
    add_index :messages_truck_available_calendars, :account_id
    add_index :messages_truck_available_calendars, :user_id
    add_index :messages_truck_available_calendars, :parent_id
    add_index :messages_truck_available_calendars, :truck_id
  end
end
