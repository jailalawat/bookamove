class AddMoveStageAlertToMoveRecordDefaultSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :move_record_default_settings, :show_contract_stage_detail, :boolean, default: true
    add_column :move_record_default_settings, :show_move_stage_alert, :boolean, default: true

    add_reference :move_record_default_settings, :move_stage_alerts, index: true, foreign_key: true
  end
end
