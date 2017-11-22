class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :site
      t.string :toll_free_phone
      t.string :building
      t.string :office_phone
      t.string :city
      t.string :fax
      t.string :locale
      t.string :website
      t.string :province
      t.string :postal_code
      t.string :subdomain
      t.string :bio
      t.string :address
      t.boolean :active, default: true
      t.boolean :is_admin, default: false
      t.timestamps
    end
    add_index :accounts, [:subdomain, :email], unique: true
  end
end
