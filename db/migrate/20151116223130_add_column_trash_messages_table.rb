class AddColumnTrashMessagesTable < ActiveRecord::Migration
  def change
    add_column :user_messages, :trash, :boolean, default: false
    add_column :user_messages_tasks, :trash, :boolean, default: false
    add_column :task_messages_move_records, :trash, :boolean, default: false
    add_column :user_messages_move_records, :trash, :boolean, default: false
  end
end
