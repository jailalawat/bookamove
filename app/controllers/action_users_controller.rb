class ActionUsersController < ApplicationController
  before_filter :current_user, :set_action_user
  before_action only: [:edit, :update]

  def index
    validate_permissions("assign.permissions_to_users") ? '' : return
    @action_users = ActionUser.where(account_id: @current_user.account_id).includes(:action)
    @users = User.where(account_id: @current_user.account_id)
  end

  def new
    validate_permissions("assign.permissions_to_users") ? '' : return
    @action_user = ActionUser.new
  end

  def create
    validate_permissions("assign.permissions_to_users") ? '' : return
    respond_to do |format|
      if fill_list_actions()
        format.json { render json: @action_user }
      else
        format.json { render json: @action_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    validate_permissions("assign.permissions_to_users") ? '' : return
    action_user_params[:action_id].each do |action|
      if (action.present?)
        ActionUser.destroy_all(user_id: action_user_params[:user_id], account_id: @current_user.account_id, action_id: action)
      end
    end
    respond_to do |format|
      format.json { render json: true }
    end
  end

  def fill_list_actions
    action_user_params[:action_id].each do |action|
      if (action.present?)
        list_action = ActionUser.new
        list_action.account_id = @current_user.account_id
        list_action.action_id = action
        list_action.user_id = action_user_params[:user_id]
        list_action.save
      end
    end
  end

  def get_actions
    @user = params[:id]
    @assign = ActionUser.where(account_id: @current_user.account_id, user_id: @user).includes(:action)
    action = Action.where.not(id: @assign.map { |v| v.action.id.to_i }).where('created_at > ?', '2017-10-21 00:00:00')
    @unassign = @current_user.account.is_admin ? action : action.where(is_admin_section: false)
    json_text = {:assign => @assign.map { |v| {id: v.action.id, description: v.action.description} }, :unassign => @unassign}.to_json
    respond_to do |format|
      format.json { render json: json_text }
    end
  end

  private

# Use callbacks to share common setup or constraints between actions.
  def set_action_user
    @action_user = ActionUser.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def action_user_params
    params.permit(
        :account_id,
        :user_id,
        :action_id => []
    )
  end
end
