class Tax < ActiveRecord::Base
  belongs_to :calendar_truck_group

  validates_presence_of :gst, :pst
end
