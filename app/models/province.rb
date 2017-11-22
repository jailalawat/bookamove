class Province < ApplicationRecord
  has_many :cities

  validates_presence_of :description
end
