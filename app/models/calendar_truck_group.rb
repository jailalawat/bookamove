class CalendarTruckGroup < ActiveRecord::Base
  attr_accessor :trucks
  after_commit :clear_cache

  has_many :review_links, dependent: :destroy
  has_one :tax, dependent: :destroy

  validates_presence_of :name

  private
  def clear_cache
    Rails.cache.delete("all_calendar_truck_group/#{self.account_id}")
  end
end
