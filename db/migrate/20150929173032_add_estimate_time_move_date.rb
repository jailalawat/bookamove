class AddEstimateTimeMoveDate < ActiveRecord::Migration
  def change
    add_column :move_record_dates, :estimation_time, :string
  end
end
