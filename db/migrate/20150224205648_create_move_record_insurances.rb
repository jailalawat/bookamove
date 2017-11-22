class CreateMoveRecordInsurances < ActiveRecord::Migration
  def change
    create_table :move_record_insurances do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :declared_value
      t.string :dolar_k
      t.string :description
      t.string :insurance_cost
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
