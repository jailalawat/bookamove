class CreateMoveSources < ActiveRecord::Migration
  def change
    create_table :move_sources do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_sources, :description
    add_index :move_sources, :account_id
  end
end
