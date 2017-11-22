class CalendarTruckGroupsController < ApplicationController
  before_filter :current_user
  before_action :set_CalendarTruckGroup, only: [:edit, :update, :destroy]

  def index
    @calendar_truck_groups = CalendarTruckGroup.where(account_id: @current_user.account_id)
  end

  def new
    validate_permissions("create_edit.truck_calendars") ? '' : return
    @calendar_truck_group = CalendarTruckGroup.new
    @calendar_truck_group.trucks = {}
    @trucks = Truck.joins('left join list_truck_groups on trucks.id = list_truck_groups.truck_id').where(account_id: @current_user.account_id, active: 1).where('list_truck_groups.truck_id' => nil)

    @gst = "0.00"
    @pst = "0.00"

    @provinces = Province.order(description: :asc)
    @cities = []
    @current_city = City.new
    @locales = []
    @current_locale = CityLocale.new
  end

  def create
    validate_permissions("create_edit.truck_calendars") ? '' : return
    @calendar_truck_group = CalendarTruckGroup.new(calendar_truck_group_params)
    @calendar_truck_group.account_id = @current_user.account_id
    respond_to do |format|
      if @calendar_truck_group.save
        fill_list_truck()
        taxes = Tax.find_or_create_by(calendar_truck_group_id: @calendar_truck_group.id, account_id: @current_user.account_id)
        taxes.gst = params[:gst]
        taxes.pst = params[:pst]
        taxes.save

        format.html { redirect_to calendar_truck_groups_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @calendar_truck_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    validate_permissions("create_edit.truck_calendars") ? '' : return
    @calendar_truck_group.trucks = ListTruckGroup.where(account_id: @current_user.account_id, calendar_truck_group_id: @calendar_truck_group.id)
    @list_truck_group = []
    @trucks = Truck.joins('left join list_truck_groups on trucks.id = list_truck_groups.truck_id')
                  .where(account_id: @current_user.account_id, active: 1)
                  .where('list_truck_groups.truck_id IS NULL OR trucks.id in (?)', @calendar_truck_group.trucks.map { |v| v.truck_id.to_i })
    @calendar_truck_group.trucks.each do |truck|
      @list_truck_group.push(truck.truck_id)
    end
    tax = @calendar_truck_group.tax
    if tax
      @gst = tax.gst
      @pst = tax.pst
    else
      @gst = "0.00"
      @pst = "0.00"
    end


    @provinces = Province.order(description: :asc)
    @cities = City.where(province_id: @calendar_truck_group.province_id).order(description: :asc)
    @locales = CityLocale.where(city_id: @calendar_truck_group.city_id).order(locale_name: :asc)

    @review_link = ReviewLink.new
  end

  def update
    validate_permissions("create_edit.truck_calendars") ? '' : return
    fill_list_truck()
    respond_to do |format|
      if @calendar_truck_group.update(calendar_truck_group_params)
        taxes = Tax.find_or_create_by(calendar_truck_group_id: @calendar_truck_group.id, account_id: @current_user.account_id)
        taxes.gst = params[:gst]
        taxes.pst = params[:pst]
        taxes.save

        format.html { redirect_to calendar_truck_groups_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @calendar_truck_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    validate_permissions("create_edit.truck_calendars") ? '' : return
    @list_group = ListTruckGroup.find_by_calendar_truck_group_id(@calendar_truck_group.id)
    @list_group.destroy if not @list_group.nil?
    @calendar_truck_group.destroy
    respond_to do |format|
      format.html { redirect_to calendar_truck_groups_url, notice: 'Truck group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def fill_list_truck
    ListTruckGroup.destroy_all(account_id: @current_user.account_id, calendar_truck_group_id: @calendar_truck_group.id)
    calendar_truck_group_params[:trucks].each do |truck|
      if (truck.present?)
        list_truck = ListTruckGroup.new
        list_truck.account_id = @current_user.account_id
        list_truck.truck_id = truck
        list_truck.calendar_truck_group_id = @calendar_truck_group.id
        list_truck.save
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_CalendarTruckGroup
    @calendar_truck_group = CalendarTruckGroup.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def calendar_truck_group_params
    params.require(:calendar_truck_group).permit(:name, :phone_number, :description, :active, :address, :province_id, :city_id, :locale_id, :trucks => [])
  end
end
