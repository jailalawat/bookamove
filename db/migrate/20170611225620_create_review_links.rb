class CreateReviewLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :review_links do |t|
      t.integer :account_id
      t.string :icon
      t.string :name
      t.string :link_url, limit: 500
      t.integer :calendar_truck_group_id
      t.timestamps
    end

    add_index :review_links, :account_id
    add_index :review_links, :calendar_truck_group_id
  end
end
