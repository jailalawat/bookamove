class ActionRolesController < ApplicationController
  before_filter :current_user, :set_action_role
  before_action only: [:edit, :update]

  def index
    validate_permissions("assign.permissions_to_roles") ? '' : return
    @all_actions = Action.all.where('created_at > ?', '2017-10-21 00:00:00')
    @action_roles = ActionRole.where(account_id: @current_user.account_id).includes(:action)
    @roles = Role.where(account_id: @current_user.account_id).order(role_level: :asc)
  end

  def new
    validate_permissions("assign.permissions_to_roles") ? '' : return
    @action_role = ActionRole.new
  end

  def create
    validate_permissions("assign.permissions_to_roles") ? '' : return
    respond_to do |format|
      if fill_list_actions()
        @action_roles = ActionRole.where(action_id: action_role_params[:action_id], role_id: @current_user.roles.map(&:id))
        json_text = {:assign => @action_roles.map { |v| {id: v.action.id, description: v.action.description, group: v.action.group, role_level: v.action.role_level} } }
        format.json { render json: json_text }
      else
        format.json { render json: @action_role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    validate_permissions("assign.permissions_to_roles") ? '' : return
    action_role_params[:action_id].each do |action|
      if (action.present?)
        ActionRole.destroy_all(role_id: action_role_params[:role_id], account_id: @current_user.account_id, action_id: action)
      end
    end
    respond_to do |format|
      format.json { render json: true }
    end
  end

  def fill_list_actions
    action_role_params[:action_id].each do |action|
      if (action.present?)
        list_action = ActionRole.new
        list_action.account_id = @current_user.account_id
        list_action.action_id = action
        list_action.role_id = action_role_params[:role_id]
        list_action.save
      end
    end
  end

  def get_actions
    @current_role = params[:id]
    @assign = ActionRole.where(account_id: @current_user.account_id, role_id: @current_role).includes(:action).order(id: :desc)
    action = Action.where.not(id: @assign.map { |v| v.action.id.to_i }).where('created_at > ?', '2017-10-21 00:00:00')
    @unassign = @current_user.account.is_admin ? action : action.where(is_admin_section: false)
    json_text = {:assign => @assign.map { |v| {id: v.action.id, description: v.action.description, group: v.action.group, role_level: v.action.role_level} }, :unassign => @unassign}.to_json
    respond_to do |format|
      format.json { render json: json_text }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_action_role
    @action_role = ActionRole.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def action_role_params
    params.permit(
        :account_id,
        :role_id,
        :action_id => []
    )
  end
end
