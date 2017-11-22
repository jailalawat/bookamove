class MoveRecordClient < ActiveRecord::Base
  belongs_to :client
  belongs_to :move_record

  def self.get_client(account_id, move_record_id)
    MoveRecordClient.where(account_id: account_id, move_record_id: move_record_id).first
  end
end
