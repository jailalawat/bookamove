class AddFieldConfirmationSendToMoveRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :move_records, :confirmation_send, :boolean, after: :complaint_response_send, default: false
  end
end
