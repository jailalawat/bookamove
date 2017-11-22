class CitiesController < ApplicationController
  before_filter :current_user
  before_action :set_city, only: [:edit, :update, :destroy]

  def index
    @cities = City.where(account_id: @current_user.account_id)
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(city_params)
    @city.account_id = @current_user.account_id
    respond_to do |format|
      if @city.save
        format.html { redirect_to cities_url }
        format.json { render json: @city } #render :index }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to cities_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_city_by_province
    cities = City.select(:id, :description).where(province_id: params[:province_id])
    respond_to do |format|
      format.json { render json: cities }
    end
  end

  def get_city_by_province_and_truck_group
    truck_group = CalendarTruckGroup.find_by(id: params[:calendar_truck_group_id])
    truck_city_id = truck_group.city_id if truck_group
    cities = City.select(:id, :description).where(province_id: params[:province_id])
    respond_to do |format|
      format.json { render json: {cities: cities, truck_city_id: truck_city_id} }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_city
    @city = City.find_by_id_and_account_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def city_params
    params.require(:city).permit(
        :description,
        :active,
        :account_id,
        :tax_id
    )
  end
end
