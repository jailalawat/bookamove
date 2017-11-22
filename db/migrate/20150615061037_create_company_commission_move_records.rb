class CreateCompanyCommissionMoveRecords < ActiveRecord::Migration
  def change
    create_table :company_commission_move_records do |t|
      t.float :total_move, default: 0.0
      t.float :total_storage, default: 0.0
      t.float :total_packing, default: 0.0
      t.float :total_insurance, default: 0.0
      t.float :total_other, default: 0.0
      t.float :total_blank, default: 0.0
      t.float :total_company, default: 0.0

      t.float :total_move_percentage, default: 0.0
      t.float :total_storage_percentage, default: 0.0
      t.float :total_packing_percentage, default: 0.0
      t.float :total_insurance_percentage, default: 0.0
      t.float :total_other_percentage, default: 0.0
      t.float :total_blank_percentage, default: 0.0
      t.float :total_company_percentage, default: 0.0

      t.integer :move_record_id
      t.integer :account_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :move_records
      t.timestamps
    end
    add_index :company_commission_move_records, :move_record_id
    add_index :company_commission_move_records, :account_id

  end
end
