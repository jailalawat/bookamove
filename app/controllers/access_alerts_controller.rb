class AccessAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_access_alert, only: [:edit, :update, :destroy]

  def index
    @access_alerts = AccessAlert.where(account_id: @current_user.account_id)
  end

  def new
    @access_alert = AccessAlert.new
  end

  def create
    @access_alert = AccessAlert.new(access_alert_params)
    @access_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @access_alert.save
        format.html { redirect_to access_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @access_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @access_alert.update(access_alert_params)
        format.html { redirect_to access_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @access_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @access_alert.destroy
    respond_to do |format|
      format.html { redirect_to access_alerts_url, notice: 'Move Access alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_access_alert
    @access_alert = AccessAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def access_alert_params
    params.require(:access_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end
