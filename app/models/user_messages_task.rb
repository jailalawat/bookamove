class UserMessagesTask < ActiveRecord::Base
  belongs_to :messages_task, touch: true
  belongs_to :user

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete("all_user_messages/#{self.user_id}")
  end

end
