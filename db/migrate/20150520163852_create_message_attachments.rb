class CreateMessageAttachments < ActiveRecord::Migration
  def change
    create_table :message_attachments do |t|
      t.integer :account_id
      t.integer :message_id
      t.string :file_path
      t.string :name

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :messages
      t.timestamps
    end
    add_index :message_attachments, :account_id
    add_index :message_attachments, :message_id
  end
end
