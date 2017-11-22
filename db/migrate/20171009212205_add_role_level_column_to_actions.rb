class AddRoleLevelColumnToActions < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :role_level, :integer, after: :group, default: 1
  end
end
