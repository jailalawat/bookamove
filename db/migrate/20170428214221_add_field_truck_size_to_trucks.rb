class AddFieldTruckSizeToTrucks < ActiveRecord::Migration[5.0]
  def change
    add_column :trucks, :truck_size, :string
  end
end
