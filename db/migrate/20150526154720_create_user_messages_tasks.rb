class CreateUserMessagesTasks < ActiveRecord::Migration
  def change
    create_table :user_messages_tasks do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :messages_task_id
      t.boolean :readed

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :messages_tasks
      t.timestamps
    end
    add_index :user_messages_tasks, :account_id
    add_index :user_messages_tasks, :user_id
    add_index :user_messages_tasks, :messages_task_id
  end
end
