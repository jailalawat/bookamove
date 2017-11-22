class CreateImageProfiles < ActiveRecord::Migration
  def change
    create_table :image_profiles do |t|
      t.integer :user_id
      t.integer :account_id
      t.string :file
      t.string :name
      t.foreign_key :users
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
