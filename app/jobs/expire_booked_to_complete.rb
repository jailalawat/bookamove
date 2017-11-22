class ExpireBookedToComplete
  include Sidekiq::Worker

  def perform(arguments)
    MoveRecord.expire_booked(arguments["account_id"], arguments["user_id"], arguments["move_record"])
  end

end