class CreateContactStageEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_stage_emails do |t|
      t.integer :contact_stage_id
      t.integer :email_alert_id
      t.timestamps
    end
  end
end
