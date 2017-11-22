class CreateMoveStageAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :move_stage_alerts do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end

    add_index :move_stage_alerts, :description
    add_index :move_stage_alerts, :account_id
  end
end