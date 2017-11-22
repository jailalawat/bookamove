class CreateMoveRecordDefaultSettings < ActiveRecord::Migration
  def change
    create_table :move_record_default_settings do |t|
      t.integer :number_of_clients, default: 1
      t.integer :number_of_trucks, default: 1
      t.integer :number_of_origin, default: 1
      t.integer :number_of_destination, default: 1
      t.integer :number_of_date, default: 1

      #move details
      t.boolean :show_move_type, default: true
      t.boolean :show_move_type_details, default: true
      t.boolean :show_move_type_alert, default: true
      t.integer :move_type_id, null: true
      t.integer :move_type_alert_id, null: true

      #source
      t.boolean :show_move_source, default: true
      t.boolean :show_move_keyword, default: true
      t.boolean :show_move_webpage, default: true
      t.boolean :show_move_referral, default: true
      t.boolean :show_move_source_detail, default: true
      t.boolean :show_move_source_alert, default: true
      t.integer :move_source_id, null: true
      t.integer :move_keyword_id, null: true
      t.integer :move_webpage_id, null: true
      t.integer :move_referral_id, null: true
      t.integer :move_source_alert_id, null: true

      #cargo
      t.boolean :show_cargo_type, default: true
      t.boolean :show_cargo_descriptor, default: true
      t.boolean :show_cargo_room, default: true
      t.boolean :show_cargo_weight, default: true
      t.boolean :show_cargo_cubic, default: true
      t.boolean :show_cargo_details, default: true
      t.boolean :show_cargo_alert, default: true
      t.boolean :show_description, default: true
      t.integer :cargo_type_id, null: true
      t.string :cargo_detail
      t.integer :cargo_alert_id, null: true
      t.string :cargo_description

      # origin
      t.boolean :show_origin_no, default: true
      t.boolean :show_origin_street, default: true
      t.boolean :show_origin_apartment, default: true
      t.boolean :show_origin_entry_number, default: true
      t.boolean :show_origin_building, default: true
      t.boolean :show_origin_city, default: true
      t.boolean :show_origin_locale, default: true
      t.boolean :show_origin_province, default: true
      t.boolean :show_origin_postal_code, default: true
      t.boolean :show_origin_access_details, default: true
      t.boolean :show_origin_access_alert, default: true
      t.integer :origin_access_alert_id, null: true

      # destination
      t.boolean :show_destination_no, default: true
      t.boolean :show_destination_street, default: true
      t.boolean :show_destination_apartment, default: true
      t.boolean :show_destination_entry_number, default: true
      t.boolean :show_destination_building, default: true
      t.boolean :show_destination_city, default: true
      t.boolean :show_destination_locale, default: true
      t.boolean :show_destination_province, default: true
      t.boolean :show_destination_postal_code, default: true
      t.boolean :show_destination_access_details, default: true
      t.boolean :show_destination_access_alert, default: true
      t.integer :destination_access_alert_id, null: true

      #time
      t.boolean :show_move_date, default: true
      t.boolean :show_move_time, default: true
      t.boolean :show_move_range, default: true
      t.boolean :show_move_time_detail, default: true
      t.integer :time_alert_id, null: true
      t.boolean :show_time_alert, default: true

      #truck
      t.boolean :show_truck, default: true
      t.boolean :show_truck_name, default: true
      t.boolean :show_truck_equipment_details, default: true
      t.boolean :show_truck_name_equipment_alert, default: true
      t.integer :truck_id, null: true
      t.integer :equipment_alert_id, null: true
      t.integer :number_man_id, null: true
      t.boolean :show_men, default: true
      t.boolean :show_lead, default: true
      t.boolean :show_mover_2, default: true
      t.boolean :show_mover_3, default: true
      t.boolean :show_mover_4, default: true
      t.boolean :show_mover_5, default: true
      t.boolean :show_mover_6, default: true

      # notes
      t.boolean :show_who_note, default: true
      t.boolean :show_what_note, default: true
      t.boolean :show_where_note, default: true
      t.boolean :show_when_note, default: true
      t.boolean :show_how_note, default: true
      t.boolean :show_cost_note, default: true
      t.boolean :show_contract_note, default: true
      t.boolean :show_contract_stage, default: true

      #contractNotes
      t.boolean :show_move_cost, default: true
      t.boolean :show_packing, default: true
      t.boolean :show_other_cost, default: true
      t.boolean :show_surcharge, default: true
      t.boolean :show_flat_rate, default: true
      t.boolean :show_discount, default: true
      t.boolean :show_insurance, default: true
      t.boolean :show_fuel_cost, default: true
      t.boolean :show_payment, default: true

      #checked option
      t.boolean :checked_cost_hourly, default: true
      t.boolean :checked_packing, default: true
      t.boolean :checked_other_cost, default: true
      t.boolean :checked_surchage, default: true
      t.boolean :checked_flat_rate, default: true
      t.boolean :checked_discount, default: true
      t.boolean :checked_insurance, default: true
      t.boolean :checked_fuel_cost, default: true
      t.boolean :checked_payment, default: true
      #packing
      t.integer :packing_alert_id, null: true

      #payments
      t.integer :payment_alert_id, null: true

      #contact stages
      t.boolean :show_lead, default: true
      t.boolean :show_follow_up, default: true
      t.boolean :show_quote, default: true
      t.boolean :show_book, default: true
      t.boolean :show_dispatch, default: true
      t.boolean :show_confirm, default: true
      t.boolean :show_receive, default: true
      t.boolean :show_active, default: true
      t.boolean :show_complete, default: true
      t.boolean :show_unable, default: true
      t.boolean :show_cancel, default: true
      t.boolean :show_submit, default: true
      t.boolean :show_invoice, default: true
      t.boolean :show_post, default: true
      t.boolean :show_aftercare, default: true

      #contact stages email
      t.boolean :show_lead_welcome, default: true

      t.boolean :show_follow_up_welcome, default: true

      t.boolean :show_quote_welcome, default: true
      t.boolean :show_quote_quote, default: true
      t.boolean :show_quote_callback, default: true

      t.boolean :show_book_welcome, default: true
      t.boolean :show_book_confirm, default: true
      t.boolean :show_book_dispatch, default: true

      t.boolean :show_dispatch_welcome, default: true
      t.boolean :show_dispatch_confirm, default: true
      t.boolean :show_dispatch_dispatch, default: true

      t.boolean :show_confirm_confirm, default: true
      t.boolean :show_confirm_acknowledgement, default: true


      t.boolean :show_receive_confirm, default: true
      t.boolean :show_receive_acknowledgement, default: true

      t.boolean :show_unable_unable, default: true
      t.boolean :show_cancel_cancel, default: true

      t.boolean :show_invoice_invoice, default: true
      t.boolean :show_post_thankyou, default: true
      t.boolean :show_aftercare_survey, default: true

      #foreing keys
      t.integer :account_id
      t.foreign_key :accounts
      t.foreign_key :trucks
      t.foreign_key :move_types
      t.foreign_key :move_type_alerts
      t.foreign_key :equipment_alerts
      t.foreign_key :payment_alerts
      t.foreign_key :move_sources
      t.foreign_key :move_keywords
      t.foreign_key :move_webpages
      t.foreign_key :move_referrals
      t.foreign_key :move_source_alerts
      t.foreign_key :time_alerts
      t.foreign_key :cargo_types
      t.foreign_key :cargo_alerts
      t.foreign_key :access_alerts, column: :origin_access_alert_id
      t.foreign_key :access_alerts, column: :destination_access_alert_id
      t.foreign_key :packing_alerts
      t.timestamps
    end
  end
end
