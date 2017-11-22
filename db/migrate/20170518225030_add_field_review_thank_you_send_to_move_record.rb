class AddFieldReviewThankYouSendToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :review_thank_you_send, :boolean, after: :review2_send, default: false
  end
end
