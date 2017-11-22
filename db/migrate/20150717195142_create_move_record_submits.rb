class CreateMoveRecordSubmits < ActiveRecord::Migration
  def change
    create_table :move_record_submits do |t|
      t.boolean :signed_acceptance
      t.boolean :signed_completion
      t.boolean :release_to
      t.boolean :purshased_rvp
      t.boolean :accepted_weight_charges

      t.string :start_time
      t.string :end_time
      t.string :break_time


      t.float :actual_lb, default: 0.0
      t.float :min_lb, default: 0.0
      t.float :min_lb_dolar, default: 0.0
      t.float :min_lb_dolar_client, default: 0.0
      t.float :dolar_lb, default: 0.0
      t.float :dolar_lb_client, default: 0.0

      t.float :rate_actual, default: 0.0
      t.float :total_time_actual, default: 0.0
      t.float :flat_rate_actual, default: 0.0
      t.float :move_cost_actual, default: 0.0
      t.float :discount_actual, default: 0.0
      t.float :discount_move_cost_actual, default: 0.0
      t.float :packing_supplies_actual, default: 0.0
      t.float :other_cost_actual, default: 0.0
      t.float :surchage_actual, default: 0.0
      t.float :rvp_calculated, default: 0.0
      t.float :rvp_actual, default: 0.0
      t.float :subtotal_actual, default: 0.0
      t.float :gst_actual, default: 0.0
      t.float :deposit_actual, default: 0.0
      t.float :total_actual, default: 0.0

      t.string :payment_type_one
      t.string :total_client_one
      t.string :card_number_one
      t.string :expiry_one
      t.string :cvc_one
      t.string :moneris_id_one
      t.string :pre_auth_one
      t.string :payment_date_one

      t.string :payment_type_two
      t.string :total_client_two
      t.string :card_number_two
      t.string :expiry_two
      t.string :cvc_two
      t.string :moneris_id_two
      t.string :pre_auth_two
      t.string :payment_date_two

      t.float :client_received, default: 0.0
      t.float :company_received, default: 0.0
      t.boolean :receive_all_cash
      t.boolean :signed_credit_card

      t.string :origin_access_comment
      t.string :destination_access_comment


      t.integer :move_record_id
      t.integer :account_id

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :move_records
      t.timestamps
    end
    add_index :move_record_submits, :move_record_id
  end
end
