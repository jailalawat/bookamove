class AddFieldReviewSendToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :review_send, :boolean, after: :review_status, default: false
  end
end
