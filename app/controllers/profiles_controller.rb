class ProfilesController < ApplicationController
  before_filter :current_user
  before_action only: [:edit, :update, :change_password]

  def index
    @images_attach = ImageProfile.where(account_id: @current_user.account_id, user_id: @current_user.id)
    @min_commission = ConfigParameter.find_by(account_id: @current_user.account_id, key_description: 'min_commision')
    @max_commission = ConfigParameter.find_by(account_id: @current_user.account_id, key_description: 'max_commision')
    @pay_commission = PayCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @lead_commission = LeadCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @quote_commission = QuoteCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @book_commission = BookCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @post_commission = PostCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @after_commission = AftercareCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @dispatch_commission = DispatchCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @confirm_commission = ConfirmCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @invoice_commission = InvoiceCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @driver_commission = DriverCommission.find_by(account_id: @current_user.account_id, user_id: @current_user.id, active: true)
    @provinces = Province.all
    @cities = City.all
  end

  def change_password

  end

  def update
    respond_to do |format|
      if @current_user.update(parameter_profile)
        if parameter_profile[:password].present?
          flash[:notice] = "Password has been changed successfully."
          format.html { redirect_to change_password_url }
          format.json { render :index }
        end
        format.html { redirect_to profiles_url }
        format.json { render :index }
      else
        format.html { render :edit }
        format.json { render json: @current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Never trust profiles from the scary internet, only allow the white list through.
  def parameter_profile
    params[:user].permit!.to_h
  end

end