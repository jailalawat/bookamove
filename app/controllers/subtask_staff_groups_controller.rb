class SubtaskStaffGroupsController < ApplicationController
  before_filter :current_user
  before_action :set_subtaskStaffGroup, only: [:edit, :update, :destroy]

  def index
    #validate_permissions("show.calendar_staff_group") ? '' : return
    @subtasks = SubtaskStaffGroup.where(account_id: @current_user.account_id)
  end

  def add_subtask_group
    #validate_permissions("new.calendar_staff_group") ? '' : return
    respond_to do |format|
      subtask = SubtaskStaffGroup.new
      subtask.account_id = @current_user.account_id
      subtask.name = params[:name]
      subtask.description = params[:description]
      subtask.calendar_staff_group_id = params[:taskgroup].to_i
      subtask.mailbox = params[:mailbox]
      subtask.active = params[:active]
      if subtask.save
        format.json { render json: subtask }
      else
        format.json { render json: subtask.errors }
      end
    end
  end

  def new
    #validate_permissions("new.calendar_staff_group") ? '' : return
    @subtask = SubtaskStaffGroup.new
    @subtask.users = {}
  end

  def edit
    #validate_permissions("edit.calendar_staff_group") ? '' : return
    @subtask.users = StaffTask.where(account_id: @current_user.account_id, subtask_staff_group_id: @subtask.id)
    @list_staff_group = []
    @subtask.users.each do |staff|
      @list_staff_group.push(staff.user_id)
    end
  end

  def update
    #validate_permissions("edit.calendar_staff_group") ? '' : return
    respond_to do |format|
      if @subtask.update(subtask_params)
        format.html { redirect_to edit_calendar_staff_group_path({id: @subtask.calendar_staff_group_id}) }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @subtask.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #validate_permissions("edit.calendar_staff_group") ? '' : return
    @subtask.destroy
    respond_to do |format|
      format.html { redirect_to subtask_staff_groups_path, notice: 'staff group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subtaskStaffGroup
    @subtask = SubtaskStaffGroup.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subtask_params
    params.require(:subtask_staff_group).permit(:name, :description, :active, :mailbox, :users => [])
  end
end
