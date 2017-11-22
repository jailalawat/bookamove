class CreateMoveSourceAlerts < ActiveRecord::Migration
  def change
    create_table :move_source_alerts do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_source_alerts, :description
    add_index :move_source_alerts, :account_id
  end
end
