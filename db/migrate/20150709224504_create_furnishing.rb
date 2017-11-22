class CreateFurnishing < ActiveRecord::Migration
  def change
    create_table :furnishings do |t|
      t.string :name
      t.integer :room_id
      #foreign
      t.foreign_key :rooms
      t.timestamps
    end
    add_index :furnishings, :room_id
  end
end
