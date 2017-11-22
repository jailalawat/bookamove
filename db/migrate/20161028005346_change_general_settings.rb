class ChangeGeneralSettings < ActiveRecord::Migration[5.0]
  def change
    #remove_column :general_settings, :active
    add_column :general_settings, :type, :string
  end
end
