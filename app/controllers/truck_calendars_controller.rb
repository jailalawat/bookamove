class TruckCalendarsController < ApplicationController
  before_filter :current_user
  before_action :title_page

  def index
    #validate_permissions("show.personal_calendar") ? '' : return
  end

  def title_page
    @title_page = 'My Truck'
  end

  def truck_calendar_event
    staff_subtask = []
    move_record = []
    start_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.beginning_of_month : params[:start]
    end_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.end_of_month : params[:end]
    if (params[:available].present?)
      staff_truck = []
      move_record = []
    elsif (params[:truck_id].present?)
      staff_truck = MoveRecordTruck.where(truck_id: params[:truck_id])
                        .where('lead=? OR mover_2=? OR mover_3=? OR mover_4=? OR mover_5=? OR mover_6=?',
                               @current_user.id, @current_user.id, @current_user.id, @current_user.id, @current_user.id, @current_user.id)
      move_record = MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
                        .where(move_record_id: staff_truck.map { |v| v.move_record_id.to_i })
    else
      staff_truck = MoveRecordTruck.where(truck_id: @current_user.driver.id, account_id: @current_user.account_id)
      move_record = MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
                        .where(move_record_id: staff_truck.map { |v| v.move_record_id.to_i })
      reminder = ReminderCalendarTruck.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id)
                     .where(truck_id: @current_user.driver.id)
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
      move_cost_time = MoveRecordCostHourly.find_by_account_id_and_move_record_id(@current_user.account_id, move[:move_record_id])
      move_truck = MoveRecordTruck.where(account_id: @current_user.account_id, move_record_id: move[:move_record_id]).first
      date_move = move.move_date.to_date.to_s
      half_travel = move_cost_time.travel.to_f / 2
      end_time = DateTime.parse((move.estimation_time.blank? ? move.move_time + 0.25.hours : move.move_time).strftime("%I:%M %p")) + move.estimation_time.to_f.hours
      start_add_travel = DateTime.parse(move.move_time.strftime("%I:%M %p")) - half_travel.hours
      stop_add_travel = end_time + half_travel.hours
      movers_move = move_truck.attributes.slice("lead", "mover_2", "mover_3", "mover_4", "mover_5", "mover_6").compact

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

      last_stage = ContactStage.where(account_id: @current_user.account_id, id: move_stage.contact_stage_id).first
      current_move_stage = last_stage.stage || last_stage.sub_stage

      movers.push(title: move_client.present? ? move_client.map { |v| v.client.name } : move_temp.move_type_detail,
                  current_alert: move_temp.move_type_alert_id,
                  all_alerts: all_alerts,
                  start: date_move + ' ' + start_add_travel.strftime("%I:%M %p"),
                  :end => date_move + ' ' + stop_add_travel.strftime("%I:%M %p"),
                  date_id: move.id,
                  move_id: move_temp.id,
                  url_move: edit_move_record_path(move_temp),
                  description: move_temp.move_type_detail,
                  className: (move_stage.present? ? color_stages[0][current_move_stage] : '').to_s + ' move-record-static-link',
                  resources: move_truck.truck_id,
                  truck_names: {truck: move_truck.truck.description, movers: movers_move.map { |v, t| mover_display_name(User.find(t).name) }.join(', ')},
                  half_travel: half_travel,
                  type: 'move_record',
                  overlap: false)
    end

    unavailable = []
    @current_user.driver.truck_available.each do |time|
      unavailable.push(
          start: time.start_time.to_s,
          :end => time.end_time.to_s,
          rendering: 'background',
          className: 'opacity-event ' + (time.available ? 'available-calendar' : 'unavailable-calendar'),
          editable: false,
          type: 'background')
    end

    reminders = []
    reminder.each do |temp_reminder|
      reminders.push(title: 'Reminder',
                     start: temp_reminder.date,
                     :end => temp_reminder.date + 15.minutes,
                     type: 'reminder',
                     editable: false,
                     subject: ActionController::Base.helpers.truncate(temp_reminder.messages_truck_available_calendar.subject, length: 15),
                     comment: ActionController::Base.helpers.truncate(temp_reminder.messages_truck_available_calendar.body, length: 15) +
                         (' <span class="more-reminder pointer" data-link-message="' + temp_reminder.messages_truck_available_calendar_id.to_s + '"> more</span>'))
    end
    respond_to do |format|
      format.json { render json: movers + unavailable + reminders }
      #format.json { render json: staffavailable + movers + reminders }
    end
  end

  def mover_display_name(name)
    user_info = name.split
    client = user_info[0][0..3].capitalize + (user_info[1].present? ? user_info[1][0].capitalize : '')
  end

  def add_reminder_truck_calendar
    respond_to do |format|
      reminder = ReminderCalendarTruck.new
      reminder.account_id = @current_user.account_id
      reminder.truck_id = params[:truck_id].present? ? params[:truck_id] : @current_user.driver.id
      reminder.user_id = @current_user.id
      reminder.date = params[:date]
      reminder.messages_truck_available_calendar_id = params[:message_truck_calendar_id]
      if reminder.save
        format.json { render json: reminder }
      else
        format.json { render json: reminder.errors }
      end
    end
  end

  def index_messages
    @all_messages = MessagesTruckAvailableCalendar.where(account_id: @current_user.account_id, :truck_id => @current_user.driver.id)
                        .where(:date_calendar => params[:date_calendar_start]..params[:date_calendar_end])
                        .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
    @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
    if (params[:respond_html])
      respond_to do |format|
        format.json { render partial: 'messages_truck_available_calendars/index', locals: {subject_suggestions: @subject_suggestions, all_messages: @all_messages}, :formats => [:html] }
      end
    end
  end
end
