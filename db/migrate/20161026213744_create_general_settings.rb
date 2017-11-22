class CreateGeneralSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :general_settings do |t|
      t.integer :account_id
      t.foreign_key :accounts
      t.string :description
      t.string :value
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :general_settings, :account_id

    Action.create(description: "Show general settings", key: "show.general_settings")
    Action.create(description: "Edit general settings", key: "edit.general_settings")
  end
end
