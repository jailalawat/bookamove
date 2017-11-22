class MoveRecordContractSettingsController < ApplicationController
  before_filter :current_user
  before_action :set_settings, only: [:index, :edit, :update, :destroy]

  def index
    validate_permissions("configure.contract") ? '' : return
    @clients = []
    @trucks = []
    @origins = []
    @destinations = []
    @dates = []
    @enable_icon = 'fa fa-check-circle icon-green disable'
    @disable_icon = 'fa fa-times icon-red enable'
    @move_type = MoveType.new
    @location = Location.new
    @move_record = MoveRecord.new
    @move_type_data = MoveType.where(account_id: @current_user.account_id, active: 1)
    @truck_data = Truck.where(account_id: @current_user.account_id, active: 1)
    @move_type_alert = MoveTypeAlert.where(account_id: @current_user.account_id, active: 1)
    @equipment_alert = EquipmentAlert.where(account_id: @current_user.account_id, active: 1)
    @payment_alert = PaymentAlert.where(account_id: @current_user.account_id, active: 1)
    @packing_alert = PackingAlert.where(account_id: @current_user.account_id, active: 1)
    @time_alert = TimeAlert.where(account_id: @current_user.account_id, active: 1)
    @move_source = MoveSource.where(account_id: @current_user.account_id, active: 1)
    @move_subsource = MoveSubsource.where(account_id: @current_user.account_id, active: 1)
    @move_keyword = MoveKeyword.where(account_id: @current_user.account_id, active: 1)
    @move_webpage = MoveWebpage.where(account_id: @current_user.account_id, active: 1)
    @move_referral = MoveReferral.where(account_id: @current_user.account_id, active: 1)
    @move_alert = MoveSourceAlert.where(account_id: @current_user.account_id, active: 1)
    @cargo_type = CargoType.where(account_id: @current_user.account_id, active: 1)
    @cargo_alert = CargoAlert.where(account_id: @current_user.account_id, active: 1)
    @access_alert = AccessAlert.where(account_id: @current_user.account_id, active: 1)
    @contract_stage_alert = MoveStageAlert.where(account_id: @current_user.account_id, active: 1)
    @settings.number_of_clients.times { @clients.push(Client.new) }
    @settings.number_of_trucks.times { @trucks.push(Truck.new) }
    @settings.number_of_origin.times { @origins.push(Location.new) }
    @settings.number_of_destination.times { @destinations.push(Location.new) }
    @settings.number_of_date.times { @dates.push(MoveRecordDate.new) }

    @contact_stage1 = ContactStage.where(account_id: @current_user.account_id, stage_num: 0, sub_stage_num: nil).first
    @contact_stage1_sub_stages = ContactStage.where(account_id: @current_user.account_id, stage_num: 0, stage: nil).order(:position)

    @contact_stage2 = ContactStage.where(account_id: @current_user.account_id, stage_num: 1, sub_stage_num: nil).first
    @contact_stage2_sub_stages = ContactStage.where(account_id: @current_user.account_id, stage_num: 1, stage: nil).order(:position)

    @contact_stage3 = ContactStage.where(account_id: @current_user.account_id, stage_num: 2, sub_stage_num: nil).first
    @contact_stage3_sub_stages = ContactStage.where(account_id: @current_user.account_id, stage_num: 2, stage: nil).order(:position)

    @emails = EmailAlert.all

  end

  def update
    validate_permissions("configure.contract") ? '' : return
    parameters = @settings.attributes.keys
    parameters.each do |parameter|
      if params[parameter]
        if parameter.match(/_id$/)
          @settings[parameter] = params[parameter]
        else
          @settings[parameter] += params[parameter].to_i if !params[parameter].match(/^-?\d+$/).nil?
          @settings[parameter] = params[parameter] if ['true', 'false'].include? params[parameter]
        end
      end
    end
    if @settings.save
      render json: @settings
    else
      render json: @settings.errors, status: :unprocessable_entity
    end
  end

  def classes_list
    classes_list = [
        "move_types" => "MoveType",
        "move_type_alerts" => "MoveTypeAlert",
        "move_sources" => "MoveSource",
        "move_subsources" => "MoveSubsource",
        "move_keywords" => "MoveKeyword",
        "move_webpages" => "MoveWebpage",
        "move_referrals" => "MoveReferral",
        "move_source_alerts" => "MoveSourceAlert",
        "cargo_types" => "CargoType",
        "cargo_alerts" => "CargoAlert",
        "origin_access_alerts" => "AccessAlert",
        "destination_access_alerts" => "AccessAlert",
        "time_alerts" => "TimeAlert",
        "equipment_alerts" => "EquipmentAlert",
        "packing_alerts" => "PackingAlert",
        "payment_alerts" => "PaymentAlert",
        "move_stage_alerts" => "MoveStageAlert",
        "calendar_truck_groups" => "CalendarTruckGroup"
    ]
  end

  def data_edit_dropdown
    validate_permissions("configure.contract") ? '' : return
    if params[:edit_key] != "move_subsources"
      temp_class = classes_list[0][params[:edit_key].to_s].constantize.where(account_id: @current_user.account_id)
    else
      if params[:source_id].present?
        source_id = MoveSource.where(account_id: @current_user.account_id, id: params[:source_id]).first
      else
        source_id = MoveSource.where(account_id: @current_user.account_id).first
      end

      temp_class = MoveSubsource.where(account_id: @current_user.account_id, move_source_id: source_id.id)
    end

    render json: temp_class
  end

  def new_data_dropdown
    validate_permissions("edit.contract_field_default_values") ? '' : return
    temp_class = classes_list[0][params[:edit_key].to_s].constantize.new
    temp_class.account_id = @current_user.account_id
    temp_class.description = params[:new_value]
    temp_class.move_source_id = params[:source_id] if params[:source_id].present?
    temp_class.save

    render json: temp_class
  end

  def update_data_dropdown
    validate_permissions("edit.contract_field_default_values") ? '' : return
    temp_class = classes_list[0][params[:edit_key].to_s].constantize.find(params[:data_dropdown_id])
    temp_class.active = params[:new_value]
    temp_class.save

    render json: temp_class
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_settings
    @settings = MoveRecordDefaultSettings.find_by(account_id: @current_user.account_id)
  end
end
