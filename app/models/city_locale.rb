class CityLocale < ActiveRecord::Base
  belongs_to :city

  validates_presence_of :locale_name
end
