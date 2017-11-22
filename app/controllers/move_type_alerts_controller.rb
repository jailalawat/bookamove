class MoveTypeAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_move_type_alert, only: [:edit, :update, :destroy]

  def index
    @move_type_alerts = MoveTypeAlert.where(account_id: @current_user.account_id)
  end

  def new
    @move_type_alert = MoveTypeAlert.new
  end

  def create
    @move_type_alert = MoveTypeAlert.new(move_type_alert_params)
    @move_type_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @move_type_alert.save
        format.html { redirect_to move_type_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_type_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_type_alert.update(move_type_alert_params)
        format.html { redirect_to move_type_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_type_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_type_alert.destroy
    respond_to do |format|
      format.html { redirect_to move_type_alerts_url, notice: 'Move Type alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_type_alert
    @move_type_alert = MoveTypeAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_type_alert_params
    params.require(:move_type_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end
