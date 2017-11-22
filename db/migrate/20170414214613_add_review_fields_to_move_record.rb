class AddReviewFieldsToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :review_text, :text
    add_column :move_records, :review_status, :string
  end
end
