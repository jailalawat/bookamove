class AddFieldInstructionsToEmailAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :email_alerts, :instructions, :string
  end
end
