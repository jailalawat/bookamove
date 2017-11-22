class MailProcessController < ApplicationController
  before_filter :current_user

  def cc_consent
    url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

    begin
      move_record = MoveRecord.find_by_id(params[:id])
      MoverecordMail.cc_consent(move_record, url).deliver_later

      @message = MessagesMoveRecord.new
      @message.account_id = @current_user.account_id
      @message.user_id = @current_user.id
      @message.subject = 'CC Consent Email'
      @message.body = "CC Consent Email"
      @message.move_record_id = params[:id]
      @message.message_type = 'email'
      @message.save

      render json: {message: @message, name: @current_user.name}

    rescue Exception => e
      render json: false
    end
  end

  def follow_up
    begin
      move_record = MoveRecord.find_by_id(params[:id])
      MoverecordMail.follow_up(move_record).deliver_later

      @message = MessagesMoveRecord.new
      @message.account_id = @current_user.account_id
      @message.user_id = @current_user.id
      @message.subject = 'Follow Up Email'
      @message.body = "Follow Up Email"
      @message.move_record_id = params[:id]
      @message.message_type = 'email'
      @message.save

      render json: {message: @message, name: @current_user.name}

    rescue Exception => e
      render json: false
    end
  end

  def non_disclosure
    url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

    begin
      move_record = MoveRecord.find_by_id(params[:id])
      MoverecordMail.non_disclosure(move_record, url).deliver_later

      @message = MessagesMoveRecord.new
      @message.account_id = @current_user.account_id
      @message.user_id = @current_user.id
      @message.subject = 'Non Disclosure Email'
      @message.body = "Non Disclosure Email"
      @message.move_record_id = params[:id]
      @message.message_type = 'email'
      @message.save

      render json: {message: @message, name: @current_user.name}

    rescue Exception => e
      render json: false
    end
  end

  def move
    url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

    begin
      document_type = params[:document_type].to_i
      if (document_type == Pdf::PROPOSAL)
        move_record = MoveRecord.find_by_id(params[:id])
        MoverecordMail.proposal(move_record, document_type).deliver_later

        @message = MessagesMoveRecord.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subject = 'Move Proposal Email'
        @message.body = "Move Proposal Email"
        @message.move_record_id = params[:id]
        @message.message_type = 'email'
        @message.save

        render json: {message: @message, name: @current_user.name}

      end

      if (document_type == Pdf::INVOICE)
        move_record = MoveRecord.find_by_id(params[:id])
        MoverecordMail.invoice(move_record, document_type, url).deliver_later

        @message = MessagesMoveRecord.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subject = 'Move Invoice Email'
        @message.body = "Move Invoice Email"
        @message.move_record_id = params[:id]
        @message.message_type = 'email'
        @message.save

        render json: {message: @message, name: @current_user.name}

      end

      if (document_type == Pdf::RECEIPT)
        move_record = MoveRecord.find_by_id(params[:id])
        MoverecordMail.receipt(move_record, document_type, url).deliver_later

        @message = MessagesMoveRecord.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subject = 'Move Receipt Email'
        @message.body = "Move Receipt Email"
        @message.move_record_id = params[:id]
        @message.message_type = 'email'
        @message.save

        render json: {message: @message, name: @current_user.name}

      end
    rescue Exception => e
      render json: false
    end
  end
end
