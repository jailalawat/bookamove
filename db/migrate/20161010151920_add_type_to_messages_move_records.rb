class AddTypeToMessagesMoveRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :messages_move_records, :message_type, :string
  end
end
