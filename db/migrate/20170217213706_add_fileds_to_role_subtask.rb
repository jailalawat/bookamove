class AddFiledsToRoleSubtask < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :mailbox, :boolean, default: true, after: :calendar_staff_group_id
    add_column :roles, :active, :boolean, default: true, after: :mailbox
    add_column :subtask_staff_groups, :role_level, :integer, default: 1, after: :role_id
  end
end
