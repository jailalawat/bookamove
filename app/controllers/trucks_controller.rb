class TrucksController < ApplicationController
  before_filter :current_user
  before_action :set_truck, only: [:edit, :update, :destroy]
  before_action :set_truck_groups, only: [:edit, :new]

  def index
    @trucks = Truck.where(account_id: @current_user.account_id).includes(:list_truck_group => :calendar_truck_group)
  end

  def new
    validate_permissions("create_edit.trucks") ? '' : return
    @truck = Truck.new
  end

  def create
    validate_permissions("create_edit.trucks") ? '' : return
    @truck = Truck.new(truck_params)
    @truck.account_id = @current_user.account_id
    respond_to do |format|
      if @truck.save
        format.html { redirect_to trucks_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    validate_permissions("create_edit.trucks") ? '' : return
    @editing = 'editing'
    @images_attach = ImageTruck.where(account_id: @current_user.account_id, truck_id: params[:id])
  end

  def update
    validate_permissions("create_edit.trucks") ? '' : return
    respond_to do |format|
      if @truck.update(truck_params)
        format.html { redirect_to trucks_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    validate_permissions("create_edit.trucks") ? '' : return
    @truck.destroy
    respond_to do |format|
      format.html { redirect_to trucks_url, notice: 'Truck was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_truck
    @truck = Truck.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  def set_truck_groups
    @truck_groups = TruckGroup.where(account_id: @current_user.account_id)
    #@truck_sizes = TruckSize.where(account_id: @current_user.account_id)
    @all_mover_users = User.joins(:roles).where("roles.name = ? or roles.name = ?", "mover", "Owner Operator").where(account_id: @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def truck_params
    params[:truck].permit!.to_h
  end
end
