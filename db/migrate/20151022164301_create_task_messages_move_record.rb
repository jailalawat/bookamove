class CreateTaskMessagesMoveRecord < ActiveRecord::Migration
  def change
    create_table :task_messages_move_records do |t|
      t.integer :account_id
      t.integer :subtask_staff_group_id
      t.integer :messages_move_record_id
      t.boolean :readed

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :subtask_staff_groups
      t.foreign_key :messages_move_records
      t.timestamps
    end
    add_index :task_messages_move_records, :account_id
    add_index :task_messages_move_records, :subtask_staff_group_id
    add_index :task_messages_move_records, :messages_move_record_id
  end
end
