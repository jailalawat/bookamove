class AddEstimationTimeContractSettings < ActiveRecord::Migration
  def change
    add_column :move_record_default_settings, :show_estimation_time, :boolean, default: true
  end
end
