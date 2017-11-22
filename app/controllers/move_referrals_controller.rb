class MoveReferralsController < ApplicationController
  before_filter :current_user
  before_action :set_move_referral, only: [:edit, :update, :destroy]

  def index
    @move_referrals = MoveReferral.where(account_id: @current_user.account_id)
  end

  def new
    @move_referral = MoveReferral.new
  end

  def create
    @move_referral = MoveReferral.new(move_referral_params)
    @move_referral.account_id = @current_user.account_id
    respond_to do |format|
      if @move_referral.save
        format.html { redirect_to move_referrals_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_referral.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_referral.update(move_referral_params)
        format.html { redirect_to move_referrals_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_referral.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_referral.destroy
    respond_to do |format|
      format.html { redirect_to move_referrals_url, notice: 'Move Referral was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_referral
    @move_referral = MoveReferral.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_referral_params
    params.require(:move_referral).permit(
        :description,
        :active,
        :account_id
    )
  end
end
