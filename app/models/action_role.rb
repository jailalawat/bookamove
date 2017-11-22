class ActionRole < ActiveRecord::Base
  after_commit :clear_cache

  belongs_to :action
  belongs_to :role

  private
  def clear_cache
    Rails.cache.delete_matched("user_action_role/*")
    Rails.cache.delete_matched("user_action_by_role/*")
    Rails.cache.delete_matched("all_action_by_user/*")
    Rails.cache.delete_matched("all_user_actions/*")
  end
end
