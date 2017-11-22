class RoleUsersController < ApplicationController
  before_filter :current_user, :set_user_role
  before_action only: [:edit, :update]

  def index
    @user_roles = RoleUser.where(account_id: @current_user.account_id).includes(:user)
    @users = User.where(account_id: @current_user.account_id)
  end

  def new
    @user_role = RoleUser.new
  end

  def create
    respond_to do |format|
      if fill_list_users()
        format.json { render json: @user_role }
      else
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    user_role_params[:role_id].each do |role|
      if (role.present?)
        RoleUser.destroy_all(role_id: role, account_id: @current_user.account_id, user_id: user_role_params[:user_id])
      end
    end
    respond_to do |format|
      format.json { render json: true }
    end
  end

  def fill_list_users
    user_role_params[:role_id].each do |role|
      if (role.present?)
        list_user = RoleUser.new
        list_user.account_id = @current_user.account_id
        list_user.user_id = user_role_params[:user_id]
        list_user.role_id = role
        list_user.save
      end
    end
  end

  def get_roles
    user = params[:id]
    @assign = RoleUser.where(account_id: @current_user.account_id, user_id: user).includes(:role)
    @unassign = Role.where.not(id: @assign.map { |v| v.role.id.to_i }).where(account_id: @current_user.account_id)
    json_text = {:assign => @assign.map { |v| {id: v.role.id, description: v.role.description} }, :unassign => @unassign}.to_json
    respond_to do |format|
      format.json { render json: json_text }
    end
  end

  private

# Use callbacks to share common setup or constraints between users.
  def set_user_role
    @user_role = RoleUser.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def user_role_params
    params.permit(
        :account_id,
        :user_id,
        :role_id => []
    )
  end
end
