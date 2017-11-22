class UpdateCityColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :cities, :active
    remove_column :cities, :tax_id
    remove_column :cities, :calendar_truck_group_id

    add_column :cities, :province_id, :integer
    add_index :cities, :province_id
  end
end
