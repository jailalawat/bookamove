class CreateMoveStatusEmailAlerts < ActiveRecord::Migration
  def change
    create_table :move_status_email_alerts do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :move_record_id
      t.integer :email_alert_id
      t.integer :move_status_id
      #foreign keys
      t.foreign_key :accounts
      t.foreign_key :move_records
      t.foreign_key :email_alerts
      t.foreign_key :move_statuses
      t.foreign_key :users
      t.timestamps
    end
    add_index :move_status_email_alerts, :account_id
    add_index :move_status_email_alerts, :email_alert_id
    add_index :move_status_email_alerts, :move_status_id
  end
end
