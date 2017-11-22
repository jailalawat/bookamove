class CreateCalendarStaffGroups < ActiveRecord::Migration
  def change
    create_table :calendar_staff_groups do |t|
      t.string :name
      t.string :description
      t.integer :account_id
      t.boolean :active, default: true
      t.timestamps

      #foreign key
      t.foreign_key :accounts
    end
  end
end
