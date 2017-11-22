class AddColumnMarkedMessagesTables < ActiveRecord::Migration
  def change
    add_column :user_messages, :marked, :boolean, default: false
    add_column :user_messages_tasks, :marked, :boolean, default: false
    add_column :task_messages_move_records, :marked, :boolean, default: false
    add_column :user_messages_move_records, :marked, :boolean, default: false
  end
end
