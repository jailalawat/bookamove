class CreateTruckSizes < ActiveRecord::Migration
  def change
    create_table :truck_sizes do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :truck_sizes, :description
    add_index :truck_sizes, :account_id
  end
end