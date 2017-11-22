class AddColumnReminderTaskCalendar < ActiveRecord::Migration
  def change
    add_column :reminder_calendar_tasks, :messages_task_calendar_id, :integer
    add_foreign_key :reminder_calendar_tasks, :messages_task_calendars, column: :messages_task_calendar_id
    remove_column :reminder_calendar_tasks, :comment
    add_column :reminder_calendar_tasks, :calendar_staff_group_id, :integer
    add_foreign_key :reminder_calendar_tasks, :calendar_staff_groups, column: :calendar_staff_group_id
  end
end
