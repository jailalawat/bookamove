class CreateMessagesMoveRecords < ActiveRecord::Migration
  def change
    create_table :messages_move_records do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :move_record_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.boolean :urgent, default: false
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :move_records
      t.foreign_key :messages_move_records, column: :parent_id
    end
    add_index :messages_move_records, :account_id
    add_index :messages_move_records, :user_id
    add_index :messages_move_records, :parent_id
    add_index :messages_move_records, :move_record_id
  end
end
