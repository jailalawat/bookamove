class ChangeColumnUrgentMessageMoveRecords < ActiveRecord::Migration
  def change
    change_column :messages_move_records, :urgent, :integer, default: 0
  end
end
