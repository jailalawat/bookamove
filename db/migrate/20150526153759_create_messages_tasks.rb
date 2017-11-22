class CreateMessagesTasks < ActiveRecord::Migration
  def change
    create_table :messages_tasks do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :subtask_staff_group_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.boolean :urgent, default: false
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :subtask_staff_groups
      t.foreign_key :messages_tasks, column: :parent_id
    end
    add_index :messages_tasks, :account_id
    add_index :messages_tasks, :user_id
    add_index :messages_tasks, :parent_id
    add_index :messages_tasks, :subtask_staff_group_id
  end
end
