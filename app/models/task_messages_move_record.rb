class TaskMessagesMoveRecord < ActiveRecord::Base
  belongs_to :messages_move_record
  belongs_to :subtask_staff_group
end
