class EquipmentAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_equipment_alert, only: [:edit, :update, :destroy]

  def index
    @equipment_alerts = EquipmentAlert.where(account_id: @current_user.account_id)
  end

  def new
    @equipment_alert = EquipmentAlert.new
  end

  def create
    @equipment_alert = EquipmentAlert.new(equipment_alert_params)
    @equipment_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @equipment_alert.save
        format.html { redirect_to equipment_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @equipment_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @equipment_alert.update(equipment_alert_params)
        format.html { redirect_to equipment_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @equipment_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @equipment_alert.destroy
    respond_to do |format|
      format.html { redirect_to equipment_alerts_url, notice: 'Move Equipment alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_equipment_alert
    @equipment_alert = EquipmentAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def equipment_alert_params
    params.require(:equipment_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end
