class TimeAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_time_alert, only: [:edit, :update, :destroy]

  def index
    @time_alerts = TimeAlert.where(account_id: @current_user.account_id)
  end

  def new
    @time_alert = TimeAlert.new
  end

  def create
    @time_alert = TimeAlert.new(time_alert_params)
    @time_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @time_alert.save
        format.html { redirect_to time_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @time_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @time_alert.update(time_alert_params)
        format.html { redirect_to time_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @time_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @time_alert.destroy
    respond_to do |format|
      format.html { redirect_to time_alerts_url, notice: 'Move Time alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_alert
    @time_alert = TimeAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_alert_params
    params.require(:time_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end
