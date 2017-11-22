class CreateMessagesMoveRecordAttachments < ActiveRecord::Migration
  def change
    create_table :messages_move_record_attachments do |t|
      t.integer :account_id
      t.integer :messages_move_record_id
      t.string :file_path
      t.string :name

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :messages_move_records
      t.timestamps
    end
  end
end
