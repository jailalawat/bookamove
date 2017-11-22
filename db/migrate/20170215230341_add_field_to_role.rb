class AddFieldToRole < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :role_level, :integer, default: 1, after: :description
  end
end
