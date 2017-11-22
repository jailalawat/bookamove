class AddColumnReminderTruckCalendar < ActiveRecord::Migration
  def change
    add_column :reminder_calendar_move_records, :messages_truck_calendar_id, :integer
    add_foreign_key :reminder_calendar_move_records, :messages_truck_calendars, column: :messages_truck_calendar_id
    remove_column :reminder_calendar_move_records, :comment
    add_column :reminder_calendar_move_records, :calendar_truck_group_id, :integer
    add_foreign_key :reminder_calendar_move_records, :calendar_truck_groups, column: :calendar_truck_group_id
  end
end
