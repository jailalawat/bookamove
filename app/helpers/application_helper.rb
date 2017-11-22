module ApplicationHelper
  def permission_report_move_section(permissions)
    validate_lead(permissions) || validate_quote(permissions) || validate_book(permissions) || validate_dispatch(permissions) || validate_complete(permissions)
  end

  def permission_report(permissions)
    validate_post(permissions) || validate_card_batch(permissions) || validate_source(permissions)
  end

  def validate_special_permission(action_controller, permissions)
    permissions.each do |action|
      if (action_controller == action.key.to_s)
        return true
      end
    end
    return false
  end

  def validate_lead(permissions)
    validate_special_permission('show.lead_report', permissions)
  end

  def validate_quote(permissions)
    validate_special_permission('show.quote_report', permissions)
  end

  def validate_book(permissions)
    validate_special_permission('show.book_report', permissions)
  end

  def validate_dispatch(permissions)
    validate_special_permission('show.dispatch_report', permissions)
  end

  def validate_complete(permissions)
    validate_special_permission('show.complete_report', permissions)
  end

  def validate_post(permissions)
    validate_special_permission('show.post_report', permissions)
  end

  def validate_card_batch(permissions)
    validate_special_permission('show.card_batch_report', permissions)
  end

  def validate_source(permissions)
    validate_special_permission('show.source_report', permissions)
  end

  def filter_urgent_notification(notifications)
    notification = []
    notifications.each do |notification_message|
      if (notification_message[:type_message] == 'personal')
        type_message = notification_message[:data].message
      end
      if (notification_message[:type_message] == 'personal_move_record')
        type_message = notification_message[:data].messages_move_record
      end
      if (notification_message[:type_message] == 'personal_task')
        type_message = notification_message[:data].messages_task
      end
      if (notification_message[:type_message] == 'task_move_record')
        type_message = notification_message[:data].messages_move_record
      end
      if (notification_message[:type_message] == 'personal_truck_calendar')
        type_message = notification_message[:data].messages_truck_calendar
      end
      notification << type_message if type_message.urgent == 2
    end
    return notification
  end

  def filter_normal_notification(notifications)
    notification = []
    notifications.each do |notification_message|
      if (notification_message[:type_message] == 'personal')
        type_message = notification_message[:data].message
      end
      if (notification_message[:type_message] == 'personal_move_record')
        type_message = notification_message[:data].messages_move_record
      end
      if (notification_message[:type_message] == 'personal_task')
        type_message = notification_message[:data].messages_task
      end
      if (notification_message[:type_message] == 'task_move_record')
        type_message = notification_message[:data].messages_move_record
      end
      if (notification_message[:type_message] == 'personal_truck_calendar')
        type_message = notification_message[:data].messages_truck_calendar
      end
      notification << type_message if not type_message.urgent == 2
    end
    return notification
  end

  def login_user_by_token

    if params[:token].present?
      move_token = MoveRecord.find_by(token: params[:token])

      if not move_token.nil?
        user_id = MoveRecordClient.where(move_record_id: move_token.id).first.client.user_id
        session[:user_id] = user_id
      end
    elsif params[:driver_token].present?
      driver_token = MoveRecord.find_by(driver_token: params[:driver_token])
      truck = driver_token.move_record_truck.truck if driver_token
      truck_driver = truck.user if truck

      if not truck_driver.nil?
        session[:user_id] = truck_driver.id
      end
    end

    current_user
  end

  def get_logo_by_account(account)
    if account and not account[:logo].nil?
      "http://#{account.name}.moversnetwork.ca/uploads/account/#{account[:logo]}"
    else
      "http://oomovers.moversnetwork.ca/images/logo2.png"
    end
  end

end
