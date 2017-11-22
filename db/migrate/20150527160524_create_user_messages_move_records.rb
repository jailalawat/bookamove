class CreateUserMessagesMoveRecords < ActiveRecord::Migration
  def change
    create_table :user_messages_move_records do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :messages_move_record_id
      t.boolean :readed

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :messages_move_records
      t.timestamps
    end
    add_index :user_messages_move_records, :account_id
    add_index :user_messages_move_records, :user_id
    add_index :user_messages_move_records, :messages_move_record_id
  end
end
