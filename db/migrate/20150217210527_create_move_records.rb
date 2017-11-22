class CreateMoveRecords < ActiveRecord::Migration
  def change
    create_table :move_records do |t|
      t.integer :account_id
      t.integer :user_id
      #move details
      t.integer :move_type_id, null: true
      t.string :move_type_detail
      t.integer :move_type_alert_id, null: true
      t.integer :move_source_id, null: true
      t.integer :move_keyword_id, null: true
      t.integer :move_webpage_id, null: true
      t.integer :move_referral_id, null: true
      t.string :move_source_detail
      t.integer :move_source_alert_id, null: true

      #cargo
      t.integer :cargo_type_id, null: true
      t.string :cargo_descriptor
      t.string :cargo_room
      t.string :cargo_weight
      t.string :cargo_cubic
      t.string :cargo_detail
      t.integer :cargo_alert_id, null: true
      t.string :cargo_description

      # notes
      t.text :who_note
      t.text :what_note
      t.text :where_note
      t.text :when_note
      t.text :how_note
      t.text :cost_note
      t.text :contract_note
      t.text :contract_stage_note

      #total_cost
      t.decimal :gst_hst, :precision => 10, :scale => 3, :default => 0.0
      t.decimal :pst, :precision => 10, :scale => 3, :default => 0.0
      t.decimal :subtotal, :precision => 10, :scale => 3, :default => 0.0
      t.decimal :deposit, :precision => 10, :scale => 3, :default => 0.0
      t.decimal :payment, :precision => 10, :scale => 3, :default => 0.0
      t.decimal :balance_due, :precision => 10, :scale => 3, :default => 0.0
      t.decimal :total_cost, :precision => 10, :scale => 3, :default => 0.0

      t.boolean :cost_hourly_selected
      t.boolean :packing_selected
      t.boolean :other_cost_selected
      t.boolean :surchage_selected
      t.boolean :flat_rate_selected
      t.boolean :discount_selected
      t.boolean :insurance_selected
      t.boolean :fuel_cost_selected
      t.boolean :payment_selected

      #lock move record when user is on edition
      t.boolean :locked_move_record, default: false
      t.integer :user_locked_move_record_id, null: true

      t.boolean :approved, default: false
      t.boolean :external_request, default: false

      # foreign keys
      t.foreign_key :cargo_types
      t.foreign_key :move_types
      t.foreign_key :move_type_alerts
      t.foreign_key :move_sources
      t.foreign_key :move_keywords
      t.foreign_key :move_webpages
      t.foreign_key :move_referrals
      t.foreign_key :move_source_alerts
      t.foreign_key :cargo_alerts
      t.foreign_key :accounts
      t.foreign_key :users
      t.foreign_key :users, column: :user_locked_move_record_id
      t.timestamps
    end
    add_index :move_records, :account_id
  end
end
