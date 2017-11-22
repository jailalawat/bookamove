class CreateMoveRecordCostHourlies < ActiveRecord::Migration
  def change
    create_table :move_record_cost_hourlies do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :start
      t.string :stop
      t.string :hours
      t.string :breaks
      t.string :travel
      t.string :estimate_time
      t.string :actual
      t.string :hourly_rate
      t.string :move_cost
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
