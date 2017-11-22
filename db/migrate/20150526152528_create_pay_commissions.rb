class CreatePayCommissions < ActiveRecord::Migration
  def change
    create_table :pay_commissions do |t|

      t.float :hourly, default: 0.0
      t.float :monthly, default: 0.0
      t.string :detail

      t.boolean :active, default: false
      t.integer :account_id
      t.integer :user_id

      t.foreign_key :accounts
      t.foreign_key :users

      t.timestamps
    end
    add_index :pay_commissions, :account_id
    add_index :pay_commissions, :user_id
  end
end
