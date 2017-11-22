class CreateMoveStatuses < ActiveRecord::Migration
  def change
    create_table :move_statuses do |t|
      t.string :description
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :move_statuses, :description
  end
end