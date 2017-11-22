class UsersController < ApplicationController
  before_filter :current_user
  require 'securerandom'

  def new
    @user = User.new
    @provinces = Province.all
    @cities = City.all
  end

  def create
    validate_permissions("create.user") ? '' : return
    @user = User.new(parameter_user)
    @rol = RoleUser.new
    @rol.role_id = params[:role][:role_id] ? params[:role][:role_id] : 1
    @rol.account_id = @current_user.account_id
    @user.account_id = @current_user.account_id
    new_password = SecureRandom.urlsafe_base64(5)
    @user.password = new_password
    if @user.save
      if @rol.role_id != nil
        @rol.user_id = @user.id
        @rol.save
      end
      update_status_commission(@current_user.account_id, @user)
      UserMail.send_email_password(@user.name, @user.email, 'New password', new_password, @user.account).deliver_later
      if params[:back_to].present?
        redirect_to params[:back_to]
      else
        redirect_to request.env["HTTP_REFERER"]
      end
    else
      flash[:notice] = @user.errors.messages.to_s #"Ooops! We can't create the user."
      if params[:back_to].present?
        redirect_to params[:back_to] + '?errors=' + @user.errors.messages.to_s
      else
        redirect_to request.env["HTTP_REFERER"]
      end
    end
  end

  def create_by_account
    #validate_permissions("new.users_by_account") ? '' : return
    @user = User.new(parameter_user)
    @rol = RoleUser.new
    @rol.role_id = params[:role][:role_id] ? params[:role][:role_id] : 1
    @rol.account_id = params[:id]
    @user.account_id = params[:id]
    new_password = SecureRandom.urlsafe_base64(5)
    @user.password = new_password
    if @user.save
      if @rol.role_id != nil
        @rol.user_id = @user.id
        @rol.save
      end
      update_status_commission(params[:id], @user)
      UserMail.send_email_password(@user.name, @user.email, 'New password', new_password, @user.account).deliver_later
      redirect_to :back
    else
      redirect_to :back, notice: "Ooops! We can't create the user."
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    if params[:type] == "driver"
      validate_permissions("view.mover_profiles") ? '' : return
      @roles = Role.where("name = ? or name = ? or name = ?", "mover", "Owner Operator", "Swamper").where(account_id: @current_user.account_id)
    else
      validate_permissions("view.staff_profiles") ? '' : return
      @roles = Role.where("name != ? and name != ? and name != ? and name != ?", "mover", "Owner Operator", "Swamper", "Customer").where(account_id: @current_user.account_id)
    end
    @images_attach = ImageProfile.where(account_id: @user.account_id, user_id: @user.id)
    @min_commission = ConfigParameter.find_by(account_id: @user.account_id, key_description: 'min_commision')
    @max_commission = ConfigParameter.find_by(account_id: @user.account_id, key_description: 'max_commision')
    @pay_commission = PayCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @lead_commission = LeadCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @quote_commission = QuoteCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @book_commission = BookCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @post_commission = PostCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @after_commission = AftercareCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @dispatch_commission = DispatchCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @confirm_commission = ConfirmCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @invoice_commission = InvoiceCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @driver_commission = DriverCommission.find_by(account_id: @user.account_id, user_id: @user.id, active: true)
    @provinces = Province.all
    @cities = City.all
  end

  def update
    @user = User.find_by(id: params[:id])
    if params[:type] == "driver"
      validate_permissions("edit.mover_profiles") ? '' : return
    else
      validate_permissions("edit.staff_profiles") ? '' : return
    end
    if @user.update(parameter_user)
      update_status_commission(@user.account_id, @user)
      if not @user.roles.map(&:id).include?(params[:user_role][:role])
        @user.roles.delete_all
        RoleUser.create(account_id: @user.account_id, role_id: params[:user_role][:role], user_id: @user.id)
      end

      redirect_to :back, notice: 'Information updated.'
    else
      render :edit
    end
  end

  def update_status_commission(account_id, user)
    pay = PayCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    lead = LeadCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    quote = QuoteCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    book = BookCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    post = PostCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    after = AftercareCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    dispatch = DispatchCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    confirm = ConfirmCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    invoice = InvoiceCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    driver = DriverCommission.find_or_initialize_by(account_id: account_id, user_id: user.id)
    if ActiveRecord::Base.transaction do
      pay.update({:active => user.move_commission})
      pay.save!
      lead.update({:active => user.move_commission})
      lead.save!
      quote.update({:active => user.move_commission})
      quote.save!
      book.update({:active => user.move_commission})
      book.save!
      post.update({:active => user.move_commission})
      post.save!
      after.update({:active => user.move_commission})
      after.save!
      dispatch.update({:active => user.move_commission})
      dispatch.save!
      confirm.update({:active => user.move_commission})
      confirm.save!
      invoice.update({:active => user.move_commission})
      invoice.save!
      driver.update({:active => user.driver_commission})
      driver.save!
    end
    else
      raise ActiveRecord::Rollback
    end
  end

  def update_commission
    validate_permissions("edit_shares.pay_rates") ? '' : return
    @user = User.find_by(id: params[:id])
    pay = PayCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    lead = LeadCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    quote = QuoteCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    book = BookCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    post = PostCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    after = AftercareCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    dispatch = DispatchCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    confirm = ConfirmCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    invoice = InvoiceCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])
    driver = DriverCommission.find_or_initialize_by(account_id: @user.account_id, user_id: params[:id])

    if ActiveRecord::Base.transaction do
      pay.update(pay_commission)
      pay.save!
      lead.update(lead_commission)
      lead.save!
      quote.update(quote_commission)
      quote.save!
      book.update(book_commission)
      book.save!
      post.update(post_commission)
      post.save!
      after.update(after_commission)
      after.save!
      dispatch.update(dispatch_commission)
      dispatch.save!
      confirm.update(confirm_commission)
      confirm.save!
      invoice.update(invoice_commission)
      invoice.save!
      driver.update(driver_commission)
      driver.save!
    end
    else
      raise ActiveRecord::Rollback
    end
    redirect_to edit_user_path(params[:id])
  end

  def parameter_user
    params[:user].permit!.to_h
  end

  def rol_user
    params.require(:role).permit(
        :role_id
    )
  end

  def pay_commission
    params.require(:pay).permit(
        :hourly,
        :monthly,
        :detail
    )
  end

  def lead_commission
    params.require(:lead).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def quote_commission
    params.require(:quote).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def book_commission
    params.require(:book).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def post_commission
    params.require(:post).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def after_commission
    params.require(:after).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def dispatch_commission
    params.require(:dispatch).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def confirm_commission
    params.require(:confirm).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def invoice_commission
    params.require(:invoice).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

  def driver_commission
    params.require(:driver).permit(
        :move,
        :storage,
        :packing,
        :insurance,
        :other,
        :blank,
        :ld_move,
        :ld_storage,
        :ld_packing,
        :ld_insurance,
        :ld_other,
        :ld_blank
    )
  end

end
