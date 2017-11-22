class CalendarStaffGroupsController < ApplicationController
  before_filter :current_user
  before_action :set_CalendarStaffGroup, only: [:edit, :update, :destroy]

  def index
    @calendar_staff_groups = CalendarStaffGroup.where(account_id: @current_user.account_id)
  end

  def new
    validate_permissions("create_edit.staff_calendars") ? '' : return
    @calendar_staff_group = CalendarStaffGroup.new
  end

  def create
    validate_permissions("create_edit.staff_calendars") ? '' : return
    @calendar_staff_group = CalendarStaffGroup.new(calendar_staff_group_params)
    @calendar_staff_group.account_id = @current_user.account_id
    respond_to do |format|
      if @calendar_staff_group.save
        format.html { redirect_to "/calendar_staff_groups/#{@calendar_staff_group.id}/edit" }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @calendar_staff_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    validate_permissions("create_edit.staff_calendars") ? '' : return
    @list_staff_group = []
    @subtasks = SubtaskStaffGroup.where(account_id: @current_user.account_id, calendar_staff_group_id: params[:id])
    @role = Role.new
    @existing_roles = Role.where(account_id: @current_user.account_id, calendar_staff_group_id: nil)
    @calendar_roles = Role.where(account_id: @current_user.account_id, calendar_staff_group_id: params[:id])
  end

  def update
    validate_permissions("create_edit.staff_calendars") ? '' : return
    respond_to do |format|
      if @calendar_staff_group.update(calendar_staff_group_params)
        format.html { redirect_to calendar_staff_groups_url }
        format.json { render :index }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @calendar_staff_group.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def destroy
    validate_permissions("create_edit.staff_calendars") ? '' : return
    @calendar_staff_group.destroy
    respond_to do |format|
      format.html { redirect_to calendar_staff_groups_url }
      format.json { head :no_content }
      format.js { }
    end
  end

  def remove_role
    validate_permissions("create_edit.staff_calendars") ? '' : return
    role = Role.where(account_id: @current_user.account_id, id: params[:role_id])
    role.update(calendar_staff_group_id: nil)
    redirect_to :back
  end

  def assign_role
    validate_permissions("create_edit.staff_calendars") ? '' : return
    respond_to do |format|
      role = Role.where(account_id: @current_user.account_id, id: params[:role_id])
      if role.update(calendar_staff_group_id: params[:cal_id])
        format.json { render json: role }
      else
        format.json { render json: role.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_CalendarStaffGroup
    @calendar_staff_group = CalendarStaffGroup.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def calendar_staff_group_params
    params.require(:calendar_staff_group).permit(:name, :description, :active, :users => [])
  end
end