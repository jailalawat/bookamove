class UpdateCityLocales < ActiveRecord::Migration[5.0]
  def change
    remove_column :city_locales, :calendar_truck_group_id
    remove_column :city_locales, :account_id
  end
end
