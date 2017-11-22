class MoveRecordsController < MessagesMoveRecordsController
  before_filter :current_user, except: :edit
  before_filter :login_user_by_token, only: :edit
  before_filter :index_messages
  before_action :set_settings, only: [:index, :edit, :update, :destroy, :get_subsource_by_source]

  def index
    validate_permissions("create.moves") ? '' : return
    @clients = []
    @trucks = []
    @origins = []
    @destinations = []
    @dates = []
    @enable_icon = 'fa fa-check-circle icon-green disable'
    @disable_icon = 'fa fa-check-circle icon-gray disable'
    @move_type = MoveType.new
    @location = Location.new
    @move_record = MoveRecord.new
    fill_data_dropdown()
    @settings.number_of_clients.times { @clients.push(Client.new) }
    @settings.number_of_trucks.times { @trucks.push(Truck.new) }
    @settings.number_of_origin.times { @origins.push(Location.new) }
    @settings.number_of_destination.times { @destinations.push(Location.new) }
    @settings.number_of_date.times { @dates.push(MoveRecordDate.new) }
  end

  def fill_data_dropdown
    #dropdown show
    @move_type_data = MoveType.where(account_id: @current_user.account_id, active: 1)
    @truck_data = Truck.where(account_id: @current_user.account_id, active: 1)
    @move_type_alert = MoveTypeAlert.where(account_id: @current_user.account_id, active: 1)
    @equipment_alert = EquipmentAlert.where(account_id: @current_user.account_id, active: 1)
    @payment_alert = PaymentAlert.where(account_id: @current_user.account_id, active: 1)
    @packing_alert = PackingAlert.where(account_id: @current_user.account_id, active: 1)
    @time_alert = TimeAlert.where(account_id: @current_user.account_id, active: 1)
    @move_source = MoveSource.where(account_id: @current_user.account_id, active: 1)
    #@move_subsource = MoveSubsource.where(account_id: @current_user.account_id, active: 1)
    @move_keyword = MoveKeyword.where(account_id: @current_user.account_id, active: 1)
    @move_webpage = MoveWebpage.where(account_id: @current_user.account_id, active: 1)
    @move_referral = MoveReferral.where(account_id: @current_user.account_id, active: 1)
    @move_alert = MoveSourceAlert.where(account_id: @current_user.account_id, active: 1)
    @cargo_type = CargoType.where(account_id: @current_user.account_id, active: 1)
    @cargo_alert = CargoAlert.where(account_id: @current_user.account_id, active: 1)
    @access_alert = AccessAlert.where(account_id: @current_user.account_id, active: 1)
    @contract_stage_alert = MoveStageAlert.where(account_id: @current_user.account_id, active: 1)
    #@users = RoleUser.where(:account_id => @current_user.account_id).includes(:user)
    #@users = @users.blank? ? @users : @users.map { |v| v.user }
    @users = User.joins(:roles).where("roles.name = ? or roles.name = ? or roles.name = ?", "mover", "Owner Operator", "Swamper").where(account_id: @current_user.account_id, active: true).select("users.*")
    @rooms = Room.all
  end

  def create
    validate_permissions("create.moves") ? '' : return
    begin
      url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
      @move_record = MoveRecord.create_move_record(move_record_params, client_params, move_record_origin_params, move_record_destination_params, move_record_date_params, move_record_truck_params, move_record_cost_hourly_params, move_record_packing_params, move_record_other_cost_params, move_record_surchage_params, move_record_flat_rate_params, move_record_discount_params, move_record_insurance_params, move_record_fuel_cost_params, move_record_payment_params, move_record_contact_stage_params, params[:calc_cargo], url, @current_user, generate_random_password())
      redirect_to "/move_records/#{@move_record.id}/edit?new=true"
    rescue => exception
      flash[:danger] = "A problem has occurred. Try again. Make sure that Email is in proper format (e.g. example@example.com)."
      redirect_to "/move_records"
    end
  end

  def edit
    if validate_special_permission("view.moves_without_who_how_much_or_street_address_number") or validate_special_permission("view.moves_in_full_only_within_24_hrs_of_move_time") or validate_special_permission("view.moves_without_log_contact_stages") or validate_special_permission("view.moves_without_how_much") or validate_special_permission("view.moves_without_who_street_address_number") or validate_special_permission("view.moves_without_shares") or validate_special_permission("view.moves_in_full") or validate_special_permission("view.my_moves_in_full_only_within_24_hrs_of_move_time") or validate_special_permission("view.my_moves_without_log_contact stages") or validate_special_permission("view.my_moves_without_how_much") or validate_special_permission("view.my_moves_without_who_street_address_number") or validate_special_permission("view.my_moves_without_shares") or validate_special_permission("view.my_moves_in_full")

      @disable_icon = 'fa fa-check-circle icon-gray disable'

      #@move_record  = MoveRecord.find_by_account_id_and_id(@current_user.account_id, params[:id])
      #@move_record.locked_move_record = true;
      #@move_record.user_locked_move_record_id = @current_user.id
      @move_record = MoveRecord.find_by_account_id_and_id(@current_user.account_id, params[:id])
      @page_title = "Move: &nbsp;<i class='icon-truck blank3 blue-text'></i><span id='pTitle_text'>#{@move_record.move_contract_name}</span> <span id='job_status' class='bright_red'></span>".html_safe +
          "<div class='col-md-1 pull-right'><i class='icon-print toggle-div pointer printer-icon blue'></i><ul class='dropdown-menu cost-option-hide text-left' role='menu'><li href='#{terms_path(id: params[:id])}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Terms</a></li><li href='#{cargo_path(id: params[:id])}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Cargo</a></li><li href='#{cc_consent_path(id: params[:id])}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> CC Consent</a></li><li href='#{damage_claim_path(id: params[:id])}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Damage Claim</a></li><li href='#{costs_and_surchage_path(id: params[:id])}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Costs and Surchage</a></li><li href='#{non_disclosure_path(id: params[:id])}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Settlement Agreement</a></li><li href='#{non_disclosure_path(id: params[:id], blank: true)}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Blank Settlement Agreement</a></li><li href='#{move_path(id: params[:id], document_type: Pdf::PROPOSAL)}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Move Proposal</a></li><li href='#{move_path(id: params[:id], document_type: Pdf::CONTRACT)}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Move Contract</a></li><li href='#{move_path(id: params[:id], document_type: Pdf::INVOICE)}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Move Invoice</a></li><li href='#{move_path(id: params[:id], document_type: Pdf::RECEIPT)}' class='printers-item pointer'><a><i class='small_icon fa fa-file-pdf-o'></i> Move Receipt</a></li></ul></div>".html_safe

      @my_move = (@move_record.user_id == @current_user.id) if not @move_record.user_id.nil?

      fill_data_dropdown()
      @move_record_clients = MoveRecordClient.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @move_record_origins = MoveRecordLocationOrigin.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @move_record_destinations = MoveRecordLocationDestination.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @move_record_dates = MoveRecordDate.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @move_record_trucks = MoveRecordTruck.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @move_record_cost_hourly = MoveRecordCostHourly.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_packing = MoveRecordPacking.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_other_cost = MoveRecordOtherCost.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_surchage = MoveRecordSurcharge.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_flat_rate = MoveRecordFlatRate.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_discount = MoveRecordDiscount.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_insurance = MoveRecordInsurance.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_fuel_cost = MoveRecordFuelCost.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_payment = MoveRecordPayment.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      @move_record_contact_stage = MoveStatusEmailAlert.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @calc_cargo = MoveRecordCargo.where(account_id: @current_user.account_id, move_record_id: params[:id])
      @provinces = Province.all.select(:id, :description)
      @truck_group_default_id = @move_record_origins[0].location.calendar_truck_group_id.blank? ? @settings.origin_calendar_truck_group_id : @move_record_origins[0].location.calendar_truck_group_id

      if not @move_record_dates[0].move_time.nil?
        move_time = Time.parse((@move_record_dates[0].move_date.strftime("%d/%m/%Y") + " " + @move_record_dates[0].move_time.strftime("%I:%M %P")).to_s)
        @is_within_24h = (MoveRecord.time_difference(move_time, Time.now) / 3600) <= 24
      else
        @is_within_24h = false
      end

      move_record_array_stages = []
      @move_record_contact_stage.each do |contact_stage|
        move_record_array_stages.push({id: contact_stage.contact_stage_id, email: {contact_stage.email_alert_id => {id: contact_stage.email_alert_id}}})
        @move_record_current_stage = contact_stage.contact_stage_id if not contact_stage.contact_stage_id.nil?
      end

      stage = ContactStage.where(account_id: @current_user.account_id, id: @move_record_current_stage).first

      if stage
        @move_record_current_stage_num = stage.stage_num
        @move_record_current_stage_name = stage.stage || stage.sub_stage
      else
        @move_record_current_stage_num = 0
        @move_record_current_stage_name = ""
      end

      @move_record_json_stages = move_record_array_stages.to_json
      @can_edit_commission = validate_special_permission("edit.shares")
      @can_edit_move_record = validate_special_permission("edit.moves_only_in_lead_contact_stage") or validate_special_permission("edit.moves_only_in_booked_and_lead_contact_stage") or validate_special_permission("edit.moves_only_in_booked_and_lead_contact_stage") or validate_special_permission("edit.moves_only_before_posted_contact_stage") or validate_special_permission("edit.unable_cancel") or validate_special_permission("edit.how_much") or validate_special_permission("edit.shares") or validate_special_permission("edit.moves_in_full")
      @can_edit_move_record_submit = true
      @can_show_move_record_submit = true

      if (@can_edit_commission)
        @move_status_lead = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, stage: "Lead").pluck(:id).first, LeadCommissionMoveRecord, params[:id])
        @move_status_follow_up = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Follow Up").pluck(:id).first, false, params[:id])
        @move_status_quote = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Quote").pluck(:id).first, QuoteCommissionMoveRecord, params[:id])
        @move_status_book = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, stage: "Book").pluck(:id).first, BookCommissionMoveRecord, params[:id])
        @move_status_dispatch = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Dispatch").pluck(:id).first, DispatchCommissionMoveRecord, params[:id])
        @move_status_confirm = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Confirm").pluck(:id).first, ConfirmCommissionMoveRecord, params[:id])
        @move_status_receive = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Receive").pluck(:id).first, false, params[:id])
        #@move_status_active = validate_move_status(@move_record_contact_stage, ContactStages::STAGES[:active], false, params[:id])
        @move_status_active = {:user=>nil, :commission=>nil}
        @move_status_complete = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, stage: "Complete").pluck(:id).first, false, params[:id])
        @move_status_unable = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Unable").pluck(:id).first, false, params[:id])
        @move_status_cancel = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Cancel").pluck(:id).first, false, params[:id])
        @move_status_submit = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Submit").pluck(:id).first, false, params[:id])
        @move_status_invoice = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Invoice").pluck(:id).first, InvoiceCommissionMoveRecord, params[:id])
        @move_status_post = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Post").pluck(:id).first, PostCommissionMoveRecord, params[:id])
        @move_status_aftercare = validate_move_status(@move_record_contact_stage, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Aftercare").pluck(:id).first, AftercareCommissionMoveRecord, params[:id])
        @move_company_comission = CompanyCommissionMoveRecord.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      end

      if (@can_show_move_record_submit)
        @move_record_submit = MoveRecordSubmit.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      end

      if (@can_edit_commission)
        @move_status_driver = DriverCommissionMoveRecord.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])
      end

      @move_booked = MoveStatusEmailAlert.exists?(:account_id => @current_user.account_id, :move_record_id => params[:id], :contact_stage_id => ContactStage.where(account_id: @current_user.account_id, stage: "Book").pluck(:id).first)

      @contact_stage0_sub_stages = ContactStage.where(account_id: @current_user.account_id, stage_num: 0).order(:position)
      @contact_stage1_sub_stages = ContactStage.where(account_id: @current_user.account_id, stage_num: 1).order(:position)
      @contact_stage2_sub_stages = ContactStage.where(account_id: @current_user.account_id, stage_num: 2).order(:position)

    else
      unauthorized
    end

  end

  def update
    if validate_special_permission("edit.moves_only_in_lead_contact_stage") or validate_special_permission("edit.moves_only_in_booked_and_lead_contact_stage") or validate_special_permission("edit.moves_only_in_booked_and_lead_contact_stage") or validate_special_permission("edit.moves_only_before_posted_contact_stage") or validate_special_permission("edit.unable_cancel") or validate_special_permission("edit.how_much") or validate_special_permission("edit.shares") or validate_special_permission("edit.moves_in_full")

      ActiveRecord::Base.transaction do
        if move_record_submit_section_params
          submit_section = MoveRecordSubmit.find_or_initialize_by(account_id: @current_user.account_id, move_record_id: params[:id])
          submit_section.update(move_record_submit_section_params)
          submit_section.save
        end

        if client_params
          Client.update(client_params.keys, client_params.values)
        end

        move_record = MoveRecord.update(params[:id], move_record_params)
        #move_record.locked_move_record = false;
        #move_record.user_locked_move_record_id = nil
        #move_record.save

        params[:calc_cargo].each do |cargo|
          if cargo[0].match(/delete_/)
            MoveRecordCargo.delete(cargo[1]["delete"].to_i)
            next
          end

          if cargo[0].match(/new_/)
            unless cargo[1]["description"].blank? && cargo[1]["quantity"].to_f == 0
              move_cargo = MoveRecordCargo.new
              move_cargo.description = cargo[1]["description"]
              move_cargo.quantity = cargo[1]["quantity"]
              move_cargo.unit_volume = cargo[1]["volume"]
              move_cargo.unit_weight = cargo[1]["weight"]
              move_cargo.move_record_id = move_record.id
              move_cargo.account_id = @current_user.account_id
              move_cargo.save
            end
            next
          end
          if cargo[0].match(/\d+/)
            move_cargo = MoveRecordCargo.find_or_initialize_by(id: cargo[0], move_record_id: move_record.id)
            move_cargo.description = cargo[1]["description"]
            move_cargo.quantity = cargo[1]["quantity"]
            move_cargo.unit_volume = cargo[1]["volume"]
            move_cargo.unit_weight = cargo[1]["weight"]
            move_cargo.save
          end
        end

        #move origin
        move_record_origin_params.each do |parameter|
          if (parameter[0].match(/new_/))
            origin = Location.new(parameter[1])
            origin.account_id = @current_user.account_id
            origin.save
            move_record_client = MoveRecordLocationOrigin.new
            move_record_client.move_record_id = params[:id]
            move_record_client.location_id = origin.id
            move_record_client.account_id = @current_user.account_id
            move_record_client.save
          else
            Location.update(parameter[0], parameter[1])
          end
        end

        #move destination
        move_record_destination_params.each do |parameter|
          if (parameter[0].match(/new_/))
            destination = Location.new(parameter[1])
            destination.account_id = @current_user.account_id
            destination.save
            move_record_client = MoveRecordLocationDestination.new
            move_record_client.move_record_id = params[:id]
            move_record_client.location_id = destination.id
            move_record_client.account_id = @current_user.account_id
            move_record_client.save
          else
            Location.update(parameter[0], parameter[1])
          end
        end

        #move date
        move_record_date_params.each do |date|
          if (date[0].match(/new_/))
            move_record_client = MoveRecordDate.new(date[1])
            move_record_client.move_record_id = params[:id]
            move_record_client.account_id = @current_user.account_id
            move_record_client.save
          else
            MoveRecordDate.update(date[0], date[1])
          end
        end

        #move truck
        move_record_truck_params.each do |truck|
          if (truck[0].match(/new_/))
            move_record_truck = MoveRecordTruck.new(truck[1])
            move_record_truck.move_record_id = params[:id]
            move_record_truck.account_id = @current_user.account_id
            move_record_truck.save
          else
            MoveRecordTruck.update(truck[0], truck[1])
          end
        end

        #move cost hourly
        if move_record_cost_hourly_params
          MoveRecordCostHourly.update(move_record_cost_hourly_params.keys, move_record_cost_hourly_params.values)
        end

        #move packing
        if move_record_packing_params
          MoveRecordPacking.update(move_record_packing_params.keys, move_record_packing_params.values)
        end

        #move other cost
        if move_record_other_cost_params
          MoveRecordOtherCost.update(move_record_other_cost_params.except(:percentage_gst, :percentage_pst).keys, move_record_other_cost_params.except(:percentage_gst, :percentage_pst).values)
        end

        #move surchage
        if move_record_surchage_params
          MoveRecordSurcharge.update(move_record_surchage_params.except(:percentage_gst, :percentage_pst).keys, move_record_surchage_params.except(:percentage_gst, :percentage_pst).values)
        end

        #move flat rate
        if move_record_flat_rate_params
          MoveRecordFlatRate.update(move_record_flat_rate_params.keys, move_record_flat_rate_params.values)
        end

        #move discount
        if move_record_discount_params
          MoveRecordDiscount.update(move_record_discount_params.keys, move_record_discount_params.values)
        end

        #move insurance
        if move_record_insurance_params
          MoveRecordInsurance.update(move_record_insurance_params.keys, move_record_insurance_params.values)
        end

        #move fuel cost
        if move_record_fuel_cost_params
          MoveRecordFuelCost.update(move_record_fuel_cost_params.keys, move_record_fuel_cost_params.values)
        end

        #move payment
        if move_record_fuel_cost_params
          MoveRecordPayment.update(move_record_payment_params.keys, move_record_payment_params.values)
        end

        update_commission(move_record_commission_lead_params, LeadCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, stage: "Lead").pluck(:id).first) if move_record_commission_lead_params
        update_commission(move_record_commission_quote_params, QuoteCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Quote").pluck(:id).first) if move_record_commission_quote_params
        update_commission(move_record_commission_book_params, BookCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, stage: "Book").pluck(:id).first) if move_record_commission_book_params
        update_commission(move_record_commission_dispatch_params, DispatchCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Dispatch").pluck(:id).first) if move_record_commission_dispatch_params
        update_commission(move_record_commission_confirm_params, ConfirmCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Confirm").pluck(:id).first) if move_record_commission_confirm_params
        update_commission(move_record_commission_invoice_params, InvoiceCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Invoice").pluck(:id).first) if move_record_commission_invoice_params
        update_commission(move_record_commission_post_params, PostCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Post").pluck(:id).first) if move_record_commission_post_params
        update_commission(move_record_commission_aftercare_params, AftercareCommissionMoveRecord, move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Aftercare").pluck(:id).first) if move_record_commission_aftercare_params

        if move_record_company_commission_params
          company_commission = CompanyCommissionMoveRecord.find_or_initialize_by(account_id: @current_user.account_id, move_record_id: move_record.id)
          company_commission.update(move_record_company_commission_params)
          company_commission.account_id = @current_user.account_id
          company_commission.save
        end

        if move_record_driver_commission_params
          driver_commission = DriverCommissionMoveRecord.find_or_initialize_by(account_id: @current_user.account_id, move_record_id: move_record.id)
          driver_commission.update(move_record_driver_commission_params)
          driver_commission.account_id = @current_user.account_id
          driver_commission.save
        end

        @move_status_driver = DriverCommissionMoveRecord.find_by_account_id_and_move_record_id(@current_user.account_id, params[:id])

        update_contact_stage(move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Follow Up").pluck(:id).first, move_record_commission_follow_up_params) if move_record_commission_follow_up_params
        update_contact_stage(move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Receive").pluck(:id).first, move_record_commission_receive_params) if move_record_commission_receive_params
        #update_contact_stage(move_record, ContactStages::STAGES[:active], move_record_commission_active_params)
        update_contact_stage(move_record, ContactStage.where(account_id: @current_user.account_id, stage: "Complete").pluck(:id).first, move_record_commission_complete_params) if move_record_commission_complete_params
        update_contact_stage(move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Unable").pluck(:id).first, move_record_commission_unable_params) if move_record_commission_unable_params
        update_contact_stage(move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Cancel").pluck(:id).first, move_record_commission_cancel_params) if move_record_commission_cancel_params
        update_contact_stage(move_record, ContactStage.where(account_id: @current_user.account_id, sub_stage: "Submit").pluck(:id).first, move_record_commission_submit_params) if move_record_commission_submit_params

        move_record.move_contract_name = MoveRecord.contract_name_format(move_record.move_record_client.first.client.name,
                                                                         move_record.move_record_date.first.move_date,
                                                                         move_record.move_record_location_origin.first.location.calendar_truck_group_id.blank? ? "" : move_record.move_record_location_origin.first.location.calendar_truck_group.name,
                                                                         move_record.id)
        move_record.move_contract_number = move_record.id
        move_record.save

        respond_to do |format|
          #format.html { redirect_to edit_move_record_path(params[:id]), notice: 'Move record updated.' }
          if params[:clients]
            format.json { render json: {status: 'success', move_contract_name: move_record.move_contract_name, home_phone: params[:clients].to_a[0][1].values.to_a[2], cell_phone: params[:clients].to_a[0][1].values.to_a[3], work_phone: params[:clients].to_a[0][1].values.to_a[4]} }
          else
            format.json { render json: {status: 'success', move_contract_name: move_record.move_contract_name} }
          end
        end
      end
    else
      respond_to do |format|
        format.json { render json: {status: 'No Permissions'}, status: :unprocessable_entity }
      end
    end
  end

  def update_contact_stages
    if validate_special_permission("edit.contact_stages")
    @contact_id = params[:contact_stage_id]
    @log_messages = []
    stage = ContactStage.where(account_id: @current_user.account_id, id: @contact_id).first
    name_contact_stage =  stage.stage || stage.sub_stage
    url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

    if (params[:delete_contact_stage].present?)
      move_status_email_deleted = MoveStatusEmailAlert.where(move_record_id: params[:move_id],
                                                             account_id: @current_user.account_id,
                                                             contact_stage_id: @contact_id)
      unless move_status_email_deleted.blank?
        MoveStatusEmailAlert.destroy(move_status_email_deleted.map { |v| v.id })
        @message = MessagesMoveRecord.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subject = 'Disable Contact Stage ' + name_contact_stage.to_s
        @message.body = 'Disable Contact Stage ' + name_contact_stage.to_s
        @message.move_record_id = params[:move_id]
        @message.save
        @log_messages << @message
      end

    elsif (params[:email_alert_id].present?)
      @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(account_id: @current_user.account_id,
                                                                      move_record_id: params[:move_id],
                                                                      email_alert_id: params[:email_alert_id])
      @move_status_email.user_id = @current_user.id
      @move_status_email.save

      #if @contact_id.to_i != ContactStages::STAGES[:book].to_i

        MoverecordMail.stage_mail_sender(params[:move_id], params[:email_alert_id], name_contact_stage.gsub('_', ' ').capitalize, @current_user.id, params[:template_email], url, "").deliver_later

        email = EmailAlert.find_by_id(params[:email_alert_id])

        @message = MessagesMoveRecord.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subject = email.description.to_s + " Email"
        @message.body = "" #params[:template_email]
        @message.move_record_id = params[:move_id]
        @message.message_type = 'email'
        @message.save

        @log_messages << @message

      #end

    else
      ### remove truck refferences in case of cancel
      if name_contact_stage == "Cancel"
        move_trucks = MoveRecordTruck.where(move_record_id: params[:move_id], account_id: @current_user.account_id)
        if move_trucks
          move_trucks.each do |truck|
            truck.update(truck_id: nil)
          end
        end
      end
      ###

      if name_contact_stage != "Book"
        @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: params[:move_id],
                                                                        account_id: @current_user.account_id,
                                                                        contact_stage_id: @contact_id)
        @move_status_email.user_id = @current_user.id
        @move_status_email.save

        @message = MessagesMoveRecord.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subject = 'Contact Stage ' + name_contact_stage.to_s
        @message.body = 'Contact Stage ' + name_contact_stage.to_s
        @message.move_record_id = params[:move_id]
        @message.save

        @log_messages << @message

        move = MoveRecord.find(params[:move_id])
        ra_email = move.referral2.blank? ? move.move_referral_id : move.referral2

        # auto emails
        disabled_stage_emails = []
        disabled_stage_emails = params[:disabled_stage_emails].split(",") if params[:disabled_stage_emails]
        list_email_contact_stage = ContactStage.find_by(account_id: @current_user.account_id, id: @contact_id)
        list_email_contact_stage.email_alerts.each do |stage|

          if (stage.auto_send and not disabled_stage_emails.include?(stage.id.to_s))
            if stage.description == "Referral Posting"
              if move.move_source_id == "Referrals" and not ra_email.blank?
                @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: params[:move_id], account_id: @current_user.account_id, email_alert_id: stage.id)
                @move_status_email.user_id = @current_user.id
                @move_status_email.save

                MoverecordMail.stage_mail_sender(params[:move_id], stage.id, name_contact_stage.gsub('_', ' ').capitalize, @current_user.id, stage.template, url, "").deliver_later

                @message = MessagesMoveRecord.new
                @message.account_id = @current_user.account_id
                @message.user_id = @current_user.id
                @message.subject = stage.description.to_s + " Email"
                @message.body = "" #stage.template
                @message.move_record_id = params[:move_id]
                @message.message_type = 'email'
                @message.save

                @log_messages << @message
              end
            elsif stage.description == "Receive 2"
              # schedule recieve2 before 2 days of move
              move_date = MoveRecordDate.find_by(move_record_id: params[:move_id], account_id: @current_user.account_id).move_date
              if ((move_date - Time.now).to_i / 86400) > 4
                date_send = move_date - 2.days
                date_send = ((date_send - Time.now).to_i / 86400) <= 0 ? 1.minute.from_now : date_send
                MoveRecordRecieve2SchedulerJob.set(wait_until: date_send).perform_later(params[:move_id], url, @current_user.account_id, @current_user.id)
              end
            else
              # rest of emails
              @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: params[:move_id], account_id: @current_user.account_id, email_alert_id: stage.id)
              @move_status_email.user_id = @current_user.id
              @move_status_email.save

              MoverecordMail.stage_mail_sender(params[:move_id], stage.id, name_contact_stage.gsub('_', ' ').capitalize, @current_user.id, stage.template, url, "").deliver_later

              @message = MessagesMoveRecord.new
              @message.account_id = @current_user.account_id
              @message.user_id = @current_user.id
              @message.subject = stage.description.to_s + " Email"
              @message.body = "" #stage.template
              @message.move_record_id = params[:move_id]
              @message.message_type = 'email'
              @message.save

              @log_messages << @message
            end

          end
        end

      end

      # replicate move to old system
      if name_contact_stage == "Complete"
        ReplicateToOpJob.perform_later(params[:move_id], @current_user.account_id, url)
      end

    end

    @current_stage = MoveStatusEmailAlert.where(move_record_id: params[:move_id], account_id: @current_user.account_id).where.not(contact_stage_id: nil).last
    last_stage = ContactStage.where(account_id: @current_user.account_id, id: @current_stage.contact_stage_id).first
    @current_stage_name = last_stage.stage || last_stage.sub_stage

    respond_to do |format|
      format.json { render json: {log_messages: @log_messages, name: @current_user.name, current_stage: @current_stage.contact_stage_id, current_stage_name: @current_stage_name, current_stage_num: last_stage.stage_num} }
    end

    else
      respond_to do |format|
        format.json { render json: {status: 'No Permissions'}, status: :unprocessable_entity }
      end
    end

  end

  def get_subsource_by_source
    source = MoveSource.where(account_id: @current_user.account_id, description: params[:source]).first
    sub_sources = []

    if source
      sub_source = MoveSubsource.where(account_id: @current_user.account_id, active: true, move_source_id: source.id)
      sub_source.each do |sub|
        default = true if @settings.move_subsource_id == sub.id
        sub_sources << {id: sub.id, description: sub.description, default: default}
      end
    end

    render json: sub_sources
  end

  def update_commission(commission_param, model, move_record, stage)
    if !commission_param[:user_id].blank?
      commission = model.find_or_initialize_by(account_id: @current_user.account_id, move_record_id: move_record.id)
      commission.update(commission_param)
      commission.account_id = @current_user.account_id
      commission.save
      commission_stage = MoveStatusEmailAlert.find_or_initialize_by(account_id: @current_user.account_id, move_record_id: move_record.id, contact_stage_id: stage)
      commission_stage.user_id = commission.user_id
      commission_stage.save
    end
  end

  def update_contact_stage(move_record, stage, commission_param)
    if !commission_param[:user_id].blank?
      commission_stage = MoveStatusEmailAlert.find_or_initialize_by(account_id: @current_user.account_id, move_record_id: move_record.id, contact_stage_id: stage)
      commission_stage.update(commission_param)
      commission_stage.save
    end
  end

  def validate_move_status(information, field, model, move_record_id)
    information = information.find { |v| v.contact_stage_id == field }.present? ? information.find { |v| v.contact_stage_id == field } : nil
    commission = nil
    if (!information.blank? && model != false)
      commission = model.find_by(user_id: information.user_id, move_record_id: move_record_id)
      commission = commission == nil ? nil : commission
    end
    return information.blank? ? {user: nil, commission: nil} : {user: information, commission: commission}
  end

  def commission_by_staff
    @commission = (params[:commission_key].camelize + 'Commission').constantize.find_by(account_id: @current_user.account_id, user_id: params[:staff_id], active: true)
    respond_to do |format|
      format.json { render json: @commission }
    end
  end

  def furnishings_information
    furnishing = Furnishing.where(room_id: params[:room])
    respond_to do |format|
      format.json { render json: furnishing.map { |e| {id: e.id, name: e.name} } }
    end
  end

  def cargo_template_information
    cargo_template = CargoTemplate.where(furnishing_id: params[:furnishing]).where("description LIKE ? ", "%#{params[:term]}%")
    respond_to do |format|
      format.json { render json: cargo_template.map { |e| {id: e.id, value: e.description, label: e.description, extra_data: e} } }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_settings
    @settings = MoveRecordDefaultSettings.find_by(account_id: @current_user.account_id)
  end

  def move_record_params
    params[:move_record].permit!.to_h
  end

  def client_params
    if params.has_key?(:cost_hourly)
      params[:clients].permit!.to_h
    end
  end

  def move_record_origin_params
    params[:move_record_origin].permit!.to_h
  end

  def move_record_destination_params
    params[:move_record_destination].permit!.to_h
  end

  def move_record_date_params
    params[:move_record_date].permit!.to_h
  end

  def move_record_truck_params
    if params.has_key?(:move_record_truck)
      params[:move_record_truck].permit!.to_h
    end
  end

  def move_record_cost_hourly_params
    if params.has_key?(:cost_hourly)
      params[:cost_hourly].permit!.to_h
    end
  end

  def move_record_packing_params
    if params.has_key?(:packing)
      params[:packing].permit!.to_h
    end
  end

  def move_record_other_cost_params
    if params.has_key?(:other_cost)
      params[:other_cost].permit!.to_h
    end
  end

  def move_record_surchage_params
    if params.has_key?(:surcharge)
      params[:surcharge].permit!.to_h
    end
  end

  def move_record_flat_rate_params
    if params.has_key?(:flat_rate)
      params[:flat_rate].permit!.to_h
    end
  end

  def move_record_discount_params
    if params.has_key?(:discount)
      params[:discount].permit!.to_h
    end
  end

  def move_record_insurance_params
    if params.has_key?(:insurance)
      params[:insurance].permit!.to_h
    end
  end

  def move_record_fuel_cost_params
    if params.has_key?(:fuel_cost)
      params[:fuel_cost].permit!.to_h
    end
  end

  def move_record_payment_params
    if params.has_key?(:payment)
      params[:payment].permit!.to_h
    end
  end

  def move_record_contact_stage_params
    params[:contact_stage].permit!.to_h
  end

  def move_record_commission_lead_params
    if params.has_key?(:lead)
      params[:lead].permit!.to_h
    end
  end

  def move_record_commission_quote_params
    if params.has_key?(:quote)
      params[:quote].permit!.to_h
    end
  end

  def move_record_commission_book_params
    if params.has_key?(:book)
      params[:book].permit!.to_h
    end
  end

  def move_record_commission_dispatch_params
    if params.has_key?(:dispatch)
      params[:dispatch].permit!.to_h
    end
  end

  def move_record_commission_confirm_params
    if params.has_key?(:dispatch)
      params[:dispatch].permit!.to_h
    end
  end

  def move_record_commission_invoice_params
    if params.has_key?(:invoice)
      params[:invoice].permit!.to_h
    end
  end

  def move_record_commission_post_params
    if params.has_key?(:post)
      params[:post].permit!.to_h
    end
  end

  def move_record_commission_aftercare_params
    if params.has_key?(:aftercare)
      params[:aftercare].permit!.to_h
    end
  end

  def move_record_commission_follow_up_params
    if params.has_key?(:follow_up)
      params[:follow_up].permit!.to_h
    end
  end

  def move_record_commission_receive_params
    if params.has_key?(:receive)
      params[:receive].permit!.to_h
    end
  end

  def move_record_commission_active_params
    if params.has_key?(:active)
      params[:active].permit!.to_h
    end
  end

  def move_record_commission_complete_params
    if params.has_key?(:complete)
      params[:complete].permit!.to_h
    end
  end

  def move_record_commission_unable_params
    if params.has_key?(:unable)
      params[:unable].permit!.to_h
    end
  end

  def move_record_commission_cancel_params
    if params.has_key?(:cancel)
      params[:cancel].permit!.to_h
    end
  end

  def move_record_commission_submit_params
    if params.has_key?(:submit)
      params[:submit].permit!.to_h
    end
  end

  def move_record_company_commission_params
    if params.has_key?(:company)
      params[:company].permit!.to_h
    end
  end

  def move_record_driver_commission_params
    if params.has_key?(:company)
      params[:driver].permit!.to_h
    end
  end

  def move_record_submit_section_params
    if params.has_key?(:submit_section)
      params.require(:submit_section).permit(:signed_acceptance,
                                           :signed_completion,
                                           :release_to,
                                           :purshased_rvp,
                                           :accepted_weight_charges,
                                           :start_time,
                                           :end_time,
                                           :break_time,
                                           :actual_lb,
                                           :min_lb,
                                           :min_lb_dolar,
                                           :min_lb_dolar_client,
                                           :dolar_lb,
                                           :dolar_lb_client,
                                           :rate_actual,
                                           :total_time_actual,
                                           :flat_rate_actual,
                                           :move_cost_actual,
                                           :discount_actual,
                                           :discount_move_cost_actual,
                                           :packing_supplies_actual,
                                           :other_cost_actual,
                                           :surchage_actual,
                                           :rvp_calculated,
                                           :rvp_actual,
                                           :subtotal_actual,
                                           :gst_actual,
                                           :deposit_actual,
                                           :total_actual,
                                           :payment_type_one,
                                           :total_client_one,
                                           :card_number_one,
                                           :expiry_one,
                                           :cvc_one,
                                           :moneris_id_one,
                                           :pre_auth_one,
                                           :payment_date_one,
                                           :payment_type_two,
                                           :total_client_two,
                                           :card_number_two,
                                           :expiry_two,
                                           :cvc_two,
                                           :moneris_id_two,
                                           :pre_auth_two,
                                           :payment_date_two,
                                           :client_received,
                                           :company_received,
                                           :receive_all_cash,
                                           :signed_credit_card,
                                           :origin_access_comment,
                                           :destination_access_comment)
    end
  end

end
