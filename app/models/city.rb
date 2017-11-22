class City < ActiveRecord::Base
  belongs_to :province
  has_many :city_locales

  validates_presence_of :description
end
