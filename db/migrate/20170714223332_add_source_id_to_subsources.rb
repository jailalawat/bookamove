class AddSourceIdToSubsources < ActiveRecord::Migration[5.0]
  def change
    add_column :move_subsources, :move_source_id, :integer
    add_index :move_subsources, :move_source_id
  end
end
