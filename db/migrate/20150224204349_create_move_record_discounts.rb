class CreateMoveRecordDiscounts < ActiveRecord::Migration
  def change
    create_table :move_record_discounts do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :percentage
      t.string :hourly
      t.string :notes
      t.string :discount
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
