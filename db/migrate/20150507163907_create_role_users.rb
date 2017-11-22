class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :role_users do |t|
      t.integer :account_id
      t.integer :role_id
      t.integer :user_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :roles
      t.timestamps null: false
    end
  end
end