class CreateImageAccounts < ActiveRecord::Migration
  def change
    create_table :image_accounts do |t|
      t.integer :account_id
      t.string :file
      t.string :name
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
