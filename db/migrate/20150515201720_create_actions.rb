class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :description
      t.string :key
      t.boolean :is_admin_section, default: false
      t.timestamps
    end
    add_index :actions, :key, unique: true
  end
end
