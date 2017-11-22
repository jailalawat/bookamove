class CreateMoveRecordCargos < ActiveRecord::Migration
  def change
    create_table :move_record_cargos do |t|
      t.string :description
      t.float :quantity, default: 0.0
      t.float :unit_volume, default: 0.0
      t.float :unit_weight, default: 0.0

      t.integer :move_record_id
      t.integer :account_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :move_records

      t.timestamps
    end
    add_index :move_record_cargos, :move_record_id
  end
end
