class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :dob
      t.text :bio
      t.string :groups
      t.string :name
      t.string :title
      t.string :email_pers
      t.string :sin
      t.string :spouse
      t.string :children
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :home_phone
      t.string :cell_phone
      t.string :work_phone
      t.text :address
      t.string :building
      t.string :city
      t.string :locale
      t.string :province
      t.string :postal_code
      t.integer :account_id, null: true
      t.boolean :active, default: true
      t.string :phone_pass
      t.string :vm_pass
      t.string :ext_no
      t.boolean :active, default: true
      t.boolean :driver_commission, default: false
      t.boolean :move_commission, default: false
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :users, [:account_id, :email], unique: true
  end
end
