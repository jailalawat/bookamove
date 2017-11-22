class CreateMoveRecordPayments < ActiveRecord::Migration
  def change
    create_table :move_record_payments do |t|
      t.integer :move_record_id
      t.integer :account_id
      t.string :type_payment
      t.string :status
      t.string :number_card
      t.string :exp
      t.string :cvc
      t.string :number_transaction
      t.string :pre_auth
      t.string :amount
      t.datetime :date
      t.string :payment_detail
      t.integer :payment_alert_id, null: true
      #foreing keys
      t.foreign_key :move_records
      t.foreign_key :payment_alerts
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
