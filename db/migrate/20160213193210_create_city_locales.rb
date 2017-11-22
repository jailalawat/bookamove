class CreateCityLocales < ActiveRecord::Migration
  def change
    create_table :city_locales do |t|
      t.string :locale_name
      t.belongs_to :city, index: true
      t.belongs_to :calendar_truck_group, index: true
      t.timestamps
    end
  end
end
