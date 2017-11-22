class EmailMessagesMoveRecord < ActiveRecord::Base
  belongs_to :messages_move_record
  belongs_to :user
end
