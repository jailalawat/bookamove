class CargoType < ActiveRecord::Base
  validates_presence_of :description, :account_id
end
