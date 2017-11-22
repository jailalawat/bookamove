class CreateEmailAlerts < ActiveRecord::Migration
  def change
    create_table :email_alerts do |t|
      t.integer :account_id
      t.string :description
      t.string :template
      t.boolean :active, default: true

      t.foreign_key :accounts
      t.timestamps
    end
    add_index :email_alerts, :account_id
    add_index :email_alerts, :description
  end
end
