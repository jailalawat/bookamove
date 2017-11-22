class Message < ActiveRecord::Base
  belongs_to :user
  has_many :user_message

  def self.get_attachments(account_id, message_id)
    MessageAttachment.where(account_id: account_id, message_id: message_id)
  end
end
