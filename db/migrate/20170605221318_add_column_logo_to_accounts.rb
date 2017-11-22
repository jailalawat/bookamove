class AddColumnLogoToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :logo, :string, after: :name
  end
end
