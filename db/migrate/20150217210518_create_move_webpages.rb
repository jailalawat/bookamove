class CreateMoveWebpages < ActiveRecord::Migration
  def change
    create_table :move_webpages do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_webpages, :description
    add_index :move_webpages, :account_id
  end
end