class AddReffToMoveStatusEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :move_status_email_alerts, :contact_stage_id, :integer, default: nil, after: :move_status_id, index: true
  end
end
