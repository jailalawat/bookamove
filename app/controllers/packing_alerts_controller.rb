class PackingAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_packing_alert, only: [:edit, :update, :destroy]

  def index
    @packing_alerts = PackingAlert.where(account_id: @current_user.account_id)
  end

  def new
    @packing_alert = PackingAlert.new
  end

  def create
    @packing_alert = PackingAlert.new(packing_alert_params)
    @packing_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @packing_alert.save
        format.html { redirect_to packing_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @packing_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @packing_alert.update(packing_alert_params)
        format.html { redirect_to packing_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @packing_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @packing_alert.destroy
    respond_to do |format|
      format.html { redirect_to packing_alerts_url, notice: 'Move Packing alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_packing_alert
    @packing_alert = PackingAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def packing_alert_params
    params.require(:packing_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end

