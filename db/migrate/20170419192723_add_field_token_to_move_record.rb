class AddFieldTokenToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :token, :string, index: true
  end
end
