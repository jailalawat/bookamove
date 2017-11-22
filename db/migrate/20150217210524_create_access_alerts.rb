class CreateAccessAlerts < ActiveRecord::Migration
  def change
    create_table :access_alerts do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :access_alerts, :description
    add_index :access_alerts, :account_id
  end
end