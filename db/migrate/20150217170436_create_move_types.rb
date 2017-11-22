class CreateMoveTypes < ActiveRecord::Migration
  def change
    create_table :move_types do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_types, :description
    add_index :move_types, :account_id
  end
end
