class CargoAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_cargo_alert, only: [:edit, :update, :destroy]

  def index
    @cargo_alerts = CargoAlert.where(account_id: @current_user.account_id)
  end

  def new
    @cargo_alert = CargoAlert.new
  end

  def create
    @cargo_alert = CargoAlert.new(cargo_alert_params)
    @cargo_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @cargo_alert.save
        format.html { redirect_to cargo_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @cargo_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @cargo_alert.update(cargo_alert_params)
        format.html { redirect_to cargo_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @cargo_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cargo_alert.destroy
    respond_to do |format|
      format.html { redirect_to cargo_alerts_url, notice: 'Cargo alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cargo_alert
    @cargo_alert = CargoAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cargo_alert_params
    params.require(:cargo_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end

