class CreateDispatchCommissionMoveRecords < ActiveRecord::Migration
  def change
    create_table :dispatch_commission_move_records do |t|
      t.float :move, default: 0.0
      t.float :storage, default: 0.0
      t.float :packing, default: 0.0
      t.float :insurance, default: 0.0
      t.float :other, default: 0.0
      t.float :blank, default: 0.0
      t.float :total_move, default: 0.0
      t.float :total_storage, default: 0.0
      t.float :total_packing, default: 0.0
      t.float :total_insurance, default: 0.0
      t.float :total_other, default: 0.0
      t.float :total_blank, default: 0.0
      t.float :total_commission, default: 0.0

      t.integer :move_record_id
      t.integer :account_id
      t.integer :user_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :move_records
      t.timestamps
    end
    add_index :dispatch_commission_move_records, :move_record_id
    add_index :dispatch_commission_move_records, :account_id
    add_index :dispatch_commission_move_records, :user_id

  end
end
