class CustomerMoveRecordsController < MessagesMoveRecordsController
  before_filter :current_user, except: :show
  before_filter :login_user_by_token, only: :show
  before_filter :index_messages

  def show
    @move_record = MoveRecord.find_by(id: params[:id])
    @move_record_clients = MoveRecordClient.where(move_record_id: params[:id])
    @client = @move_record_clients[0].client

    if @client.user_id == @current_user.id
      @page_title = "Move: &nbsp;<i class='icon-truck blank3 blue-text'></i><span id='pTitle_text'>#{@move_record.move_contract_name}</span> <span id='job_status' class='bright_red'></span>".html_safe
      @is_move_posted = MoveStatusEmailAlert.exists?(account_id: @current_user.account_id, move_record_id: params[:id], contact_stage_id: ContactStage.where(account_id: @current_user.account_id, stage: "Post"))

      # client confirmation
      if params[:confirm].present? or params[:reconfirm2].present? or params[:reconfirm7].present?
        is_move_completed = MoveStatusEmailAlert.exists?(account_id: @current_user.account_id, move_record_id: params[:id], contact_stage_id: ContactStage.where(account_id: @current_user.account_id, stage: "Complete"))

        if not is_move_completed

          if params[:confirm].present?
            @move_record.approved = params[:confirm]
            @move_record.save
            flash.now[:notice] = 'Move record confirmed. Thank You.'
            @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(account_id: @move_record.account_id, move_record_id: @move_record.id, contact_stage_id: ContactStage.where(account_id: @current_user.account_id, sub_stage: "Confirm").pluck(:id).first)
            @move_status_email.save

            # log msg
            message = MessagesMoveRecord.new
            message.account_id = @current_user.account_id
            message.user_id = @current_user.id
            message.subject = "Contact Stage Confirm"
            message.body = "Customer confirmed move"
            message.move_record_id = params[:id]
            message.save
          elsif params[:reconfirm2].present?
            flash.now[:notice] = 'Move record re-confirmed. Thank You.'
            @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(account_id: @move_record.account_id, move_record_id: @move_record.id, contact_stage_id: ContactStage.where(account_id: @current_user.account_id, sub_stage: "Confirm 2").pluck(:id).first)
            @move_status_email.save

            # log msg
            message = MessagesMoveRecord.new
            message.account_id = @current_user.account_id
            message.user_id = @current_user.id
            message.subject = "Contact Stage Confirm 2"
            message.body = "Customer re-confirmed move"
            message.move_record_id = params[:id]
            message.save
          elsif params[:reconfirm7].present?
            flash.now[:notice] = 'Move record re-confirmed. Thank You.'
            @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(account_id: @move_record.account_id, move_record_id: @move_record.id, contact_stage_id: ContactStage.where(account_id: @current_user.account_id, sub_stage: "Confirm 7").pluck(:id).first)
            @move_status_email.save

            # log msg
            message = MessagesMoveRecord.new
            message.account_id = @current_user.account_id
            message.user_id = @current_user.id
            message.subject = "Contact Stage Confirm 7"
            message.body = "Customer re-confirmed move"
            message.move_record_id = params[:id]
            message.save
          end

        else
          flash[:error] = "Sorry. This move has already been completed. Cannot confirm completed moves."
        end
      end

      move_stage = MoveStatusEmailAlert.where(move_record_id: params[:id]).where.not(contact_stage_id: nil).order(id: :desc).first
      @move_stage_name = ContactStage.where(id: move_stage.contact_stage_id).first

      @move_record_origins = MoveRecordLocationOrigin.where(move_record_id: params[:id])
      @move_record_destinations = MoveRecordLocationDestination.where(move_record_id: params[:id])
      @move_record_date = MoveRecordDate.where(move_record_id: params[:id]).first
      @move_record_trucks = MoveRecordTruck.where(move_record_id: params[:id])
      @move_record_cost_hourly = MoveRecordCostHourly.find_by(move_record_id: params[:id])
      @move_record_packing = MoveRecordPacking.find_by(move_record_id: params[:id])
      @move_record_other_cost = MoveRecordOtherCost.find_by(move_record_id: params[:id])
      @move_record_surchage = MoveRecordSurcharge.find_by(move_record_id: params[:id])
      @move_record_flat_rate = MoveRecordFlatRate.find_by(move_record_id: params[:id])
      @move_record_discount = MoveRecordDiscount.find_by(move_record_id: params[:id])
      @move_record_insurance = MoveRecordInsurance.find_by(move_record_id: params[:id])
      @move_record_fuel_cost = MoveRecordFuelCost.find_by(move_record_id: params[:id])
      @move_record_payment = MoveRecordPayment.find_by(move_record_id: params[:id])
      @rooms = Room.all

    else
      unauthorized
    end

  end

end