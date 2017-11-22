class RoleUser < ActiveRecord::Base
  after_commit :clear_cache

  belongs_to :user
  belongs_to :role

  def self.get_name_rol(user_id)
    role = where(user_id: user_id).last
    role.role.name if role
  end

  private
  def clear_cache
    Rails.cache.delete("current_role/#{self.user_id}")
  end
end
