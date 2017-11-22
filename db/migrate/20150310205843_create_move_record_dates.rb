class CreateMoveRecordDates < ActiveRecord::Migration
  def change
    create_table :move_record_dates do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.datetime :move_date
      t.datetime :move_time
      t.integer :time_alert_id, null: true
      t.string :time_range
      t.string :time_detail
      #foreing keys
      t.foreign_key :move_records
      t.foreign_key :accounts
      t.foreign_key :time_alerts
      t.timestamps
    end
  end
end

    