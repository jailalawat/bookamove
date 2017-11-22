class AddDefaultFieldToRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :default, :boolean, default: false, after: :active
  end
end
