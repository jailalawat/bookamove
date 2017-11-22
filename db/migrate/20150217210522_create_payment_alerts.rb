class CreatePaymentAlerts < ActiveRecord::Migration
  def change
    create_table :payment_alerts do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :payment_alerts, :description
    add_index :payment_alerts, :account_id
  end
end
