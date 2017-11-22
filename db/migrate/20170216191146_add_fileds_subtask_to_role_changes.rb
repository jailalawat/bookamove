class AddFiledsSubtaskToRoleChanges < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :calendar_staff_group_id, :integer, default: nil, after: :role_level, index: true
    add_column :subtask_staff_groups, :role_id, :integer, default: nil, after: :active, index: true
  end
end
