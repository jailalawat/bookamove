class AddIndexTokenToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_index :move_records, :token
  end
end
