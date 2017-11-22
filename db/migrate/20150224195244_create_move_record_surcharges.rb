class CreateMoveRecordSurcharges < ActiveRecord::Migration
  def change
    create_table :move_record_surcharges do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.boolean :gst
      t.decimal :percentage_gst, :precision => 10, :scale => 2, :default => 0.0
      t.boolean :pst
      t.decimal :percentage_pst, :precision => 10, :scale => 2, :default => 0.0
      t.string :description
      t.string :surcharge
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
