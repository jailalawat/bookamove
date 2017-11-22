class AddReviewChosenSiteToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :review_chosen_site, :string, after: :review_text
  end
end
