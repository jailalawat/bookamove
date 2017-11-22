class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :description
      t.string :cell
      t.string :license
      t.string :year
      t.string :model
      t.string :cu_inch
      t.string :fuel
      t.string :phone
      t.string :fax
      t.string :registration
      t.string :make
      t.string :gvw
      t.string :serial_number
      t.string :insurance_date
      t.string :air_care_date
      t.string :driver
      t.string :secondary_driver
      t.string :safety_date
      t.string :exterior_lenght
      t.string :exterior_width
      t.string :exterior_height
      t.string :interior_lenght
      t.string :interior_width
      t.string :interior_height
      t.string :inside_volume
      t.string :maximum_weight
      t.string :maximum_volume
      t.string :men
      t.boolean :piano, default: true
      t.boolean :tailgate, default: true
      t.boolean :active, default: true
      t.integer :truck_size_id, null: true
      t.integer :account_id
      t.foreign_key :accounts
      t.foreign_key :truck_sizes
      t.text :bio
      t.text :restrictions
      t.timestamps
    end
    add_index :trucks, :account_id
  end
end
