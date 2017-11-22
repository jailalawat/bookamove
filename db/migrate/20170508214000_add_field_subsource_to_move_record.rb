class AddFieldSubsourceToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :move_subsource_id, :string, after: :move_source_id, null: true
    rename_column :move_records, :move_source_detail, :referral2
  end
end