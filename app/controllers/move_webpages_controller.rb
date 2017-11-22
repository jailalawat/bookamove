class MoveWebpagesController < ApplicationController
  before_filter :current_user
  before_action :set_move_webpage, only: [:edit, :update, :destroy]

  def index
    @move_webpages = MoveWebpage.where(account_id: @current_user.account_id)
  end

  def new
    @move_webpage = MoveWebpage.new
  end

  def create
    @move_webpage = MoveWebpage.new(move_webpage_params)
    @move_webpage.account_id = @current_user.account_id
    respond_to do |format|
      if @move_webpage.save
        format.html { redirect_to move_webpages_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_webpage.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_webpage.update(move_webpage_params)
        format.html { redirect_to move_webpages_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_webpage.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_webpage.destroy
    respond_to do |format|
      format.html { redirect_to move_webpages_url, notice: 'Move Type alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_webpage
    @move_webpage = MoveWebpage.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_webpage_params
    params.require(:move_webpage).permit(
        :description,
        :active,
        :account_id
    )
  end
end
