class PaymentAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_payment_alert, only: [:edit, :update, :destroy]

  def index
    @payment_alerts = PaymentAlert.where(account_id: @current_user.account_id)
  end

  def new
    @payment_alert = PaymentAlert.new
  end

  def create
    @payment_alert = PaymentAlert.new(payment_alert_params)
    @payment_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @payment_alert.save
        format.html { redirect_to payment_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @payment_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @payment_alert.update(payment_alert_params)
        format.html { redirect_to payment_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @payment_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment_alert.destroy
    respond_to do |format|
      format.html { redirect_to payment_alerts_url, notice: 'Move Payment alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment_alert
    @payment_alert = PaymentAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_alert_params
    params.require(:payment_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end

