class ReviewNegativeResponseJob < ApplicationJob
  queue_as :default

  def perform(move_id)
    @move = MoveRecord.find(move_id)
    @move.update(complaint_response_send: false)
  end
end
