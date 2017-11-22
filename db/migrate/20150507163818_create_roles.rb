class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :account_id
      t.string :name
      t.string :description
      t.timestamps null: false
      #foreign key
      t.foreign_key :accounts
    end
  end
end
