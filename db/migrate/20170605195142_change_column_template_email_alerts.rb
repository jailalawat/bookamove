class ChangeColumnTemplateEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    change_column :email_alerts, :template, :text
  end
end
