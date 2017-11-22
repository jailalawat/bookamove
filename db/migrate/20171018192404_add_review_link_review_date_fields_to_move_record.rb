class AddReviewLinkReviewDateFieldsToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :review_date, :date, after: :review_text
    add_column :move_records, :review_link, :string, after: :review_text, :limit => 500
  end
end
