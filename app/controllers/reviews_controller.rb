class ReviewsController < ApplicationController
  layout false
  include ReviewsHelper
  #before_filter :login_user_by_token

  def review_positive
    @account = Account.find(params[:account_id])
    @move = MoveRecord.find(params[:move_id])
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    if @move.move_record_location_origin.first.location.calendar_truck_group
      @links = ReviewLink.where(account_id: params[:account_id], calendar_truck_group_id: @move.move_record_location_origin.first.location.calendar_truck_group.id)
    else
      @links_old = review_links_by_city(params[:city])
    end
    @move_record_client = MoveRecordClient.where(move_record_id: @move.id).first.client
    @ra_email = @move_record_client.email

    SetOpReviewJob.perform_later(params[:move_id], "yes", "", "")
  end

  def click_review_positive
    if params[:move_id].present?
      move = MoveRecord.find(params[:move_id])

      if move
        move.update(review_chosen_site: params[:site], review_status: "positive")

        #log message
        message1 = MessagesMoveRecord.new
        message1.account_id = params[:account_id]
        message1.user_id = params[:user_id]
        message1.move_record_id = params[:move_id]
        message1.subject = '<span class=green>Positive review from customer</span>'
        message1.body = "Chosen #{params[:site]} review.".to_s
        message1.save

        SetOpReviewJob.perform_later(params[:move_id], "positive_review", params[:site], "")

      end

    end
  end

  def review_negative
    @account = Account.find(params[:account_id])
    @move = MoveRecord.find(params[:move_id])
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @move_record_client = MoveRecordClient.where(move_record_id: @move.id).first.client
    @ra_email = @move_record_client.email

    SetOpReviewJob.perform_later(params[:move_id], "no", "", "")
    MoverecordMail.complaint_response(params[:move_id]).deliver_later if not @move.complaint_response_send
    @move.update(complaint_response_send: true)
    ReviewNegativeResponseJob.set(wait: 1.minutes).perform_later(params[:move_id])
  end

  def submit_review_negative
    @account = Account.find(params[:account_id])
    @move = MoveRecord.find(params[:move_id])
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @move_record_client = MoveRecordClient.where(move_record_id: @move.id).first.client
    @ra_email = @move_record_client.email

    if params[:move_id].present? and params[:review_complaints].present?
      move = MoveRecord.find(params[:move_id])
      if move
        move.update(review_text: params[:review_complaints], review_status: "negative")

        #log message
        message1 = MessagesMoveRecord.new
        message1.account_id = params[:account_id]
        message1.user_id = params[:user_id]
        message1.move_record_id = params[:move_id]
        message1.subject = '<span class=red>Negative review from customer</span>'
        message1.body = params[:review_complaints].to_s
        message1.save

        #internal message to operations role
        operations_id = Role.find_by(name: "Operations", account_id: params[:account_id]).subtask_staff_group.id
        message2 = TaskMessagesMoveRecord.new
        message2.account_id = params[:account_id]
        message2.subtask_staff_group_id = operations_id
        message2.messages_move_record_id = message1.id
        message2.readed = false
        message2.save

        SetOpReviewJob.perform_later(params[:move_id], "negative_review", "", params[:review_complaints])
      end
    end
  end

end
