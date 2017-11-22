class CreateSubtaskStaffGroups < ActiveRecord::Migration
  def change
    create_table :subtask_staff_groups do |t|
      t.string :name
      t.string :description
      t.integer :account_id
      t.integer :calendar_staff_group_id
      t.boolean :mailbox, default: true
      t.boolean :active, default: true
      t.timestamps

      #foreign key
      t.foreign_key :accounts
      t.foreign_key :calendar_staff_groups
    end
  end
end
