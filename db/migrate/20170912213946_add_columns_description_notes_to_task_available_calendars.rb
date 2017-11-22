class AddColumnsDescriptionNotesToTaskAvailableCalendars < ActiveRecord::Migration[5.0]
  def change
    add_column :task_available_calendars, :description, :text
    add_column :task_available_calendars, :notes, :text
  end
end
