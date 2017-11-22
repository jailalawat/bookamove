class CreateMessagesTaskAttachments < ActiveRecord::Migration
  def change
    create_table :messages_task_attachments do |t|
      t.integer :account_id
      t.integer :messages_task_id
      t.string :file_path
      t.string :name

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :messages_tasks
      t.timestamps
    end
    add_index :messages_task_attachments, :account_id
    add_index :messages_task_attachments, :messages_task_id
  end
end
