class MoveRecordTruck < ActiveRecord::Base
  belongs_to :move_record
  belongs_to :truck
  belongs_to :user, foreign_key: "lead"
end
