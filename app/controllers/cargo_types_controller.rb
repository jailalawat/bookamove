class CargoTypesController < ApplicationController
  before_filter :current_user
  before_action :set_cargo_type, only: [:edit, :update, :destroy]

  def index
    @cargo_types = CargoType.where(account_id: @current_user.account_id)
  end

  def new
    @cargo_type = CargoType.new
  end

  def create
    @cargo_type = CargoType.new(cargo_type_params)
    @cargo_type.account_id = @current_user.account_id
    respond_to do |format|
      if @cargo_type.save
        format.html { redirect_to cargo_types_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @cargo_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @cargo_type.update(cargo_type_params)
        format.html { redirect_to cargo_types_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @cargo_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cargo_type.destroy
    respond_to do |format|
      format.html { redirect_to cargo_types_url, notice: 'Cargo Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cargo_type
    @cargo_type = CargoType.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cargo_type_params
    params.require(:cargo_type).permit(
        :description,
        :active,
        :account_id
    )
  end
end
