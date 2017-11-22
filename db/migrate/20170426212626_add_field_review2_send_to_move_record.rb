class AddFieldReview2SendToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :review2_send, :boolean, after: :review_send, default: false
  end
end
