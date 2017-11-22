class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :title
      t.string :home_phone
      t.string :cell_phone
      t.string :work_phone
      t.string :email
      t.boolean :active, default: true
      t.integer :account_id
      t.integer :user_id

      t.foreign_key :accounts
      t.foreign_key :users
      t.timestamps
    end
    add_index :clients, :name
    add_index :clients, :account_id
    add_index :clients, :user_id
  end
end
