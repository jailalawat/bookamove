class CreateMoveTypeAlerts < ActiveRecord::Migration
  def change
    create_table :move_type_alerts do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_type_alerts, :description
    add_index :move_type_alerts, :account_id
  end
end
