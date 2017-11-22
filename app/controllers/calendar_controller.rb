class CalendarController < MessagesTruckCalendarsController
  before_filter :current_user, :index_messages
  around_action :utc_time_zone

  def index
    if validate_special_permission("view.all_truck_calendars") or validate_special_permission("view.truck_calendars.only_in_my_city") or validate_special_permission("view.all_truck_calendars.with_all_info_blacked_out") or validate_special_permission("view.truck_calendars.with_all_info_blacked_out_only_in_my_city")

      if validate_special_permission("view.truck_calendars.only_in_my_city") and not validate_special_permission("view.all_truck_calendars")
        cal = CalendarTruckGroup.find_by(id: params[:group])
        if cal
          cal_city = City.find_by(id: cal.city_id)
          if @current_user.city == cal_city.description
            list_trucks
          else
            unauthorized
          end
        end
      else
        list_trucks
      end

    else
      unauthorized
    end
  end

  def list_trucks
    @calendar_trucks = ListTruckGroup.where(account_id: @current_user.account_id, calendar_truck_group_id: params[:group])
    @group_selected = params[:group]
    if (params[:group].present?)
      @trucks = Truck.where(account_id: @current_user.account_id, id: @calendar_trucks.map { |v| v.truck_id.to_i })
    else
      @trucks = Truck.where(account_id: @current_user.account_id)
    end
  end

  def truck_calendar_resources
    #validate_permissions("show.truck_calendar_resources") ? '' : return
    calendar_resource_trucks = []
    if params[:group]
      @calendar_groups = CalendarTruckGroup.where(account_id: @current_user.account_id, active: 1)
      @calendar_trucks = ListTruckGroup.where(account_id: @current_user.account_id, calendar_truck_group_id: params[:group].present? ? params[:group] : @calendar_groups.map { |v| v.id.to_i }).group("truck_id")
      @calendar_trucks.each do |calendar_single_truck|
        calendar_resource_trucks.push(id: calendar_single_truck.truck_id,
                                      name: calendar_single_truck.truck.description,
                                      className: 'truck-id-' + calendar_single_truck.truck_id.to_s,
                                      url: truck_availables_path(truck: calendar_single_truck.truck_id.to_s))
      end
    else
      @calendar_trucks = Truck.where(account_id: @current_user.account_id, active: 1)
      @calendar_trucks.each do |calendar_single_truck|
        calendar_resource_trucks.push(id: calendar_single_truck.id,
                                      name: calendar_single_truck.description,
                                      className: 'truck-id-' + calendar_single_truck.id.to_s,
                                      url: truck_availables_path(truck: calendar_single_truck.truck_id.to_s))
      end
    end
    blank_resource = (6 - calendar_resource_trucks.size.to_i)
    blank_resource.to_i.times do |i|
      calendar_resource_trucks.push(id: '', name: '', className: 'gray-disabled')
    end
    respond_to do |format|
      format.json { render json: calendar_resource_trucks }
    end
  end

  def move_calendar_event
    #validate_permissions("show.calendar_move_record") ? '' : return
    reminders = []
    start_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.beginning_of_month : params[:start]
    end_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.end_of_month : params[:end]
    if (params[:truck_id].present?)
      move_record_trucks = MoveRecordTruck.where(account_id: @current_user.account_id, truck_id: params[:truck_id])
      move_record = MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id).where(move_record_id: move_record_trucks.map { |v| v.move_record_id.to_i })
      calendar_trucks = Truck.where(account_id: @current_user.account_id)
      reminder = ReminderCalendarMoveRecord.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id).where(calendar_truck_group_id: params[:group_id])
    elsif (params[:group_id].present?)
      calendar_trucks = ListTruckGroup.where(account_id: @current_user.account_id, calendar_truck_group_id: params[:group_id])
      move_record_trucks = MoveRecordTruck.where(account_id: @current_user.account_id, truck_id: calendar_trucks.map { |v| v.truck_id.to_i })
      move_record = MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id).where(move_record_id: move_record_trucks.map { |v| v.move_record_id.to_i })
      reminder = ReminderCalendarMoveRecord.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id).where(calendar_truck_group_id: params[:group_id])
    else
      calendar_trucks = Truck.where(account_id: @current_user.account_id)
      move_record = MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
      reminder = ReminderCalendarMoveRecord.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id).where(calendar_truck_group_id: params[:group_id])
    end
    reminder.each do |temp_reminder|
      reminders.push(title: 'Reminder',
                     start: temp_reminder.date,
                     :end => temp_reminder.date + 15.minutes,
                     type: 'reminder',
                     editable: false,
                     subject: ActionController::Base.helpers.truncate(temp_reminder.messages_truck_calendar.subject, length: 15),
                     comment: ActionController::Base.helpers.truncate(temp_reminder.messages_truck_calendar.body, length: 15) +
                         (' <span class="more-reminder pointer" data-link-message="' + temp_reminder.messages_truck_calendar_id.to_s + '"> more</span>'),
                     resources: temp_reminder.truck_id.blank? ? nil : temp_reminder.truck_id)
    end
    movers = []
    color_stages = ['Lead' => 'stage-calendar-Lead',
                    'Quote' => 'stage-calendar-Quote',
                    'Follow up' => 'stage-calendar-Follow-up',
                    'Unable' => 'stage-calendar-Unable',
                    'Cancel' => 'stage-calendar-Cancel',
                    'Book' => 'stage-calendar-Book',
                    'Dispatch' => 'stage-calendar-Dispatch',
                    'Receive' => 'stage-calendar-Receive',
                    'Activated' => 'stage-calendar-Activated',
                    'Active' => 'stage-calendar-Active',
                    'Complete' => 'stage-calendar-Complete',
                    'Submit' => 'stage-calendar-Submit',
                    'Invoice' => 'stage-calendar-Invoice',
                    'Post' => 'stage-calendar-Post',
                    'Aftercare' => 'stage-calendar-Aftercare']

    move_record.each do |move|
      move_temp = MoveRecord.find(move[:move_record_id])
      move_client = MoveRecordClient.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id])
      move_record_origins = MoveRecordLocationOrigin.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id])
      move_record_destinations = MoveRecordLocationDestination.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id])
      move_record_dates = MoveRecordDate.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id])
      move_record_trucks = MoveRecordTruck.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id])
      move_record_packing = MoveRecordPacking.find_by_account_id_and_move_record_id(@current_user.account_id, move[:move_record_id])
      move_record_payment = MoveRecordPayment.find_by_account_id_and_move_record_id(@current_user.account_id, move[:move_record_id])
      move_stage = MoveStatusEmailAlert.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id]).where.not(contact_stage_id: nil).last
      move_stages = MoveStatusEmailAlert.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id]).where.not(contact_stage_id: nil)
      move_cost_time = MoveRecordCostHourly.find_by_account_id_and_move_record_id(@current_user.account_id, move[:move_record_id])
      move_truck = MoveRecordTruck.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id]).first
      date_move = move.move_date.to_date.to_s
      half_travel = move_cost_time.travel.to_f / 2
      end_time = DateTime.parse((move.estimation_time.blank? ? move.move_time + 0.25.hours : move.move_time).strftime("%I:%M %p")) + move.estimation_time.to_f.hours if move.move_time
      start_add_travel = DateTime.parse(move.move_time.strftime("%I:%M %p")) - half_travel.hours if move.move_time
      stop_add_travel = end_time + half_travel.hours if end_time
      movers_move = move_truck.attributes.slice("lead", "mover_2", "mover_3", "mover_4", "mover_5", "mover_6").compact

      # alerts
      all_alerts = {}

      all_alerts["Move Type:"] = move_temp.move_type_alert_id
      all_alerts["Source:"] = move_temp.move_source_alert_id
      all_alerts["Cargo:"] = move_temp.cargo_alert_id
      all_alerts["Origin Access:"] = move_record_origins[0].location.access_alert_id
      all_alerts["Dest. Access:"] = move_record_destinations[0].location.access_alert_id
      all_alerts["Time:"] = move_record_dates[0].time_alert_id
      all_alerts["Equipment:"] = move_record_trucks[0].equipment_alert_id
      all_alerts["Packing:"] = move_record_packing.packing_alert_id
      all_alerts["Payment:"] = move_record_payment.payment_alert_id

      # where
      if !move_record_origins[0].location.locale.blank? and move_record_destinations[0].location.locale.blank?
        where = move_record_origins[0].location.locale[0..2] +" - "+ move_record_destinations[0].location.locale[0..2]
      else
        where = move_record_origins[0].location.city[0..2] +" - "+ move_record_destinations[0].location.city[0..2]
      end

      where = "" if where == " - "

      # all move stages
      all_move_stages = []
      last_stage = ContactStage.where(account_id: @current_user.account_id, id: move_stage.contact_stage_id).first
      current_move_stage = last_stage.stage || last_stage.sub_stage

      move_stages.each do |stage|
        x_stage = ContactStage.where(account_id: @current_user.account_id, id: stage.contact_stage_id).first
        all_move_stages << x_stage.stage || x_stage.sub_stage if x_stage
      end

      if validate_special_permission("view.all_truck_calendars.with_all_info_blacked_out") or validate_special_permission("view.truck_calendars.with_all_info_blacked_out_only_in_my_city")

        if validate_special_permission("view.truck_calendars.with_all_info_blacked_out_only_in_my_city") and not validate_special_permission("view.all_truck_calendars.with_all_info_blacked_out")
          cal = CalendarTruckGroup.find_by(id: params[:group_id])
          if cal
            cal_city = City.find_by(id: cal.city_id)
            if @current_user.city == cal_city.description
              all_info_blacked_out = true
            else
              all_info_blacked_out = false
            end
          end
        else
          all_info_blacked_out = true
        end

      else
        all_info_blacked_out = false
      end

      if validate_special_permission("edit.truck_calendars.cut_copy_and_paste")
        cut_copy_and_paste = true
      else
        cut_copy_and_paste = false
      end

      movers.push(title: move_client.present? ? move_client.map { |v| v.client.name } : move_temp.move_type_detail,
                  what: move_temp.cargo_type_id,
                  where: where,
                  current_alert: move_temp.move_type_alert_id,
                  all_alerts: all_alerts,
                  current_move_stage: current_move_stage,
                  all_move_stages: all_move_stages,
                  start: date_move + ' ' + (start_add_travel.nil? ? "" : start_add_travel.strftime("%I:%M %p")),
                  :end => date_move + ' ' + (stop_add_travel.nil? ? "" : stop_add_travel.strftime("%I:%M %p")),
                  date_id: move.id,
                  move_id: move_temp.id,
                  url_move: edit_move_record_path(move_temp),
                  description: move_temp.move_type_detail,
                  className: (move_stage.present? ? color_stages[0][current_move_stage] : '').to_s + ' move-record-static-link',
                  resources: move_truck.truck_id,
                  truck_names: {truck: move_truck.truck.description, movers: movers_move.map { |v, t| mover_display_name(User.find(t).name) }.join(', ')},
                  half_travel: half_travel,
                  type: 'move_record',
                  overlap: false,
                  all_info_blacked_out: all_info_blacked_out,
                  cut_copy_and_paste: cut_copy_and_paste)
    end

    unavailable = []
    calendar_trucks.each do |list_truck|
      truck_times = list_truck.truck.truck_available
      truck_times.each do |time|
        unavailable.push(
            start: time.start_time.to_s,
            :end => time.end_time.to_s,
            rendering: 'background',
            resources: time.truck_id,
            className: 'opacity-event ' + (time.available ? 'available-calendar' : 'unavailable-calendar'),
            editable: false,
            type: 'background')
      end
    end

    respond_to do |format|
      format.json { render json: movers + reminders + unavailable }
    end
  end

  def mover_display_name(name)
    user_info = name.split
    client = user_info[0][0..3].capitalize + (user_info[1].present? ? user_info[1][0].capitalize : '')
  end

  def move_calendar_update_time
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      if (params[:new_id_truck].present?)
        move_record_truck = MoveRecordTruck.find_by(account_id: @current_user.account_id, move_record_id: params[:move_id])
        move_record_truck.truck_id = params[:new_id_truck]
        if !move_record_truck.save
          format.json { render json: move_record_truck.errors }
        end
      end
      move_record_date = MoveRecordDate.find_by_account_id_and_move_record_id(@current_user.account_id, params[:move_id])
      move_record_date.move_time = params[:start_time]
      if move_record_date.save
        update_contract_name(params[:move_id], @current_user.account_id)
        format.json { render json: move_record_date }
      else
        format.json { render json: move_record_date.errors }
      end
    end
  end

  def move_calendar_update_day
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      move_record_date = MoveRecordDate.find_by_account_id_and_move_record_id_and_id(@current_user.account_id, params[:move_id], params[:date_id])
      move_record_date.move_date = params[:new_day]
      if move_record_date.save
        update_contract_name(params[:move_id], @current_user.account_id)
        format.json { render json: move_record_date }
      else
        format.json { render json: move_record_date.errors }
      end
    end
  end

  def move_calendar_select_truck
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      if (params[:new_id_truck].present?)
        if (params[:resource].present?)
          move_truck_deleted = MoveRecordTruck.find_by(account_id: @current_user.account_id,
                                                       move_record_id: params[:move_id],
                                                       truck_id: params[:resource])
          move_truck_deleted = move_truck_deleted.present? ? move_truck_deleted.destroy : move_truck_deleted
        end
        move_record_truck = MoveRecordTruck.where(account_id: @current_user.account_id,
                                                  move_record_id: params[:move_id]).first_or_create
        move_record_truck.truck_id = params[:new_id_truck]

        move_record = MoveRecordDate.where(account_id: @current_user.account_id,
                                           move_record_id: params[:move_id]).first_or_create
        move_record.move_date = params[:start_time]
        move_record.move_time = params[:start_time]

        book_stage = MoveStatusEmailAlert.where(account_id: @current_user.account_id,
                                                move_record_id: params[:move_id],
                                                contact_stage_id: ContactStage.where(account_id: @current_user.account_id, stage: "Book").pluck(:id).first).first_or_create
        book_stage.user_id = @current_user.id
        if move_record_truck.save && move_record.save && book_stage.save
          update_contract_name(params[:move_id], @current_user.account_id)

          url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

          # book stage log
          message = MessagesMoveRecord.new
          message.account_id = @current_user.account_id
          message.user_id = @current_user.id
          message.subject = 'Contact Stage Book'
          message.body = 'Contact Stage Book'
          message.move_record_id = params[:move_id]
          message.save

          move = MoveRecord.find(params[:move_id])
          ra_email = move.referral2.blank? ? move.move_referral_id : move.referral2

          # book stage auto emails
          name_contact_stage = "Book"
          disabled_stage_emails = []
          disabled_stage_emails = params[:disabled_stage_emails].split(",") if params[:disabled_stage_emails]
          list_email_contact_stage = ContactStage.find_by(account_id: @current_user.account_id, stage: "Book")
          list_email_contact_stage.email_alerts.each do |stage|

            if (stage.auto_send and not disabled_stage_emails.include?(stage.id.to_s))

              if stage.description == "Referral Booking"
                if move.move_source_id == "Referrals" and not ra_email.blank?
                  # save email status
                  move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: params[:move_id], account_id: @current_user.account_id, email_alert_id: stage.id)
                  move_status_email.user_id = @current_user.id
                  move_status_email.save

                  # send email
                  MoverecordMail.stage_mail_sender(params[:move_id], stage.id.to_s, "", "", "", url, ra_email).deliver_later

                  # save log
                  message = MessagesMoveRecord.new
                  message.account_id = @current_user.account_id
                  message.user_id = @current_user.id
                  message.subject = stage.description.to_s + " Email"
                  message.body = "" #stage.template
                  message.move_record_id = params[:move_id]
                  message.message_type = 'email'
                  message.save
                end
              elsif stage.description == "Confirmation"
                MoveRecordJobScheduler.perform_now(params[:move_id], url, @current_user.account_id, @current_user.id)
              elsif stage.description == "Reconfirmation 2"
                # schedule reconfirmation 2 before 2 days of move
                if ((move_record.move_date - Time.now).to_i / 86400) > 4
                  date_send = move_record.move_date - 2.days
                  date_send = ((date_send - Time.now).to_i / 86400) <= 0 ? 1.minute.from_now : date_send
                  MoveRecordReconfirmation2SchedulerJob.set(wait_until: date_send).perform_later(params[:move_id], url, @current_user.account_id, @current_user.id)
                end
              elsif stage.description == "Reconfirmation 7"
                # schedule reconfirmation 7 before 7 days of move
                if ((move_record.move_date - Time.now).to_i / 86400) > 14
                  date_send = move_record.move_date - 7.days
                  date_send = ((date_send - Time.now).to_i / 86400) <= 0 ? 1.minute.from_now : date_send
                  MoveRecordReconfirmation7SchedulerJob.set(wait_until: date_send).perform_later(params[:move_id], url, @current_user.account_id, @current_user.id)
                end
              else
                # rest of emails
                move_status_email = MoveStatusEmailAlert.find_or_initialize_by(move_record_id: params[:move_id], account_id: @current_user.account_id, email_alert_id: stage.id)
                move_status_email.user_id = @current_user.id
                move_status_email.save

                MoverecordMail.stage_mail_sender(params[:move_id], stage.id.to_s, name_contact_stage.gsub('_', ' ').capitalize, @current_user.id, stage.template, url, "").deliver_later

                message = MessagesMoveRecord.new
                message.account_id = @current_user.account_id
                message.user_id = @current_user.id
                message.subject = stage.description.to_s + " Email"
                message.body = "" #stage.template
                message.move_record_id = params[:move_id]
                message.message_type = 'email'
                message.save
              end


                # confirmation mail
                # if ((move_record.move_date - Time.now).to_i / 86400) <= 4
                #   MoveRecordJobScheduler.perform_later(params[:move_id], url, @current_user.account_id, @current_user.id)
                # else
                #   date_send = move_record.move_date - 4.days
                #   date_send = ((date_send - Time.now).to_i / 86400) <= 0 ? 1.minute.from_now : date_send
                #   MoveRecordJobScheduler.set(wait_until: date_send).perform_later(params[:move_id], url, @current_user.account_id, @current_user.id)
                # end

            end
          end

          # expire booked to complete by end of day
          ExpireBookedToComplete.perform_at(move_record.move_date.end_of_day, {account_id: @current_user.account_id, user_id: @current_user.id, move_record: params[:move_id]})


          format.json { render json: true }
        else
          format.json { render json: move_record_date.errors.to_json + move_record.errors.to_json + location_origin.errors.to_json }
        end
      end
    end
  end

  def move_calendar_clone_move
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      if (params[:new_id_truck].present?)
        move_record = MoveRecord.clone_move_record(params[:move_id], @current_user.account_id)
        if move_record
          format.json { render json: true }
        else
          format.json { render json: move_record.errors }
        end
      end
    end
  end

  def calculate_diff_hours(start_time, end_time)
    diff_time = Time.parse(end_time) - Time.parse(start_time)
    hour_time = (diff_time / 60 / 60).floor
    diff_time -= hour_time * 60 * 60
    minutes_time = (diff_time / 60).floor
    return hour_time + ("0." + minutes_time.to_s).to_f
  end

  def move_calendar_update_add_man
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      #move_cost_time = MoveRecordCostHourly.find_by_account_id_and_move_record_id(@current_user.account_id, params[:move_id])
      #actual_job_hours = ( move_cost_time.hours.blank? ? 0 : move_cost_time.hours ).to_f + ( move_cost_time.travel.blank? ? 0 : move_cost_time.travel ).to_f
      move_truck = MoveRecordTruck.where(:account_id => @current_user.account_id, :move_record_id => params[:move_id]).select(:id, :lead, :mover_2, :mover_3, :mover_4, :mover_5, :mover_6).first
      available_movers = move_truck.attributes.find { |v, t| t === nil }
      if available_movers.blank?
        format.json { render json: {error: true, msg: "Maximum movers assigned."} }
      elsif move_truck.attributes.select { |v, t| t.to_s === params[:user_id] }.size > 0
        format.json { render json: {error: true, msg: "Already assigned."} }
      else
        move_truck.update_attributes(available_movers[0] => params[:user_id])
        if move_truck.save
          format.json { render json: move_truck }
        else
          format.json { render json: move_truck.errors }
        end
      end

    end
  end

  def add_reminder_calendar_mover
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      reminder = ReminderCalendarMoveRecord.new
      reminder.account_id = @current_user.account_id
      reminder.user_id = nil
      reminder.author = @current_user.id
      reminder.date = params[:date]
      reminder.truck_id = params[:truck].blank? ? nil : params[:truck]
      reminder.messages_truck_calendar_id = params[:message_truck_calendar_id]
      reminder.calendar_truck_group_id = params[:truck_group]
      if reminder.save
        format.json { render json: reminder }
      else
        format.json { render json: reminder.errors }
      end
    end
  end

  def destroy_reminder_calendar_mover
    #validate_permissions("edit.calendar_move_record") ? '' : return
    respond_to do |format|
      reminder = ReminderCalendarMoveRecord.find_by_id(params[:reminder])
      if reminder.destroy
        format.json { render json: reminder }
      else
        format.json { render json: reminder.errors }
      end
    end
  end

  def validate_man_truck_information(information, field)
    information.find { |v| v.id == field }.present? ? information.find { |v| v.id == field }.email : nil
  end

  def update_contract_name(move_id, account_id)
    move_record = MoveRecord.find_by_account_id_and_id(account_id, move_id)
    move_record.move_contract_name = MoveRecord.contract_name_format(move_record.move_record_client.first.client.name,
                                                                     move_record.move_record_date.first.move_date,
                                                                     move_record.move_record_location_origin.first.location.calendar_truck_group_id.blank? ? "" : move_record.move_record_location_origin.first.location.calendar_truck_group.name,
                                                                     move_record.id)
    move_record.move_contract_number = move_id
    move_record.save
  end

  def move_calendar_staff
    mover_roles = Role.where("roles.name = ? or roles.name = ? or roles.name = ?", "Mover", "Owner Operator", "Swamper").where(account_id: @current_user.account_id, active: true)
    @users = RoleUser.where(account_id: @current_user.account_id, role_id: mover_roles.map(&:id)).includes(:user)

    respond_to do |format|
      staff_available = StaffAvailable.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? and user_id in (?) ",
                                             params[:start].to_date.beginning_of_day, params[:start].to_date.end_of_day,
                                             @current_user.account_id, @users.map { |v| v.user })
      move_record_available = MoveStatusEmailAlert.where(contact_stage_id: ContactStage.where(account_id: @current_user.account_id, stage: "Book").pluck(:id).first, move_record_id: MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? and move_record_id in (?)", params[:start].to_date.beginning_of_day, params[:start].to_date.end_of_day, @current_user.account_id, MoveRecordLocationOrigin.where(location_id: Location.where(calendar_truck_group_id: params[:group]).select(:id)).map { |v| v.move_record_id }).select(:move_record_id)).where("email_alert_id IS NOT NULL")
      unless move_record_available.blank?
        move_truck = MoveRecordTruck.where(:account_id => @current_user.account_id, :move_record_id => move_record_available.map { |v| v.move_record_id }).select(:id, :move_record_id, :lead, :mover_2, :mover_3, :mover_4, :mover_5, :mover_6)
      else
        move_truck = []
      end
      list_available = []

      @users.each do |temp_user|
        staff_color = 'gray'
        move_record_user = move_truck.blank? ? [] : move_truck.select { |v, t| v.lead === temp_user.user_id || v.mover_2 === temp_user.user_id || v.mover_3 === temp_user.user_id || v.mover_4 === temp_user.user_id || v.mover_5 === temp_user.user_id || v.mover_6 === temp_user.user_id }
        staff_available_user = staff_available.select { |v| (v.user_id == temp_user.user_id) }
        color_gray_bold = 0
        color_red = 0
        color_yellow = 0
        move_record_user.each do |temp_space|
          move = temp_space.move_record
          half_travel = move.move_record_cost_hourly.travel.to_f / 2
          end_time = DateTime.parse((move.move_record_date.first.estimation_time.blank? ?
              move.move_record_date.first.move_time + 0.25.hours : move.move_record_date.first.move_time).strftime("%I:%M %p")) + move.move_record_date.first.estimation_time.to_f.hours
          start_add_travel = DateTime.parse(move.move_record_date.first.move_date.strftime("%Y-%m-%d") + ' ' +
                                                ((Time.parse(move.move_record_date.first.move_time.strftime("%I:%M %p")) - half_travel.hours).strftime("%I:%M %p").to_s))


          stop_add_travel = DateTime.parse(move.move_record_date.first.move_date.strftime("%Y-%m-%d") + ' ' +
                                               ((Time.parse((end_time + half_travel.hours).to_s).strftime("%I:%M %p").to_s)))

          staff_available_user_temp = staff_available_user.select { |v| (v.start_time <= start_add_travel && v.end_time >= start_add_travel) ||
              (v.start_time <= stop_add_travel && v.end_time >= stop_add_travel)
          }
          if (staff_available_user.select { |v| (v.start_time < start_add_travel && v.end_time < start_add_travel) ||
              (v.start_time > start_add_travel && v.end_time > start_add_travel) ||
              (v.start_time < stop_add_travel && v.end_time < stop_add_travel) ||
              (v.start_time > stop_add_travel && v.end_time > stop_add_travel)
          }.size > 0)
            color_red += 1
          end
          if (staff_available_user_temp.size > 0)
            if (staff_available_user_temp.select { |v| (v.available === true) }.size == staff_available_user_temp.size)
              color_gray_bold += 1
            elsif (staff_available_user_temp.select { |v| (v.available === false) }.size <= staff_available_user_temp.size)
              color_red += 1
            else
              color_yellow += 1
            end
          else
            color_yellow += 1
          end
        end

        if color_red >= 1
          staff_color = 'text-red'
        elsif color_yellow >= 1
          staff_color = 'text-red'
        elsif color_gray_bold >= 1
          staff_color = 'text-gray-bold'
        end

        available_time = staff_available_user.select { |v| (v.available === true) }.size > 0
        unavailable_time = staff_available_user.select { |v| (v.available === false) }.size > 0

        list_available.push(name: mover_display_name(temp_user.user.name),
                            color: staff_color,
                            id: temp_user.user_id,
                            available: unavailable_time || !available_time || staff_available_user.size == 0 ? 'text-red' : 'text-green')
      end

      format.json { render json: {list: list_available, total_movers: list_available.select { |v| (v[:color] === 'text-gray' || v[:color] === 'text-green') }.size, total_availables: list_available.select { |v| (v[:color] === 'text-green') }.size} }
    end
  end
end
