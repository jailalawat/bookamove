class Role < ActiveRecord::Base
  after_commit :clear_cache

  belongs_to :calendar_staff_group
  has_one :subtask_staff_group, dependent: :destroy

  has_many :role_users
  has_many :users, through: :role_users

  after_create_commit :create_subtask
  after_update_commit :update_subtask

  def self.assign_permissions(role_id, role_level, account_id)
    permissions = Action.where('role_level <= ?', role_level).where('created_at > ?', '2017-10-21 00:00:00')
    permissions.each do |action|
      ActionRole.create(account_id: account_id, role_id: role_id, action_id: action.id)
    end
  end

  def self.remove_permissions(role_id)
    ActionRole.where(role_id: role_id).delete_all
  end

  def self.return_to_default_values(role_id, role_level, account_id)
    remove_permissions(role_id)
    assign_permissions(role_id, role_level, account_id)
  end


  private
  def create_subtask
    SubtaskStaffGroup.create(role_fields)
  end

  def update_subtask
    subtask = SubtaskStaffGroup.find_by(role_id: self.id)
    if subtask
    subtask.update(role_fields)
    else
      create_subtask
    end
  end

  def role_fields
    { account_id: self.account_id, name: self.name, description: self.description, role_level: self.role_level, calendar_staff_group_id: self.calendar_staff_group_id, mailbox: self.mailbox, active: self.active, role_id: self.id }
  end

  def name_with_role
    "#{self.name.strip}#{self.role_level}"
  end

  def clear_cache
    Rails.cache.delete_matched("role_level/*")
  end

end
