class ConfigParametersController < ApplicationController
  before_filter :current_user
  before_action :set_config_parameter, only: [:edit, :update, :destroy]

  def index
    @config_parameters = ConfigParameter.where(account_id: @current_user.account_id)
  end

  def new
    @config_parameter = ConfigParameter.new
  end

  def create
    @config_parameter = ConfigParameter.new(parameter_config_parameter)
    @config_parameter.account_id = @current_user.account_id
    respond_to do |format|
      if @config_parameter.save
        format.html { redirect_to config_parameters_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @config_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @config_parameter.update(parameter_config_parameter)
        format.html { redirect_to config_parameters_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @config_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @config_parameter.destroy
    respond_to do |format|
      format.html { redirect_to config_parameters_url, notice: 'General Configuration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_config_parameter
    @config_parameter = ConfigParameter.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust config_parameters from the scary internet, only allow the white list through.
  def parameter_config_parameter
    params.require(:config_parameter).permit(:description, :value, :key_description)
  end
end

