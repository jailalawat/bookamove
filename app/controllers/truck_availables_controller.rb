class TruckAvailablesController < ApplicationController
  before_filter :current_user
  around_action :utc_time_zone

  def index
    @truck_name = Truck.where(account_id: @current_user.account_id, id: params[:truck])
    @title_page = @truck_name[0].description
  end

  def calendar_truck_event
    start_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.beginning_of_month : params[:start]
    end_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.end_of_month : params[:end]
    truck_available = TruckAvailable.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id)
                          .where(truck_id: params[:truck_id])

    reminder = ReminderCalendarTruck.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id)
                   .where(truck_id: params[:truck_id])

    truck_time = []
    truck_available.each do |truck|
      truck_time.push(truck_time_id: truck.id,
                      title: truck.available ? 'Available' : 'Unavailable',
                      start: truck.start_time.to_s,
                      :end => truck.end_time.to_s,
                      className: truck.available ? 'btn btn-success' : 'btn btn-danger',
                      type: 'truck_available')
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
      format.json { render json: truck_time + reminders }
    end
  end


  def update_truck_available_time
    respond_to do |format|
      truck_available = TruckAvailable.new
      truck_available.account_id = @current_user.account_id
      truck_available.truck_id = params[:truck_id]
      truck_available.start_time = params[:start_time]
      truck_available.end_time = params[:end_time]
      truck_available.available = params[:available]
      if truck_available.save
        format.json { render json: truck_available }
      else
        format.json { render json: truck_available.errors }
      end
    end
  end

  def destroy_truck_available_time
    respond_to do |format|
      truck_available = TruckAvailable.find(params[:truck_time_id])
      if truck_available.destroy
        format.json { render json: truck_available }
      else
        format.json { render json: truck_available.errors }
      end
    end
  end

end
