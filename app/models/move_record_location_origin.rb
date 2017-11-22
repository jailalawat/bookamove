class MoveRecordLocationOrigin < ActiveRecord::Base
  belongs_to :location
  belongs_to :move_record
end
