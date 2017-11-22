class ChangeColumnTruck < ActiveRecord::Migration
  def change
    change_column :trucks, :driver, :integer, default: nil
    add_foreign_key :trucks, :users, column: :driver
  end
end
