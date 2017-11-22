class MoveKeywordsController < ApplicationController
  before_filter :current_user
  before_action :set_move_keyword, only: [:edit, :update, :destroy]

  def index
    @move_keywords = MoveKeyword.where(account_id: @current_user.account_id)
  end

  def new
    @move_keyword = MoveKeyword.new
  end

  def create
    @move_keyword = MoveKeyword.new(move_keyword_params)
    @move_keyword.account_id = @current_user.account_id
    respond_to do |format|
      if @move_keyword.save
        format.html { redirect_to move_keywords_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @move_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @move_keyword.update(move_keyword_params)
        format.html { redirect_to move_keywords_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @move_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @move_keyword.destroy
    respond_to do |format|
      format.html { redirect_to move_keywords_url, notice: 'Move Type alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move_keyword
    @move_keyword = MoveKeyword.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def move_keyword_params
    params.require(:move_keyword).permit(
        :description,
        :active,
        :account_id
    )
  end
end
