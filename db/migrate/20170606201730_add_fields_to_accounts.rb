class AddFieldsToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :working_hours, :string
    add_column :accounts, :privacy_web_page, :string
    add_column :accounts, :contact_us_web_page, :string
  end
end
