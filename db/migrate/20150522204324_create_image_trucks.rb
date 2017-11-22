class CreateImageTrucks < ActiveRecord::Migration
  def change
    create_table :image_trucks do |t|
      t.integer :truck_id
      t.integer :account_id
      t.string :file
      t.string :name
      t.foreign_key :trucks
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
