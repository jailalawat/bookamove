class AddContractStageAlertToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :contract_stage_detail, :string, :after => :contract_stage_note
    add_column :move_records, :contract_stage_alert_id, :string, null: true, :after => :contract_stage_detail
  end
end
