class MoveTypesController < ApplicationController
  before_filter :current_user
  before_action :set_move_type, only: [:edit, :update, :destroy]

  def index
    @move_types = MoveType.where(account_id: @current_user.account_id)
  end

  def new
    @move_type = MoveType.new
  end

  def create
    @move_type = MoveType.new(move_type_params)
    @move_type.account_id = @current_user.account_id
    respond_to do |format|
      if @move_type.save
        format.html { redirect_to move_types_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_type.update(move_type_params)
        format.html { redirect_to move_types_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_type.destroy
    respond_to do |format|
      format.html { redirect_to move_types_url, notice: 'Move Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_type
    @move_type = MoveType.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_type_params
    params.require(:move_type).permit(
        :description,
        :active,
        :account_id
    )
  end
end
