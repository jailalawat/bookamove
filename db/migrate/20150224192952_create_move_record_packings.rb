class CreateMoveRecordPackings < ActiveRecord::Migration
  def change
    create_table :move_record_packings do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :boxes
      t.string :paper
      t.string :tape
      t.string :wrap
      t.string :bags
      t.string :box_rent
      t.integer :packing_alert_id, null: true
      t.string :other
      t.string :total_packing
      #foreing keys
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.foreign_key :packing_alerts
      t.timestamps
    end
  end
end
