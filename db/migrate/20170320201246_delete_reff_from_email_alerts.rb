class DeleteReffFromEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    remove_column :email_alerts, :contact_stage_id
  end
end
