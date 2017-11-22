class SetOpReviewJob < ApplicationJob
  queue_as :default
  require "uri"
  require "net/http"
  require "net/https"

  def perform(move_id, mode, site, complaints)
    if move_id
      event = MoveRecord.find(move_id)

      if event and event.old_system_id
        p = "mode=#{mode}&old_system_id=#{event.old_system_id}&site=#{site}&review_complaints=#{complaints}"

        #http = Net::HTTP.new('oomovers.local.loc', 3001)
        http = Net::HTTP.new('oomovers.moveonline.com', 443)
        http.use_ssl = true
        path = '/replicate_review_external'
        http.post(path, p)
      end

    end
  end
end
