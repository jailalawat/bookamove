class CreateBookCommissions < ActiveRecord::Migration
  def change
    create_table :book_commissions do |t|
      t.float :move, default: 0.0
      t.float :storage, default: 0.0
      t.float :packing, default: 0.0
      t.float :insurance, default: 0.0
      t.float :other, default: 0.0
      t.float :blank, default: 0.0

      t.float :ld_move, default: 0.0
      t.float :ld_storage, default: 0.0
      t.float :ld_packing, default: 0.0
      t.float :ld_insurance, default: 0.0
      t.float :ld_other, default: 0.0
      t.float :ld_blank, default: 0.0

      t.boolean :active, default: false
      t.integer :account_id
      t.integer :user_id

      t.foreign_key :accounts
      t.foreign_key :users

      t.timestamps
    end
    add_index :book_commissions, :account_id
    add_index :book_commissions, :user_id
  end
end
