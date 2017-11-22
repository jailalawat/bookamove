class CreateContactStages < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_stages do |t|
      t.integer :account_id, index: true
      t.string :stage
      t.integer :stage_num, index: true
      t.string :sub_stage
      t.integer :sub_stage_num, index: true
      t.integer :position, index: true
      t.boolean :active, default: true
      t.boolean :default, default: false
      t.foreign_key :accounts
      t.timestamps
    end
  end
end
