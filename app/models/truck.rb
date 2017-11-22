class Truck < ActiveRecord::Base
  validates_presence_of :description, :account_id
  has_one :list_truck_group
  belongs_to :truck_size
  has_one :move_record_truck
  has_many :truck_available
  belongs_to :user, :class_name => 'User', :foreign_key => 'driver'
end
