class CreateMoveSubsources < ActiveRecord::Migration[5.0]
  def change
    create_table :move_subsources do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_subsources, :description
    add_index :move_subsources, :account_id
  end
end
