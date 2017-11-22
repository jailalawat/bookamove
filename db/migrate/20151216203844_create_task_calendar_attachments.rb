class CreateTaskCalendarAttachments < ActiveRecord::Migration
  def change
    create_table :task_calendar_attachments do |t|
      t.integer :account_id
      t.integer :messages_task_calendar_id
      t.string :file_path
      t.string :name

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :messages_task_calendars
      t.timestamps
    end
  end
end
