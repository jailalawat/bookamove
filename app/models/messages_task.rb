class MessagesTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :subtask_staff_group
  belongs_to :task_sender, :class_name => 'SubtaskStaffGroup', :foreign_key => 'task_sender_id'
  has_many :user_messages_task

  def self.get_attachments(account_id, message_task_id)
    MessagesTaskAttachment.where(account_id: account_id, messages_task_id: message_task_id)
  end
end
