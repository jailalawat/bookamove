class CreateMoveRecordClients < ActiveRecord::Migration
  def change
    create_table :move_record_clients do |t|
      t.integer :move_record_id
      t.integer :client_id
      t.integer :account_id
      t.foreign_key :move_records
      t.foreign_key :clients
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
