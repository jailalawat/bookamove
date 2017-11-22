class CreateTruckCalendarAttachments < ActiveRecord::Migration
  def change
    create_table :truck_calendar_attachments do |t|
      t.integer :account_id
      t.integer :messages_truck_calendar_id
      t.string :file_path
      t.string :name

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :messages_truck_calendars
      t.timestamps
    end
  end
end
