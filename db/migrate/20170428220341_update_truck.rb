class UpdateTruck < ActiveRecord::Migration[5.0]
  def change
    remove_column :trucks, :truck_size, :string
    add_column :trucks, :size, :string
  end
end
