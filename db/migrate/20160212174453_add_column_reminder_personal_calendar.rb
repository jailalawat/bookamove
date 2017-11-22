class AddColumnReminderPersonalCalendar < ActiveRecord::Migration
  def change
    add_column :reminder_calendar_personals, :messages_personal_calendar_id, :integer
    add_foreign_key :reminder_calendar_personals, :messages_staff_available_calendars, column: :messages_personal_calendar_id
    remove_column :reminder_calendar_personals, :comment
  end
end
