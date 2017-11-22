class CreateTimeAlerts < ActiveRecord::Migration
  def change
    create_table :time_alerts do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :time_alerts, :description
    add_index :time_alerts, :account_id
  end
end
