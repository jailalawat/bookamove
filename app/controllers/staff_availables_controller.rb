class StaffAvailablesController < ApplicationController
  before_filter :current_user
  around_action :utc_time_zone

  def index
    staff_param = params[:staff].present? ? User.find(params[:staff]).name : @current_user.name
    @title_page = staff_param + ' Availability'
  end

  def calendar_staff_event
    staff_param = params[:staff].present? ? params[:staff] : @current_user.id
    start_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.beginning_of_month : params[:start]
    end_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.end_of_month : params[:end]

    staff_available = StaffAvailable.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
                          .where(user_id: staff_param)
    staff_truck = MoveRecordTruck.where('lead=? OR mover_2=? OR mover_3=? OR mover_4=? OR mover_5=? OR mover_6=?',
                                        staff_param, staff_param, staff_param, staff_param, staff_param, staff_param)
    move_record = MoveRecordDate.where("DATE(move_date) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
                      .where(move_record_id: staff_truck.map { |v| v.move_record_id.to_i })
    subtask_group = TaskAvailableCalendar.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
                        .where(user_id: staff_param).includes(:subtask_staff_group)
    reminder = ReminderCalendarPersonal.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id)
                   .where(user_id: staff_param)

    reminders = []
    reminder.each do |temp_reminder|
      reminders.push(title: 'Reminder',
                     start: temp_reminder.date,
                     :end => temp_reminder.date + 15.minutes,
                     type: 'reminder',
                     editable: false,
                     subject: ActionController::Base.helpers.truncate(temp_reminder.messages_personal_calendar.subject, length: 15),
                     comment: ActionController::Base.helpers.truncate(temp_reminder.messages_personal_calendar.body, length: 15) +
                         (' <span class="more-reminder pointer" data-link-message="' + temp_reminder.messages_personal_calendar_id.to_s + '"> more</span>'))
    end

    staff_event = []
    staff_available.each do |staff|
      staff_event.push(staff_time_id: staff.id,
                       title: staff.available ? 'Available' : 'Unavailable',
                       start: staff.start_time.to_s,
                       :end => staff.end_time.to_s,
                       className: staff.available ? 'btn btn-success' : 'btn btn-danger',
                       type: 'staff_available')
    end

    respond_to do |format|
      format.json { render json: staff_event + reminders }
    end
  end


  def update_staff_available_time
    respond_to do |format|
      staff_available = StaffAvailable.new
      staff_available.account_id = @current_user.account_id
      staff_available.user_id = params[:staff].blank? ? @current_user.id : params[:staff]
      staff_available.start_time = params[:start_time]
      staff_available.end_time = params[:end_time]
      staff_available.available = params[:available]
      if staff_available.save
        format.json { render json: staff_available }
      else
        format.json { render json: staff_available.errors }
      end
    end
  end

  def destroy_staff_available_time
    respond_to do |format|
      staff_available = StaffAvailable.find(params[:staff_time_id])
      if staff_available.destroy
        format.json { render json: staff_available }
      else
        format.json { render json: staff_available.errors }
      end
    end
  end

end
