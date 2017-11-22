class ClientsController < ApplicationController
  before_filter :current_user
  before_action :set_client, only: [:edit, :update, :destroy]

  def index
    @criteria = params[:criteria]
    conditions = []
    wheres = []
    account = 'account_id = ?'
    unless @criteria.nil?
      conditions
          .push('name like ?')
          .push('title like ?')
          .push('home_phone like ?')
          .push('cell_phone like ?')
          .push('work_phone like ?')
          .push('email like ?')
      conditions.count.times { wheres.push("%#{@criteria}%") }
      account = "and #{account}" unless @criteria.nil?
    end
    wheres.push(@current_user.account_id)
    wheres.insert(0, conditions.join(' or ') + account)
    @clients = Client.where(wheres)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.store(client_params, generate_random_password(), @current_user.account_id)
    respond_to do |format|
      if @client
        format.html { redirect_to clients_url }
        format.json { render :index }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find_by(id: @client.user_id)
    @roles = Role.where(account_id: @current_user.account_id)
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        user = User.find_by(id: @client.user_id)
        if user
          user.update(client_params)
          if not user.roles.map(&:id).include?(params[:user_role][:role])
            user.roles.delete_all
            RoleUser.create(account_id: user.account_id, role_id: params[:user_role][:role], user_id: user.id)
          end
        end
        format.html { redirect_to clients_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    User.destroy(@client.user_id)
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def client_information
    all_clients = []
    client = Client.where("name LIKE ? ", "%#{params[:term]}%").where(account_id: @current_user.account_id, active: 1)
    client.each do |information|
      all_clients.push({id: information.id,
                        label: information.name + ' - '+ (information.home_phone.blank? ? information.cell_phone : information.home_phone).to_s + ' - ' + information.email,
                        value: information.name,
                        extra_data: information})
    end
    respond_to do |format|
      format.json { render json: all_clients }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(
        :name,
        :title,
        :home_phone,
        :cell_phone,
        :work_phone,
        :email,
        :active,
        :account_id
    )
  end
end
