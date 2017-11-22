class AddDriverTokenToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :driver_token, :string, index: true

    add_index :move_records, :driver_token
  end
end
