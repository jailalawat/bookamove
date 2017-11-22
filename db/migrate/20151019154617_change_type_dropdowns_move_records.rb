class ChangeTypeDropdownsMoveRecords < ActiveRecord::Migration
  def change
    remove_foreign_key :move_records, :move_type_alerts
    remove_foreign_key :move_records, :move_source_alerts
    remove_foreign_key :move_records, :move_keywords
    remove_foreign_key :move_records, :move_webpages
    remove_foreign_key :move_records, :move_referrals
    remove_foreign_key :move_records, :move_sources
    remove_foreign_key :move_records, :cargo_types
    remove_foreign_key :move_records, :cargo_alerts
    remove_foreign_key :locations, :access_alerts
    remove_foreign_key :move_record_dates, :time_alerts
    remove_foreign_key :move_record_trucks, :equipment_alerts
    remove_foreign_key :move_record_payments, :payment_alerts
    remove_foreign_key :move_record_packings, :packing_alerts

    change_column :move_records, :move_type_alert_id, :string, null: true
    change_column :move_records, :move_source_id, :string, null: true
    change_column :move_records, :move_keyword_id, :string, null: true
    change_column :move_records, :move_webpage_id, :string, null: true
    change_column :move_records, :move_referral_id, :string, null: true
    change_column :move_records, :move_source_alert_id, :string, null: true
    change_column :move_records, :cargo_type_id, :string, null: true
    change_column :move_records, :cargo_alert_id, :string, null: true
    change_column :locations, :access_alert_id, :string, null: true
    change_column :move_record_dates, :time_alert_id, :string, null: true
    change_column :move_record_trucks, :equipment_alert_id, :string, null: true
    change_column :move_record_packings, :packing_alert_id, :string, null: true
    change_column :move_record_payments, :payment_alert_id, :string, null: true
  end
end
