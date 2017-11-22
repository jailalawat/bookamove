class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :parent_id, default: nil
      t.string :subject
      t.text :body
      t.boolean :urgent, default: false
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :messages, column: :parent_id
    end
    add_index :messages, :account_id
    add_index :messages, :user_id
    add_index :messages, :parent_id
  end
end
