class CreateMoveRecordFlatRates < ActiveRecord::Migration
  def change
    create_table :move_record_flat_rates do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :notes
      t.string :move_cost
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
