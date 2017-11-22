class AddFieldOldSystemIdToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :old_system_id, :integer, after: :id
    add_index :move_records, :old_system_id
  end
end
