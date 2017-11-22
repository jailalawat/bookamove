class CreateMoveRecordLocationOrigins < ActiveRecord::Migration
  def change
    create_table :move_record_location_origins do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.integer :location_id
      #foreing keys
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.foreign_key :locations
      t.timestamps
    end
  end
end