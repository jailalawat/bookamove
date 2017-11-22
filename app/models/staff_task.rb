class StaffTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :subtask_staff_group
end
