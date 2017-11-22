class CreateMoveRecordNotes < ActiveRecord::Migration
  def change
    create_table :move_record_notes do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.text :body
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_record_notes, :account_id
  end
end
