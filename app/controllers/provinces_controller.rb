class ProvincesController < ApplicationController
  before_filter :current_user

  def get_province_by_truck_group
    truck_group = CalendarTruckGroup.find(params[:calendar_truck_group_id])
    truck_province_id = truck_group.province_id if truck_group
    provinces = Province.select(:id, :description).order(description: :asc)
    respond_to do |format|
      format.json { render json: {provinces: provinces, truck_province_id: truck_province_id} }
    end

  end
end