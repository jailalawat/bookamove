class MoveStatusEmailAlert < ActiveRecord::Base
  belongs_to :move_status
  belongs_to :move_record

  def self.is_confirmed(move_id, account_id)
    return MoveStatusEmailAlert.find_by_move_record_id_and_contact_stage_id(move_id, ContactStage.where(account_id: account_id, sub_stage: "Confirm").pluck(:id).first).blank? ? false : true
  end
end
