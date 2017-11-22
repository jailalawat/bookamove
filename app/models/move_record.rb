class MoveRecord < ActiveRecord::Base
  has_many :move_record_client, :dependent => :delete_all
  has_many :move_record_cargo, :dependent => :delete_all
  has_many :move_record_date, :dependent => :delete_all
  has_many :move_record_location_origin, :dependent => :delete_all
  has_many :move_record_location_destination, :dependent => :delete_all

  has_one :move_record_truck, :dependent => :delete
  has_one :move_record_cost_hourly, :dependent => :delete
  has_one :move_record_flat_rate, :dependent => :delete
  has_one :move_record_payment, :dependent => :delete
  has_one :move_record_discount, :dependent => :delete
  has_one :move_record_packing, :dependent => :delete
  has_one :move_record_other_cost, :dependent => :delete
  has_one :move_record_surcharge, :dependent => :delete

  has_many :book_commission_move_record, :dependent => :delete_all
  has_many :confirm_commission_move_record, :dependent => :delete_all
  has_many :company_commission_move_record, :dependent => :delete_all
  has_many :dispatch_commission_move_record, :dependent => :delete_all
  has_many :driver_commission_move_record, :dependent => :delete_all
  has_many :lead_commission_move_record, :dependent => :delete_all
  has_many :messages_move_record, :dependent => :delete_all
  has_many :move_record_fuel_cost, :dependent => :delete_all
  has_many :move_record_insurance, :dependent => :delete_all
  has_many :move_record_submit, :dependent => :delete_all
  has_many :move_status_email_alert, :dependent => :delete_all
  has_many :post_commission_move_record, :dependent => :delete_all
  has_many :quote_commission_move_record, :dependent => :delete_all

  belongs_to :move_referral
  belongs_to :account
  belongs_to :cargo_type

  before_create :generate_token, unless: :token?
  before_create :generate_driver_token, unless: :driver_token?

  def self.create_move_record(move_record_params, client_params, move_record_origin_params, move_record_destination_params, move_record_date_params, move_record_truck_params, move_record_cost_hourly_params, move_record_packing_params, move_record_other_cost_params, move_record_surchage_params, move_record_flat_rate_params, move_record_discount_params, move_record_insurance_params, move_record_fuel_cost_params, move_record_payment_params, move_record_contact_stage_params, move_record_calc_cargo_params, url, current_user, generate_random_password)
    ActiveRecord::Base.transaction do

      move_record = MoveRecord.new(move_record_params)
      move_record.account_id = current_user.account_id
      move_record.user_id = current_user.id
      move_record.save

      client_params["0"]["name"] = "N/A" if client_params["0"]["name"].blank?
      client_params["0"]["email"] = "N/A" if client_params["0"]["email"].blank?

      create_move_record_cargo_calc(move_record, move_record_calc_cargo_params, current_user)

      create_move_record_client(move_record, client_params, url, generate_random_password, current_user)

      create_move_record_origin(move_record, move_record_origin_params, current_user)

      create_move_record_destination(move_record, move_record_destination_params, current_user)

      create_move_record_date(move_record, move_record_date_params, current_user)

      create_move_record_truck(move_record, move_record_truck_params, current_user)

      create_move_record_cost_hourly(move_record, move_record_cost_hourly_params, current_user)

      create_move_record_packing(move_record, move_record_packing_params, current_user)

      create_move_record_other_cost(move_record, move_record_other_cost_params, current_user)

      create_move_record_surchage(move_record, move_record_surchage_params, current_user)

      create_move_record_flat_rate(move_record, move_record_flat_rate_params, current_user)

      create_move_record_discount(move_record, move_record_discount_params, current_user)

      create_move_record_insurance(move_record, move_record_insurance_params, current_user)

      create_move_record_fuel_cost(move_record, move_record_fuel_cost_params, current_user)

      create_move_record_payment(move_record, move_record_payment_params, current_user)

      create_move_record_contact_stages(move_record, move_record_contact_stage_params, move_record_params, move_record_cost_hourly_params, move_record_packing_params, move_record_insurance_params, move_record_other_cost_params, current_user, url)

      move_record.move_contract_number = move_record.id
      move_record.move_contract_name = contract_name_format(move_record.move_record_client.first.client.name, move_record.move_record_date.first.move_date, move_record.move_record_location_origin.first.location.calendar_truck_group_id.blank? ? "" : move_record.move_record_location_origin.first.location.calendar_truck_group.name, move_record.id)
      move_record.save
      move_record
    end

  end

  def self.create_move_record_external(move_record_params, url, account, generate_random_password)
    ActiveRecord::Base.transaction do
      move_record_params[:email] = "N/A" if move_record_params[:email].blank?

      account = OpenStruct.new({:account_id => account.id, :id => account.id})
      comment = move_record_params[:best_time_to_call_back].blank? ? move_record_params[:comments] : move_record_params[:comments] + "\nBest time to call back: " + move_record_params[:best_time_to_call_back]
      source = nil #check_move_source(move_record_params[:source_page], account.id)
      referral = nil #check_move_referral(move_record_params[:referrer], account.id)
      move_record = create_empty_external_move_record(comment, source, referral, account.id)
      check_client_move_record(move_record_params[:email], move_record_params[:name], move_record_params[:work_phone], generate_random_password, move_record.id, account.id)
      create_location_external_move_record(move_record_params[:city], move_record.id, account.id)
      create_move_record_cost_hourly(move_record, {}, account)
      create_move_record_packing(move_record, {}, account)
      create_move_record_other_cost(move_record, {}, account)
      create_move_record_surchage(move_record, {}, account)
      create_move_record_payment(move_record, {}, account)
      create_move_record_date(move_record, [{}], account)
      create_move_record_truck(move_record, [{}], account)
      create_move_record_flat_rate(move_record, {}, account)
      create_move_record_discount(move_record, {}, account)
      create_move_record_insurance(move_record, {}, account)
      create_move_record_fuel_cost(move_record, {}, account)

      move_record.move_contract_number = move_record.id
      move_record.old_system_id = move_record_params[:old_system_id]
      move_record.total_cost = move_record_params[:move_cost]
      move_record.move_contract_name = contract_name_format(move_record.move_record_client.first.client.name, move_record.move_record_date.first.move_date, move_record.move_record_location_origin.first.location.calendar_truck_group_id.blank? ? "" : move_record.move_record_location_origin.first.location.calendar_truck_group.name, move_record.id)
      move_record.save

      ## create lead stage
      contact_id = ContactStage.where(account_id: account.id, stage: "Lead").pluck(:id).first
      stage_name = "Lead"

      move_status_email = MoveStatusEmailAlert.new
      move_status_email.move_record_id = move_record.id
      move_status_email.account_id = account.id
      move_status_email.contact_stage_id = contact_id
      #move_status_email.user_id = current_user.id
      move_status_email.save

      message = MessagesMoveRecord.new
      message.account_id = account.id
      #message.user_id = current_user.id
      message.subject = 'Contact Stage ' + stage_name
      message.body = 'Contact Stage ' + stage_name
      message.move_record_id = move_record.id
      message.save

      move_record
    end
  end

  def self.create_empty_external_move_record(comment, source, referral, account_id)
    move_record = MoveRecord.new
    move_record.contract_note = comment
    #move_record.move_source_id = source.id
    #move_record.move_referral_id = referral.id
    move_record.account_id = account_id
    move_record.external_request = true
    move_record.save
    move_record
  end

  def self.check_move_source(source_page, account_id)
    source = MoveSource.find_by_description(source_page)
    if source.blank?
      new_source = MoveSource.new
      new_source.description = source_page
      new_source.account_id = account_id
      new_source.save
      source = new_source
    end
    source
  end

  def self.check_move_referral(referrer, account_id)
    referral = MoveReferral.find_by_description(referrer)
    if referral.blank?
      new_referral = MoveReferral.new
      new_referral.description = referrer
      new_referral.account_id = account_id
      new_referral.save
      referral = new_referral
    end
    referral
  end

  def self.check_client_move_record(email, name, work_phone, generate_random_password, move_id, account_id)
    if not email.blank? and work_phone == "000-000-0000"
      user = User.find_by(email: email, account_id: account_id)
    elsif not work_phone == "000-000-0000" and email.blank?
      user = User.find_by(work_phone: work_phone, account_id: account_id)
    elsif not email.blank? and not work_phone == "000-000-0000"
      user = User.find_by(email: email, work_phone: work_phone, account_id: account_id)
    end

    unless user.blank?
      client = Client.find_by_user_id(user.id)
    else
      client = Client.store({email: email,
                             name: name,
                             work_phone: work_phone},
                            generate_random_password,
                            account_id)
    end

    if (client.present?)
      @move_record_client = MoveRecordClient.new
      @move_record_client.move_record_id = move_id
      @move_record_client.client_id = client.id
      @move_record_client.account_id = account_id
      @move_record_client.save
    end
  end

  def self.create_location_external_move_record(city, move_id, account_id)
    location = Location.new
    location.city = city
    location.account_id = account_id
    location.save

    move_record_client = MoveRecordLocationOrigin.new
    move_record_client.move_record_id = move_id
    move_record_client.location_id = location.id
    move_record_client.account_id = account_id
    move_record_client.save

    move_record_client = MoveRecordLocationDestination.new
    move_record_client.move_record_id = move_id
    move_record_client.location_id = location.id
    move_record_client.account_id = account_id
    move_record_client.save
  end

  def self.create_move_record_cargo_calc(move_record, move_record_calc_cargo_params, current_user)
    move_record_calc_cargo_params.each do |calc_cargo|
      if !calc_cargo[1]["description"].blank? && calc_cargo[1]["quantity"].to_f > 0
        @temp_calc_cargo = MoveRecordCargo.new
        @temp_calc_cargo.description = calc_cargo[1]["description"]
        @temp_calc_cargo.quantity = calc_cargo[1]["quantity"]
        @temp_calc_cargo.unit_volume = calc_cargo[1]["volume"]
        @temp_calc_cargo.unit_weight = calc_cargo[1]["weight"]
        @temp_calc_cargo.move_record_id = move_record.id
        @temp_calc_cargo.account_id = current_user.account_id
        @temp_calc_cargo.save
      end

    end
  end

  def self.create_move_record_client(move_record, client_params, url, generate_random_password, current_user)
    @move_clients = []
    #save clients array
    client_params.each do |parameter|
      next if parameter[1]['email'].blank?
      user = parameter[1]['email'].match(/([Nn]\/[Aa])+/) ? [] : User.find_by(email: parameter[1]['email'], account_id: current_user.account_id)
      unless user.blank?
        @client = Client.find_by_user_id(user.id)
        if @client.nil?
          @client = Client.store_only_client(parameter[1], user)
        end
      else
        @client = Client.store(parameter[1], generate_random_password, current_user.account_id)
      end
      @move_clients.push(@client)
    end
=begin
		default_client = MoveRecordDefaultSettings.find_by(account_id: current_user.account_id)
		(default_client.number_of_clients - 1).times do
			temp_client = Client.new
			temp_client.account_id = current_user.account_id
			temp_client.email = "N/A"
			temp_client.name = nil
			puts temp_client.save
			@move_clients.push(temp_client)
		end
=end
    #save relation clients and move record
    @move_clients.each do |client|
      if (client.id.present?)
        @move_record_client = MoveRecordClient.new
        @move_record_client.move_record_id = move_record.id
        @move_record_client.client_id = client.id
        @move_record_client.account_id = current_user.account_id
        @move_record_client.save
      end
    end
  end

  def self.create_move_record_origin(move_record, move_record_origin_params, current_user)
    @move_origins = []

    #save origins array
    move_record_origin_params.each do |parameter|
      @origin = Location.new(parameter[1])
      @origin.account_id = current_user.account_id
      @origin.save
      @move_origins.push(@origin)
    end

    #save relation origin and move record
    @move_origins.each do |origin|
      move_record_client = MoveRecordLocationOrigin.new
      move_record_client.move_record_id = move_record.id
      move_record_client.location_id = origin.id
      move_record_client.account_id = current_user.account_id
      move_record_client.save
    end
  end

  def self.create_move_record_destination(move_record, move_record_destination_params, current_user)
    @move_destinations = []

    #save destinations array
    move_record_destination_params.each do |parameter|
      @destination = Location.new(parameter[1])
      @destination.account_id = current_user.account_id
      @destination.save
      @move_destinations.push(@destination)
    end

    #save relation destination and move record
    @move_destinations.each do |destination|
      @move_record_client = MoveRecordLocationDestination.new
      @move_record_client.move_record_id = move_record.id
      @move_record_client.location_id = destination.id
      @move_record_client.account_id = current_user.account_id
      @move_record_client.save
    end
  end

  def self.create_move_record_date(move_record, move_record_date_params, current_user)
    #save relation date and move record
    move_record_date_params.each do |date|
      @move_record_date = MoveRecordDate.new(date[1])
      @move_record_date.move_record_id = move_record.id
      @move_record_date.account_id = current_user.account_id
      @move_record_date.move_date = DateTime.now if @move_record_date.move_date.nil?
      @move_record_date.save
    end
  end

  def self.create_move_record_truck(move_record, move_record_truck_params, current_user)
    #save relation truck and move record
    move_record_truck_params.each do |truck|
      @move_record_truck = MoveRecordTruck.new(truck[1])
      @move_record_truck.move_record_id = move_record.id
      @move_record_truck.account_id = current_user.account_id
      @move_record_truck.save
    end
  end

  def self.create_move_record_cost_hourly(move_record, move_record_cost_hourly_params, current_user)
    #save relation cost hourly and move record
    @move_record_cost_hourly = MoveRecordCostHourly.new(move_record_cost_hourly_params)
    @move_record_cost_hourly.move_record_id = move_record.id
    @move_record_cost_hourly.account_id = current_user.account_id
    @move_record_cost_hourly.save
  end

  def self.create_move_record_packing(move_record, move_record_packing_params, current_user)
    #save relation packing and move record
    @move_record_packing = MoveRecordPacking.new(move_record_packing_params)
    @move_record_packing.move_record_id = move_record.id
    @move_record_packing.account_id = current_user.account_id
    @move_record_packing.save
  end

  def self.create_move_record_other_cost(move_record, move_record_other_cost_params, current_user)
    #save relation other cost and move record
    @move_record_other_cost = MoveRecordOtherCost.new(move_record_other_cost_params)
    @move_record_other_cost.move_record_id = move_record.id
    @move_record_other_cost.account_id = current_user.account_id
    @move_record_other_cost.save
  end

  def self.create_move_record_surchage(move_record, move_record_surchage_params, current_user)
    #save relation surchage and move record
    @move_record_surchage = MoveRecordSurcharge.new(move_record_surchage_params)
    @move_record_surchage.move_record_id = move_record.id
    @move_record_surchage.account_id = current_user.account_id
    @move_record_surchage.save
  end

  def self.create_move_record_flat_rate(move_record, move_record_flat_rate_params, current_user)
    #save relation flat rate and move record
    @move_record_flat_rate = MoveRecordFlatRate.new(move_record_flat_rate_params)
    @move_record_flat_rate.move_record_id = move_record.id
    @move_record_flat_rate.account_id = current_user.account_id
    @move_record_flat_rate.save
  end

  def self.create_move_record_discount(move_record, move_record_discount_params, current_user)
    #save relation discount and move record
    @move_record_discount = MoveRecordDiscount.new(move_record_discount_params)
    @move_record_discount.move_record_id = move_record.id
    @move_record_discount.account_id = current_user.account_id
    @move_record_discount.save
  end

  def self.create_move_record_insurance(move_record, move_record_insurance_params, current_user)
    #save relation insurance and move record
    @move_record_insurance = MoveRecordInsurance.new(move_record_insurance_params)
    @move_record_insurance.move_record_id = move_record.id
    @move_record_insurance.account_id = current_user.account_id
    @move_record_insurance.save
  end

  def self.create_move_record_fuel_cost(move_record, move_record_fuel_cost_params, current_user)
    #save relation fuel cost and move record
    @move_record_fuel_cost = MoveRecordFuelCost.new(move_record_fuel_cost_params)
    @move_record_fuel_cost.move_record_id = move_record.id
    @move_record_fuel_cost.account_id = current_user.account_id
    @move_record_fuel_cost.save

  end

  def self.create_move_record_payment(move_record, move_record_payment_params, current_user)
    #save relation payment cost and move record
    @move_record_payment = MoveRecordPayment.new(move_record_payment_params)
    @move_record_payment.move_record_id = move_record.id
    @move_record_payment.account_id = current_user.account_id
    @move_record_payment.save
  end

  def self.create_move_record_contact_stages(move_record, move_record_contact_stage_params, move_record_params,
      move_record_cost_hourly_params, move_record_packing_params, move_record_insurance_params,
      move_record_other_cost_params, current_user, url)

    @contact_id = ContactStage.where(account_id: current_user.account_id, stage: "Lead").pluck(:id).first
    @stage_name = "Lead"

    @move_status_email = MoveStatusEmailAlert.new
    @move_status_email.move_record_id = move_record.id
    @move_status_email.account_id = current_user.account_id
    @move_status_email.contact_stage_id = @contact_id
    @move_status_email.user_id = current_user.id
    @move_status_email.save

    @message = MessagesMoveRecord.new
    @message.account_id = current_user.account_id
    @message.user_id = current_user.id
    @message.subject = 'Contact Stage ' + @stage_name
    @message.body = 'Contact Stage ' + @stage_name
    @message.move_record_id = move_record.id
    @message.save

    # auto-emails
    list_email_contact_stage = ContactStage.find_by(account_id: current_user.account_id, id: @contact_id)
    list_email_contact_stage.email_alerts.each do |stage|

      if (stage.auto_send)
        @move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: move_record.id,
                                                                        account_id: current_user.account_id,
                                                                        email_alert_id: stage.id)
        @move_status_email.user_id = current_user.id
        @move_status_email.save

        MoverecordMail.stage_mail_sender(move_record.id, stage.id, @stage_name.gsub('_', ' ').capitalize, current_user.id, stage.template, url, "").deliver_later

        @message = MessagesMoveRecord.new
        @message.account_id = current_user.account_id
        @message.user_id = current_user.id
        @message.subject = stage.description.to_s + " Email"
        @message.body = "" #stage.template
        @message.move_record_id = move_record.id
        @message.message_type = 'email'
        @message.save
      end

    end

    #MoverecordMail.stage_mail_sender(move_record.id, @move_status_email.email_alert_id, @stage_name.gsub('_', ' ').capitalize, current_user.id, nil, url).deliver_later

    add_commissions_move_record(move_record, move_record_params, move_record_cost_hourly_params, move_record_packing_params,
                                move_record_insurance_params, move_record_other_cost_params, @contact_id, current_user)
  end

  def self.add_commissions_move_record(move_record, move_record_params, move_record_cost_hourly_params, move_record_packing_params,
      move_record_insurance_params, move_record_other_cost_params, stage, current_user)
    #model = ContactStages::STAGES.keys[(stage.to_i - 1)].to_s
    ContactStage.where(account_id: current_user.account_id, id: stage.to_i).first
    model = stage.stage || stage.sub_stage

    return unless Object.const_get(model.camelize + 'Commission').is_a?(Class) rescue false
    personal_commission = (model.camelize + 'Commission').constantize.find_by(account_id: current_user.account_id, user_id: current_user.id, active: true)
    commission = (model.camelize + 'CommissionMoveRecord').constantize.find_or_initialize_by(account_id: current_user.account_id, move_record_id: move_record.id)
    if personal_commission != nil
      if move_record_params[:move_type_id] == 2 && personal_commission.active
        commission.move = personal_commission.ld_move
        commission.storage = personal_commission.ld_storage
        commission.packing = personal_commission.ld_packing
        commission.insurance = personal_commission.ld_insurance
        commission.other = personal_commission.ld_other
        commission.blank = personal_commission.ld_blank
      elsif personal_commission.active
        commission.move = personal_commission.move
        commission.storage = personal_commission.storage
        commission.packing = personal_commission.packing
        commission.insurance = personal_commission.insurance
        commission.other = personal_commission.other
        commission.blank = personal_commission.blank
      end
    end
    commission.total_move = (move_record_cost_hourly_params[:move_cost].to_f * (commission.move.to_f / 100)).round(2)
    commission.total_packing = (move_record_packing_params[:total_packing].to_f * (commission.packing.to_f / 100)).round(2)
    commission.total_insurance = (move_record_insurance_params[:insurance_cost].to_f * (commission.insurance.to_f / 100)).round(2)
    commission.total_other = (move_record_other_cost_params[:other_cost].to_f * (commission.other.to_f / 100)).round(2)
    commission.total_commission = commission.total_move + commission.total_storage + commission.total_packing +
        commission.total_insurance + commission.total_other + commission.total_blank
    commission.user_id = current_user.id
    commission.account_id = current_user.account_id
    commission.save

    company_commission = CompanyCommissionMoveRecord.find_or_initialize_by(account_id: current_user.account_id, move_record_id: move_record.id)
    company_commission.total_move = company_commission.total_move.to_f == 0.0 ? move_record_cost_hourly_params[:move_cost].to_f - commission.total_move.round(2) : company_commission.total_move - commission.total_move.round(2)
    company_commission.total_packing = company_commission.total_packing.to_f == 0.0 ? move_record_packing_params[:total_packing].to_f - commission.total_packing.round(2) : company_commission.total_packing - commission.total_packing.round(2)
    company_commission.total_insurance = company_commission.total_insurance.to_f == 0.0 ? move_record_insurance_params[:insurance_cost].to_f - commission.total_insurance.round(2) : company_commission.total_insurance - commission.total_insurance.round(2)
    company_commission.total_other = company_commission.total_other.to_f == 0.0 ? move_record_other_cost_params[:other_cost].to_f - commission.total_other.round(2) : company_commission.total_other - commission.total_other.round(2)
    company_commission.total_company = (company_commission.total_move + company_commission.total_storage + company_commission.total_packing +
        company_commission.total_insurance + company_commission.total_other + company_commission.total_blank).round(2)

    company_commission.total_move_percentage = ((company_commission.total_move / move_record_cost_hourly_params[:move_cost].to_f).to_s.to_f * 100).round(2)
    company_commission.total_packing_percentage = ((company_commission.total_packing / move_record_packing_params[:total_packing].to_f).to_s.to_f * 100).round(2)
    company_commission.total_insurance_percentage = ((company_commission.total_insurance / move_record_insurance_params[:insurance_cost].to_f).to_s.to_f * 100).round(2)
    company_commission.total_other_percentage = ((company_commission.total_other / move_record_other_cost_params[:other_cost].to_f).to_s.to_f * 100).round(2)
    company_commission.total_storage_percentage = 100
    company_commission.total_blank_percentage = 100

    company_commission.total_company_percentage = ((
    company_commission.total_move_percentage +
        company_commission.total_packing_percentage +
        company_commission.total_insurance_percentage +
        company_commission.total_other_percentage +
        company_commission.total_storage_percentage +
        company_commission.total_blank_percentage
    ) / 6).round(2)
    company_commission.save
  rescue NameError
    return false
  end

  def self.list_move_records(params, current_user)
    add_sql = ''
    if (params[:list_move_calendar_start].present? && params[:list_move_calendar_end].present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + params[:list_move_calendar_start] + "' AND '" + params[:list_move_calendar_end] + "' "
    end
    if !params[:search]["value"].blank?
      term = params[:search]["value"]
      add_sql += " AND (c.name like '%" + term + "%' or md.move_date like '%" + term + "%' or md.move_time like '%" + term + "%' )"
    end
    column_to_order = params[:order]["0"]["column"]
    type_to_reorder = params[:order]["0"]["dir"]
    column_reorder = params[:columns][column_to_order]["data"]
    sql_posted = "select distinct  mv.id as move_id, c.name as `name` , md.move_date as `date` , md.move_time as `start_time`,
						( select distinct group_concat( u.name  SEPARATOR ',' ) as movers
						  from users u
						  inner join move_record_trucks mt on  ( u.id = mt.lead or u.id = mt.mover_2 or u.id = mt.mover_3 or u.id = mt.mover_4 or u.id = mt.mover_5 or u.id = mt.mover_6 )
						  where mt.move_record_id = mv.id ) as `movers`,
						mv.total_cost as `total_cost`,
						( select count(*)
						  from move_status_email_alerts msea
						  where mv.id = msea.move_record_id
						  AND msea.contact_stage_id = ? ) as `status_complete`
						from move_records mv
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join users mvu on mvu.id = c.user_id" +
        add_sql +
        " AND mv.account_id = ? AND c.user_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder

    pagination_posted = " LIMIT ? OFFSET ?"


    count_list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted,
                                 ContactStage.where(account_id: current_user.account_id, stage: "Complete").pluck(:id).first,
                                 current_user.account_id,
                                 current_user.id])
    ).count
    list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted,
                                 ContactStage.where(account_id: current_user.account_id, stage: "Complete").pluck(:id).first,
                                 current_user.account_id,
                                 current_user.id,
                                 params[:length].to_i,
                                 params[:start].to_i])
    )
    return {list_move: list_move, count_list_move: count_list_move}
  end

  def self.check_confirmed_move_record(move_record, account_id)
    sql = "select count(mv.id) as total
				from move_records mv
				inner join move_status_email_alerts msea on mv.id = msea.move_record_id
				where mv.id = ? and msea.contact_stage_id = ?"

    count_list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql,
                                 move_record,
                                 ContactStage.where(account_id: account_id, sub_stage: "Confirm").pluck(:id).first])
    )
  end

  def self.check_reconfirmed2_move_record(move_record, account_id)
    sql = "select count(mv.id) as total
				from move_records mv
				inner join move_status_email_alerts msea on mv.id = msea.move_record_id
				where mv.id = ? and msea.contact_stage_id = ?"

    count_list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql,
                                 move_record,
                                 ContactStage.where(account_id: account_id, sub_stage: "Confirm 2").pluck(:id).first])
    )
  end

  def self.check_reconfirmed7_move_record(move_record, account_id)
    sql = "select count(mv.id) as total
				from move_records mv
				inner join move_status_email_alerts msea on mv.id = msea.move_record_id
				where mv.id = ? and msea.contact_stage_id = ?"

    count_list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql,
                                 move_record,
                                 ContactStage.where(account_id: account_id, sub_stage: "Confirm 7").pluck(:id).first])
    )
  end

  def self.clone_move_record(move_id, account_id)
    ActiveRecord::Base.transaction do
      move_record = MoveRecord.find_by_account_id_and_id(account_id, move_id).dup
      move_record.save

      list_clone = ['MoveRecordDate', 'MoveRecordTruck', 'MoveRecordCostHourly', 'MoveRecordPacking',
                    'MoveRecordOtherCost', 'MoveRecordSurcharge', 'MoveRecordFlatRate', 'MoveRecordDiscount', 'MoveRecordInsurance',
                    'MoveRecordFuelCost', 'MoveRecordPayment', 'CompanyCommissionMoveRecord', 'MoveRecordSubmit', 'DriverCommissionMoveRecord',
                    'LeadCommissionMoveRecord', 'QuoteCommissionMoveRecord', 'BookCommissionMoveRecord', 'DispatchCommissionMoveRecord',
                    'ConfirmCommissionMoveRecord', 'InvoiceCommissionMoveRecord', 'PostCommissionMoveRecord', 'AftercareCommissionMoveRecord']

      list_clone.each do |model|
        temp_model = model.constantize.find_by_account_id_and_move_record_id(account_id, move_id)
        if (temp_model.present?)
          temp_model = temp_model.dup
          temp_model.move_record_id = move_record.id
          temp_model.save
        end
      end

      list_multiple_clone = ['MoveRecordClient', 'MoveStatusEmailAlert', 'MoveRecordCargo',
                             'MoveRecordLocationOrigin', 'MoveRecordLocationDestination']

      list_multiple_clone.each do |model|
        temp_model = model.constantize.where(account_id: account_id, move_record_id: move_id)
        temp_model.each do |model_clone|
          temp_model_clone = model_clone.dup
          temp_model_clone.move_record_id = move_record.id
          temp_model_clone.save
        end
      end
      move_record.move_contract_name = contract_name_format(move_record.move_record_client.first.client.name,
                                                            move_record.move_record_date.first.move_date,
                                                            move_record.move_record_location_origin.first.location.calendar_truck_group_id.blank? ? "" : move_record.move_record_location_origin.first.location.calendar_truck_group.name,
                                                            move_record.id)
      move_record.move_contract_number = move_record.id
      move_record.save
    end
  end

  def self.contract_name_format(client, date, group, move_id)
    client = client.split
    client = client[0][0..3].capitalize + (client[1].present? ? client[1][0].capitalize : '')
    date = date.to_date.strftime("%b%d")
    group = group[0..3].capitalize
    return client + ' ' + date + ' ' + group #+ ' ' + move_id.to_s
  end

  def self.expire_booked(account_id, user_id, move_record)
    #MoveStatusEmailAlert.find_or_create_by(account_id: account_id, user_id: user_id, move_record_id: move_record, move_status_id: ContactStages::STAGES[:complete])
    complete_id = ContactStage.where(account_id: account_id, stage: "Complete").pluck(:id).first
    complete_status_exist = MoveStatusEmailAlert.find_by(account_id: account_id, user_id: user_id, move_record_id: move_record, contact_stage_id: complete_id)
    if complete_status_exist
      # complete_status_exist.destroy
      # MoveStatusEmailAlert.create(account_id: account_id, user_id: user_id, move_record_id: move_record, contact_stage_id: complete_id)
    else
      MoveStatusEmailAlert.create(account_id: account_id, user_id: user_id, move_record_id: move_record, contact_stage_id: complete_id)
    end
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def generate_driver_token
    self.driver_token = SecureRandom.urlsafe_base64
  end

  def self.time_difference(time_a, time_b)
    difference = time_b - time_a

    if difference > 0
      difference
    else
      24 * 3600 + difference
    end
  end

end
