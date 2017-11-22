class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :no
      t.string :street
      t.string :apartment
      t.string :entry_number
      t.string :building
      t.string :city
      t.string :locale
      t.string :province
      t.string :postal_code
      t.string :access_details
      t.integer :access_alert_id, null: true
      t.integer :account_id
      #foreign key
      t.foreign_key :accounts
      t.foreign_key :access_alerts
      t.timestamps
    end
  end
end
