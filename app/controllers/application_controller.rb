class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :validate_permissions
  include ApplicationHelper
  require 'aws-sdk'

  def current_user
    @account_logo ||= Rails.cache.fetch("account_logo/#{request.subdomain}") do
      Account.find_by(subdomain: request.subdomain).nil? ? "/images/logo2.png" : "/uploads/account/#{Account.find_by(subdomain: request.subdomain)[:logo]}"
    end

    if session[:user_id]
      @current_user ||= Rails.cache.fetch("user/#{session[:user_id]}", :expires_in => 1.days) do
        check_domain_user(session[:user_id])
      end
    else
      @current_user = nil
    end

    redirect_to logout_url and return if not @current_user
    redirect_to login_url unless @current_user

    if @current_user

      # require user subdomain
      if request.subdomain != @current_user.account.subdomain
        redirect_to "http://#{@current_user.account.subdomain}.#{request.domain}:#{request.port.to_s}"
      end

      @images_current_user ||= Rails.cache.fetch("image_profile/#{@current_user.id}") do
        ImageProfile.where(user_id: @current_user.id).order("RAND()").first
      end

      @all_staff_users ||= Rails.cache.fetch("all_account_users/#{@current_user.account_id}") do
        User.where(account_id: @current_user.account_id).where('id NOT IN (?)', Client.where(account_id: @current_user.account_id).map { |v| v.user_id.to_i })
      end

      if session[:token]
        @current_role ||= RoleUser.where(user_id: @current_user.id).order('role_id asc')
      else
        @current_role ||= Rails.cache.fetch("current_role/#{@current_user.id}") do
          RoleUser.where(user_id: @current_user.id).order('role_id asc')
        end
      end

      @role_level ||= Rails.cache.fetch("role_level/#{@current_user.id}") do
        Role.where(id: @current_role.map { |v| v.role_id.to_i }).order('role_level desc').limit(1).pluck("role_level").join.to_i if @current_role
      end

      @roles ||= Rails.cache.fetch("roles/#{@current_user.id}") do
        @current_user.roles.map(&:name) if @current_user.roles
      end

      @all_subtask ||= Rails.cache.fetch("all_subtask_staff_group/#{@current_user.account_id}") do
        SubtaskStaffGroup.where(account_id: @current_user.account_id, mailbox: true, active: true)
      end

      @all_task ||= Rails.cache.fetch("all_calendar_staff_group/#{@current_user.account_id}") do
        CalendarStaffGroup.where(account_id: @current_user.account_id, active: 1)
      end

      @all_calendar_groups ||= Rails.cache.fetch("all_calendar_truck_group/#{@current_user.account_id}") do
        CalendarTruckGroup.where(account_id: @current_user.account_id, active: 1)
      end

      @notification_messages ||= Rails.cache.fetch("all_user_messages/#{@current_user.id}") do
        notification_messages()
      end

      charge_permissions()
    end

  end

  def check_domain_user(user_id)
    user = User.find_by_id_and_active(user_id, 1)
    if user.blank?
      return nil
    end
    if access_admin(user.id)
      return user
    end
    account = Account.find_by(subdomain: request.subdomain)
    if (!account.blank? && user.account_id == account.id)
      return user
    else
      flash[:error] = 'Account Unauthorized'
      return nil
    end
  end

  def access_admin(user_id)
    rol_user ||= RoleUser.where(user_id: user_id)
    action ||= Action.find_by(key: 'admin.access')
    action_user ||= ActionUser.where(user_id: user_id, action_id: action.id)
    action_rol ||= ActionRole.where(role_id: rol_user.map { |v| v.role_id.to_i }, action_id: action.id)
    (action_user | action_rol).size > 0
  end

  def validate_permissions(action_controller)
    @current_actions.each do |action|
      if (action_controller == action.key.to_s)
        return true
      end
    end
    redirect_to ('/errors/unauthorized') and return false
  end

  def validate_special_permission(action_controller)
    @current_actions.each do |action|
      if (action_controller == action.key.to_s)
        return true
      end
    end
    return false
  end

  def unauthorized
    redirect_to ('/errors/unauthorized') and return false
  end

  def charge_permissions
    action_role ||= Rails.cache.fetch("user_action_role/#{@current_user.id}") do
      ActionRole.where(role_id: @current_role.map { |v| v.role_id.to_i }).order('role_id asc') if @current_role
    end
    actions_by_role ||= Rails.cache.fetch("user_action_by_role/#{@current_user.id}") do
      Action.where(id: action_role.map { |v| v.action_id.to_i }).order('id asc') if action_role
    end
    action_user ||= Rails.cache.fetch("all_user_actions/#{@current_user.id}") do
      ActionUser.where(user_id: @current_user.id).order('id asc') if @current_user
    end
    actions_by_user ||= Rails.cache.fetch("all_action_by_user/#{@current_user.id}") do
      Action.where(id: action_user.map { |v| v.action_id.to_i }).order('id asc') if action_user
    end
    @current_actions ||= (actions_by_user | actions_by_role)
  end

  def upload_bucket_file(file_uploaded, name, bucket_name)
    credentials = Aws::Credentials.new(Rails.application.secrets.mmo_s3_key_id, Rails.application.secrets.mmo_s3_access_key)
    s3 = Aws::S3::Resource.new(region: 'us-west-1', credentials: credentials)
    obj = s3.bucket(bucket_name).object(name)
    obj.upload_file(file_uploaded.tempfile, acl: 'public-read')
    return obj.public_url
  end

  def delete_uploaded_file(name, bucket_name)
    credentials = Aws::Credentials.new(Rails.application.secrets.mmo_s3_key_id, Rails.application.secrets.mmo_s3_access_key)
    s3 = Aws::S3::Resource.new(region: 'us-west-1', credentials: credentials)
    obj = s3.bucket(bucket_name)
    obj.object(name).delete
  end

  def generate_random_password
    return ([*('A'..'Z'), *('0'..'9')]-%w(0 1 I O)).sample(8).join
  end

  def notification_messages
    u_message = UserMessage.where(account_id: @current_user.account_id, user_id: @current_user.id, readed: false, trash: false).includes(:message).order(created_at: :desc)

    u_message_move_record = UserMessagesMoveRecord.where(account_id: @current_user.account_id, user_id: @current_user.id, readed: false, trash: false).includes(:messages_move_record).order(created_at: :desc)

    u_message_task = UserMessagesTask.where(account_id: @current_user.account_id, user_id: @current_user.id, readed: false, trash: false).includes(:messages_task).order(created_at: :desc)
    t_message_move_record = TaskMessagesMoveRecord.where(account_id: @current_user.account_id, readed: false, trash: false).includes(:messages_move_record).order(created_at: :desc)

    u_message_truck_calendar = UserMessageTruckCalendar.where(account_id: @current_user.account_id, user_id: @current_user.id, readed: false, trash: false).includes(:messages_truck_calendar).order(created_at: :desc)

    u_message_data = []
    u_message.each do |message|
      u_message_data.push({data: message, type_message: 'personal'})
    end

    u_message_move_record_data = []
    u_message_move_record.each do |message|
      u_message_move_record_data.push({data: message, type_message: 'personal_move_record'})
    end

    u_message_task_data = []
    u_message_task.each do |message|
      u_message_task_data.push({data: message, type_message: 'personal_task'})
    end

    u_message_truck_calendar_data = []
    u_message_truck_calendar.each do |message|
      u_message_truck_calendar_data.push({data: message, type_message: 'personal_truck_calendar'})
    end

    return u_message_data + u_message_move_record_data + u_message_task_data + u_message_truck_calendar_data
  end

  def mover_display_name(name)
    user_info = name.split
    client = user_info[0][0..3].capitalize + (user_info[1].present? ? user_info[1][0].capitalize : '')
  end

  def utc_time_zone(&block)
    Time.use_zone("UTC", &block)
  end

end
