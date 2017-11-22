class AddColumnMessagesTask < ActiveRecord::Migration
  def change
    change_column :messages_tasks, :urgent, :integer, default: 0
    add_column :messages_tasks, :task_sender_id, :integer
    add_foreign_key :messages_tasks, :subtask_staff_groups, column: :task_sender_id
  end
end
