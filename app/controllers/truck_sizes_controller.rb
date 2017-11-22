class TruckSizesController < ApplicationController
  before_filter :current_user
  before_action :set_truck_size, only: [:edit, :update, :destroy]

  def index
    @truck_sizes = TruckSize.where(account_id: @current_user.account_id)
  end

  def new
    @truck_size = TruckSize.new
  end

  def create
    @truck_size = TruckSize.new(truck_size_params)
    @truck_size.account_id = @current_user.account_id
    respond_to do |format|
      if @truck_size.save
        format.html { redirect_to truck_sizes_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @truck_size.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @truck_size.update(truck_size_params)
        format.html { redirect_to truck_sizes_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @truck_size.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @truck_size.destroy
    respond_to do |format|
      format.html { redirect_to truck_sizes_url, notice: 'Truck size was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_truck_size
    @truck_size = TruckSize.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def truck_size_params
    params.require(:truck_size).permit(
        :description,
        :active,
        :account_id
    )
  end
end
