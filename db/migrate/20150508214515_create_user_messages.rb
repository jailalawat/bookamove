class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :message_id
      t.boolean :readed

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :messages
      t.timestamps
    end
    add_index :user_messages, :account_id
    add_index :user_messages, :user_id
    add_index :user_messages, :message_id
  end
end
