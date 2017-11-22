class CreateMoveReferrals < ActiveRecord::Migration
  def change
    create_table :move_referrals do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :move_referrals, :description
    add_index :move_referrals, :account_id
  end
end
