class LocationsController < ApplicationController
  before_filter :current_user
  before_action :set_location, only: [:edit, :update, :destroy]

  def index
    @locations = Location.where(account_id: @current_user.account_id)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.account_id = @current_user.account_id
    respond_to do |format|
      if @location.save
        format.html { redirect_to locations_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to locations_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(
        :no,
        :street,
        :apartment,
        :entry_number,
        :building,
        :city,
        :locale,
        :province,
        :postal_code,
        :access_details,
        :access_alert,
        :account_id
    )
  end
end
