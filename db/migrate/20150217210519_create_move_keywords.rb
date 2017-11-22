class CreateMoveKeywords < ActiveRecord::Migration
  def change
    create_table :move_keywords do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_keywords, :description
    add_index :move_keywords, :account_id
  end
end