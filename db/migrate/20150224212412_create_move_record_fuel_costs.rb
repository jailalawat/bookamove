class CreateMoveRecordFuelCosts < ActiveRecord::Migration
  def change
    create_table :move_record_fuel_costs do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :percentage_mc
      t.string :fixed
      t.string :notes
      t.string :fuel_cost
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
