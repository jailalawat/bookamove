class RolesController < ApplicationController
  before_filter :current_user, :set_role
  before_action only: [:edit, :update]

  def index
    @roles = Role.where(account_id: @current_user.account_id).order(role_level: :asc)
  end

  def new
    validate_permissions("create_edit.roles") ? '' : return
    @role = Role.new
  end

  def create
    validate_permissions("create_edit.roles") ? '' : return
    @role = Role.new(role_params)
    @role.account_id = @current_user.account_id
    @role.calendar_staff_group_id = params[:calendar_staff_group_id] if not params[:calendar_staff_group_id].blank?

    respond_to do |format|
      if @role.save
        format.html {
          if params[:redirect_url].blank?
            redirect_to roles_url
          else
            redirect_to params[:redirect_url]
          end
        }
        format.json { render :index }

        Role.assign_permissions(@role.id, params[:role][:role_level], @current_user.account_id)
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if validate_special_permission("create_edit.roles") or validate_special_permission("edit.mover_roles") or validate_special_permission("edit.staff_roles")
      @form_disabled = true

      if (@role.name == "Mover" or @role.name == "Swamper" or @role.name == "Owner Operator") and (validate_special_permission("edit.mover_roles"))
        @form_disabled = false
      elsif (@role.default and @role.name != "Mover" and @role.name != "Swamper" and @role.name != "Owner Operator") and validate_special_permission("edit.staff_roles")
        @form_disabled = false
      elsif not @role.default and validate_special_permission("create_edit.roles")
        @form_disabled = false
      end
    else
      unauthorized
    end
  end

  def update
    #validate_permissions("create_edit.roles") ? '' : return
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to roles_url }
        format.json { render :index }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def destroy
    validate_permissions("create_edit.roles") ? '' : return
    begin
      Role.remove_permissions(@role.id)
      @role.destroy
      respond_to do |format|
        format.html { redirect_to roles_url, flash[:ok] = "Role was successfully destroyed." }
        format.js {}
      end
    rescue Exception => e
      respond_to do |format|
        format.html { redirect_to roles_url, flash[:notice] = "Error, There are data that depend on this record." }
        format.js {}
      end
    end
  end

  def return_to_default_permissions
    Role.return_to_default_values(@role.id, @role.role_level, @role.account_id)
    redirect_to '/action_roles'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(
        :name,
        :description,
        :account_id,
        :role_level,
        :active,
        :mailbox
    )
  end

end
