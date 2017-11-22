class MoveSourceAlertsController < ApplicationController
  before_filter :current_user
  before_action :set_move_source_alert, only: [:edit, :update, :destroy]

  def index
    @move_source_alerts = MoveSourceAlert.where(account_id: @current_user.account_id)
  end

  def new
    @move_source_alert = MoveSourceAlert.new
  end

  def create
    @move_source_alert = MoveSourceAlert.new(move_source_alert_params)
    @move_source_alert.account_id = @current_user.account_id
    respond_to do |format|
      if @move_source_alert.save
        format.html { redirect_to move_source_alerts_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_source_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_source_alert.update(move_source_alert_params)
        format.html { redirect_to move_source_alerts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_source_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_source_alert.destroy
    respond_to do |format|
      format.html { redirect_to move_source_alerts_url, notice: 'Move Type alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_source_alert
    @move_source_alert = MoveSourceAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_source_alert_params
    params.require(:move_source_alert).permit(
        :description,
        :active,
        :account_id
    )
  end
end
