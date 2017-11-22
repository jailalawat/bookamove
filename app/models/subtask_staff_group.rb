class SubtaskStaffGroup < ActiveRecord::Base
  attr_accessor :users
  belongs_to :calendar_staff_group
  belongs_to :role
  has_many :task_available_calendar, :dependent => :delete_all

  after_commit :clear_cache

  private
  def clear_cache
    Rails.cache.delete("all_subtask_staff_group/#{self.account_id}")
  end
end
