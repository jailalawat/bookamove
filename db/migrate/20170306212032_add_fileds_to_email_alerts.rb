class AddFiledsToEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :email_alerts, :auto_send, :boolean, default: false, after: :active
    add_column :email_alerts, :default, :boolean, default: false, after: :active
  end
end
