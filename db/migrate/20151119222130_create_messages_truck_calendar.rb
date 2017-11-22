class CreateMessagesTruckCalendar < ActiveRecord::Migration
  def change
    create_table :messages_truck_calendars do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :calendar_truck_group_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.integer :urgent, default: 0
      t.datetime :date_calendar
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :calendar_truck_groups
      t.foreign_key :messages_truck_calendars, column: :parent_id
    end
    add_index :messages_truck_calendars, :account_id
    add_index :messages_truck_calendars, :user_id
    add_index :messages_truck_calendars, :parent_id
    add_index :messages_truck_calendars, :calendar_truck_group_id
  end
end
