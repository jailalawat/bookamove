class CreateCargoTemplate < ActiveRecord::Migration
  def change
    create_table :cargo_templates do |t|
      t.string :description
      t.integer :furnishing_id
      t.float :unit_weight, default: 0.0
      t.float :unit_volume, default: 0.0
      #foreign
      t.foreign_key :furnishings
      t.timestamps
    end
    add_index :cargo_templates, :furnishing_id
  end
end
