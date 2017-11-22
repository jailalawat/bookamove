class MessagesMoveRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :move_record
  has_many :task_messages_move_record
  has_many :user_messages_move_record
  has_many :email_messages_move_record

  def self.get_attachments(account_id, messages_move_record_id)
    MessagesMoveRecordAttachment.where(account_id: account_id, messages_move_record_id: messages_move_record_id)
  end
end
