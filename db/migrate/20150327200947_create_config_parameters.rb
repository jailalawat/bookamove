class CreateConfigParameters < ActiveRecord::Migration
  def change
    create_table :config_parameters do |t|
      t.integer :account_id
      t.string :description
      t.string :key_description
      t.string :value

      #foreign key
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :config_parameters, :key_description, unique: true
  end
end
