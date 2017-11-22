class AddPhoneNumberToCalendarTruckGroup < ActiveRecord::Migration
  def change
    add_column :calendar_truck_groups, :phone_number, :string
  end
end
