class AddMoveSubsourceIdToDefaultSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :move_record_default_settings, :move_subsource_id, :integer
  end
end
