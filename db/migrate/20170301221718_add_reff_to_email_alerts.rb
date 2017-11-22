class AddReffToEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :email_alerts, :contact_stage_id, :integer, default: nil, after: :account_id, index: true
  end
end
