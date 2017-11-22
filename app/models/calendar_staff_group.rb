class CalendarStaffGroup < ActiveRecord::Base
  after_commit :clear_cache

  private
  def clear_cache
    Rails.cache.delete("all_calendar_staff_group/#{self.account_id}")
  end
end
