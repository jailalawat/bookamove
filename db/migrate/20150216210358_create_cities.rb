class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :cities, :description
    add_index :cities, :account_id
  end
end
