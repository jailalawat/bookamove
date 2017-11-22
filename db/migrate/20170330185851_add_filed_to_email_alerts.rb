class AddFiledToEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :email_alerts, :stage_num, :integer, after: :auto_send
  end
end
