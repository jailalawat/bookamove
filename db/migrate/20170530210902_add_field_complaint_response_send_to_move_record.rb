class AddFieldComplaintResponseSendToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :complaint_response_send, :boolean, after: :review_thank_you_send, default: false
  end
end
