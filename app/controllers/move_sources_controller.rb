class MoveSourcesController < ApplicationController
  before_filter :current_user
  before_action :set_move_source, only: [:edit, :update, :destroy]

  def index
    @move_sources = MoveSource.where(account_id: @current_user.account_id)
  end

  def new
    @move_source = MoveSource.new
  end

  def create
    @move_source = MoveSource.new(move_source_params)
    @move_source.account_id = @current_user.account_id
    respond_to do |format|
      if @move_source.save
        format.html { redirect_to move_sources_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_source.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_source.update(move_source_params)
        format.html { redirect_to move_sources_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_source.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_source.destroy
    respond_to do |format|
      format.html { redirect_to move_sources_url, notice: 'Move Type alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_source
    @move_source = MoveSource.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_source_params
    params.require(:move_source).permit(
        :description,
        :active,
        :account_id
    )
  end
end
