class CreateMoveRecordTrucks < ActiveRecord::Migration
  def change
    create_table :move_record_trucks do |t|
      t.integer :move_record_id
      t.integer :truck_id
      t.integer :account_id
      t.string :truck_name
      t.string :equipment_details
      t.integer :equipment_alert_id
      t.integer :number_man_id, null: true
      t.integer :lead, null: true
      t.integer :mover_2, null: true
      t.integer :mover_3, null: true
      t.integer :mover_4, null: true
      t.integer :mover_5, null: true
      t.integer :mover_6, null: true
      t.string :lead_hour, null: true
      t.string :mover_2_hour, null: true
      t.string :mover_3_hour, null: true
      t.string :mover_4_hour, null: true
      t.string :mover_5_hour, null: true
      t.string :mover_6_hour, null: true

      #foreign key
      t.foreign_key :move_records
      t.foreign_key :trucks
      t.foreign_key :accounts
      t.foreign_key :equipment_alerts
      t.foreign_key :users, column: :lead
      t.foreign_key :users, column: :mover_2
      t.foreign_key :users, column: :mover_3
      t.foreign_key :users, column: :mover_4
      t.foreign_key :users, column: :mover_5
      t.foreign_key :users, column: :mover_6
      t.timestamps
    end
    add_index :move_record_trucks, :account_id
    add_index :move_record_trucks, :truck_id
  end
end
