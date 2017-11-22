class ImageProfile < ActiveRecord::Base
  after_commit :clear_cache

  private
  def clear_cache
    Rails.cache.delete("image_profile/#{self.user_id}")
  end
end
