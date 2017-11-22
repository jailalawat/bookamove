class CityLocalesController < ApplicationController
  before_filter :current_user

  def index

  end

  def edit

  end

  def create
    @city_locale = CityLocale.new(locale_params)

    respond_to do |format|
      if @city_locale.save
        format.json { render json: @city_locale }
      else
        format.json { render json: @city_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  def get_locale_by_city
    locales = CityLocale.select(:id, :locale_name, :city_id).where(city_id: params[:city_id])
    respond_to do |format|
      format.json { render json: locales }
    end
  end

  def get_locale_by_city_and_truck_group
    truck_group = CalendarTruckGroup.find(params[:calendar_truck_group_id])
    locale_id = truck_group.locale_id if truck_group
    locales = CityLocale.select(:id, :locale_name).where(city_id: params[:city_id])
    respond_to do |format|
      format.json { render json: {locales: locales, locale_id: locale_id} }
    end
  end

  private

  def locale_params
    params.require(:city_locale).permit(:locale_name, :city_id)
  end

end
