class CreateActionUsers < ActiveRecord::Migration
  def change
    create_table :action_users do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :action_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :actions
      t.timestamps null: false
    end
    add_index :action_users, [:account_id, :user_id, :action_id], unique: true
  end
end
