class AddCalendarTruckGroupLinkToTax < ActiveRecord::Migration
  def change
    add_reference :taxes, :calendar_truck_group, index: true, foreign_key: true
  end
end
