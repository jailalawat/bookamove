class CreateReminderCalendarPersonals < ActiveRecord::Migration
  def change
    create_table :reminder_calendar_personals do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :author
      t.datetime :date
      t.string :comment
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users, column: :user_id
      t.foreign_key :users, column: :author
      t.timestamps
    end
    add_index :reminder_calendar_personals, :account_id
    add_index :reminder_calendar_personals, :user_id
    add_index :reminder_calendar_personals, :author
  end
end
