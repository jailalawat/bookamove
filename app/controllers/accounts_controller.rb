class AccountsController < ApplicationController
  before_filter :current_user
  before_action only: [:edit, :update]
  before_action :get_cal_range, only: [:list]

  def index
    #validate_permissions("show.account_profile_personal") ? '' : return
    @current_account = Account.find_by(id: @current_user.account_id)
    @min_commission = ConfigParameter.find_by(account_id: @current_user.account_id, key_description: 'min_commision')
    @max_commission = ConfigParameter.find_by(account_id: @current_user.account_id, key_description: 'max_commision')
    @users = User.where(account_id: @current_user.account_id)
    @roles = Role.where(account_id: @current_user.account_id)
    @provinces = Province.all
  end

  def staff
    #validate_permissions("view.staff_profiles") ? '' : return
    @users = User.joins(:roles).where("roles.name != ? and roles.name != ? and roles.name != ? and roles.name != ?", "mover", "Owner Operator", "Swamper", "Customer").where(account_id: @current_user.account_id).select("users.*, roles.name as role")
    @roles = Role.where("name != ? and name != ? and name != ? and name != ?", "mover", "Owner Operator", "Swamper", "Customer").where(account_id: @current_user.account_id)
  end

  def drivers
    #validate_permissions("view.mover_profiles") ? '' : return
    @users = User.joins(:roles).where("roles.name = ? or roles.name = ? or roles.name = ?", "mover", "Owner Operator", "Swamper").where(account_id: @current_user.account_id).select("users.*, roles.name as role")
    @roles = Role.where("name = ? or name = ? or name = ?", "mover", "Owner Operator", "Swamper").where(account_id: @current_user.account_id)
  end

  def new
    validate_permissions("new.accounts") ? '' : return
    @current_account = Account.new
    @provinces = Province.all
  end

  def create
    validate_permissions("new.accounts") ? '' : return
    @current_account = Account.new(parameter_profile)
    respond_to do |format|
      if @current_account.save
        role_owner = Role.create(account_id: @current_account.id, name: "Owner", description: "Owner Role")
        role_client = Role.create(account_id: @current_account.id, name: "Client", description: "Client role")
        ActionRole.create(account_id: @current_account.id, role_id: role_owner.id, action_id: "1")
        ActionRole.create(account_id: @current_account.id, role_id: role_owner.id, action_id: "2")
        ActionRole.create(account_id: @current_account.id, role_id: role_owner.id, action_id: "3")
        format.html { redirect_to '/list_accounts' }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @current_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    validate_permissions("show.accounts_profiles") ? '' : return
    @current_account = Account.find_by(id: params[:id])
    @min_commission = ConfigParameter.find_by(account_id: params[:id], key_description: 'min_commision')
    @max_commission = ConfigParameter.find_by(account_id: params[:id], key_description: 'max_commision')
    @users = User.where(account_id: params[:id])
    @roles = Role.where(account_id: params[:id])
    @provinces = Province.all
    render 'edit'
  end

  def update_by_id
    validate_permissions("edit.accounts_by_account") ? '' : return
    account = Account.find_by(id: params[:id])
    @current_account = Account.find_by(id: params[:id])
    respond_to do |format|
      if account.update(parameter_profile)
        format.html { redirect_to "/accounts/#{@current_account.id}/edit" }
        format.json { render 'edit' }
      else
        format.html { render 'edit' }
        format.json { render json: account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    validate_permissions("edit.company_profile") ? '' : return
    account = Account.find_by(id: @current_user.account_id)
    respond_to do |format|
      if account.update(parameter_profile)
        format.html { redirect_to accounts_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: account.errors, status: :unprocessable_entity }
      end
    end
  end

  def list
    validate_permissions("show.list_accounts") ? '' : return
    @accounts = Account.all()
  end

  def fill_table_account_list
    validate_permissions("show.list_accounts") ? '' : return
    all_list_accounts = []
    response = Account.list(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], params[:length], params[:start])
    response[:list_posted].each do |account|
      all_list_accounts.push({
                                 name: '<a href="' + edit_account_path(account["id"]) + '" target="_blank">' + account["name"] + '</a>',
                                 email: account["email"],
                                 site: account["site"],
                                 office_phone: account["office_phone"],
                                 subdomain: account["subdomain"],
                             })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_list], recordsFiltered: response[:count_list], data: all_list_accounts} }
    end
  end

  def get_cal_range
    cal_range = GeneralSetting.where(account_id: @current_user.account_id, type: "calendar_range").limit(1)
    @calendar_range = (not cal_range.blank?) ? cal_range[0].value : 5
  end

  def parameter_profile
    params[:account].permit!.to_h
  end
end
