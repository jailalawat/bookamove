class CreateActionRoles < ActiveRecord::Migration
  def change
    create_table :action_roles do |t|
      t.integer :account_id
      t.integer :role_id
      t.integer :action_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :roles
      t.foreign_key :actions
      t.timestamps null: false
    end
    add_index :action_roles, [:account_id, :role_id, :action_id], unique: true
  end
end
