class CalendarTasksController < ApplicationController
  before_filter :current_user
  around_action :utc_time_zone

  def index
    #validate_permissions("show.calendar_tasks") ? '' : return
    @calendar_trucks = []
    @calendar_groups = CalendarStaffGroup.where(account_id: @current_user.account_id, active: 1)
    @group_selected = params[:group]
    if (params[:group].present?)
      @calendar_subtask = SubtaskStaffGroup.where(account_id: @current_user.account_id, calendar_staff_group_id: params[:group])
    end
  end

  def task_calendar_event
    #validate_permissions("show.calendar_tasks") ? '' : return
    reminders = []
    start_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.beginning_of_month : params[:start]
    end_date_reminder = params[:date_reminder].present? ? params[:date_reminder].to_date.end_of_month : params[:end]
    if (params[:task_id].present?)
      subtask_staff = StaffTask.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id).where(subtask_staff_group_id: params[:task_id])
      reminder = ReminderCalendarTask.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id).where(subtask_staff_group_id: params[:task_id])
    else
      subtask_group = SubtaskStaffGroup.where(account_id: @current_user.account_id, calendar_staff_group_id: params[:group_id])
      subtask_staff = StaffTask.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? ", params[:start], params[:end], @current_user.account_id).where(subtask_staff_group_id: subtask_group.map { |v| v.id })
      reminder = ReminderCalendarTask.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", start_date_reminder, end_date_reminder, @current_user.account_id)
    end
    reminders = []
    reminder.each do |temp_reminder|
      reminders.push(title: 'Reminder',
                     start: temp_reminder.date,
                     :end => temp_reminder.date + 15.minutes,
                     type: 'reminder',
                     editable: false,
                     subject: ActionController::Base.helpers.truncate(temp_reminder.messages_task_calendar.subject, length: 15),
                     comment: ActionController::Base.helpers.truncate(temp_reminder.messages_task_calendar.body, length: 15) + (' <span class="more-reminder pointer" data-link-message="' + temp_reminder.messages_task_calendar_id.to_s + '"> more</span>'),
                     resources: temp_reminder.subtask_staff_group_id.blank? ? nil : temp_reminder.subtask_staff_group_id)
    end

    staffavailable = []
    subtask_group.each do |list_subtask|
      subtask_times = list_subtask.task_available_calendar
      subtask_times.each do |time|
        staffavailable.push(
            start: time.start_time.to_s,
            :end => time.end_time.to_s,
            name: (time.user.blank? ? 'empty' : mover_display_name(time.user.name)),
            resources: time.subtask_staff_group_id,
            className: 'available-task-calendar',
            editable: false,
            taskAvailable: time.id,
            type: 'task-available',
            overlap: false,
            task_available_id: time.id,
            description: time.description,
            notes: time.notes)
      end
    end

    respond_to do |format|
      format.json { render json: reminders + staffavailable }
    end
  end

  def task_calendar_resources
    #validate_permissions("show.calendar_tasks") ? '' : return
    calendar_resource_tasks = []
    if params[:group]
      @calendar_groups = CalendarStaffGroup.where(account_id: @current_user.account_id, active: 1)
      @calendar_subtask = SubtaskStaffGroup.where(account_id: @current_user.account_id, calendar_staff_group_id: params[:group])
      @calendar_subtask.each do |calendar_single_task|
        calendar_resource_tasks.push(id: calendar_single_task.id, name: calendar_single_task.name, className: 'task-id-' + calendar_single_task.id.to_s)
      end
    end

    blank_resource = (6 - calendar_resource_tasks.size.to_i)
    blank_resource.to_i.times do |i|
      calendar_resource_tasks.push(id: '', name: '', className: 'gray-disabled')
    end
    respond_to do |format|
      format.json { render json: calendar_resource_tasks }
    end
  end

  def add_staff_calendar_task
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      subtask_staff = StaffTask.new
      subtask_staff.account_id = @current_user.account_id
      subtask_staff.user_id = params[:user]
      subtask_staff.subtask_staff_group_id = params[:subtask]
      subtask_staff.start_time = params[:start_time]
      subtask_staff.end_time = params[:end_time]
      subtask_staff.rate = params[:rate]
      subtask_staff.hours = calculate_diff_hours(params[:start_time], params[:end_time])
      subtask_staff.total_pay = (params[:rate].to_f * subtask_staff.hours.to_f)
      if subtask_staff.save
        format.json { render json: subtask_staff }
      else
        format.json { render json: subtask_staff.errors }
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

  def task_calendar_update_day
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      subtask_staff = StaffTask.find_by(account_id: @current_user.account_id, id: params[:staff_task_id])
      subtask_staff.start_time = params[:start_time]
      subtask_staff.end_time = params[:end_time]
      if subtask_staff.save
        format.json { render json: subtask_staff }
      else
        format.json { render json: subtask_staff.errors }
      end
    end
  end

  def task_calendar_update_time
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      subtask_staff = StaffTask.find_by(account_id: @current_user.account_id, id: params[:staff_task_id])
      subtask_staff.start_time = params[:start_time]
      subtask_staff.end_time = params[:end_time]
      subtask_staff.subtask_staff_group_id = params[:new_id_subtask]
      subtask_staff.hours = calculate_diff_hours(params[:start_time], params[:end_time])
      subtask_staff.total_pay = (subtask_staff.rate.to_f * subtask_staff.hours.to_f)
      if subtask_staff.save
        format.json { render json: subtask_staff }
      else
        format.json { render json: subtask_staff.errors }
      end
    end
  end

  def task_calendar_update_information
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      subtask_staff = StaffTask.find_by(account_id: @current_user.account_id, id: params[:staff_task_id])
      subtask_staff.rate = params[:rate]
      subtask_staff.total_pay = (params[:rate] * subtask_staff.hours.to_f)
      if subtask_staff.save
        format.json { render json: subtask_staff }
      else
        format.json { render json: subtask_staff.errors }
      end
    end
  end

  def destroy_staff_calendar_task
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      subtask_staff = StaffTask.find_by(account_id: @current_user.account_id, id: params[:staff_task_id])
      if subtask_staff.destroy
        format.json { render json: subtask_staff }
      else
        format.json { render json: subtask_staff.errors }
      end
    end
  end

  def add_reminder_calendar_task
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      reminder = ReminderCalendarTask.new
      reminder.account_id = @current_user.account_id
      reminder.user_id = nil
      reminder.author = @current_user.id
      reminder.date = params[:date]
      reminder.subtask_staff_group_id = params[:task].blank? ? nil : params[:task]
      reminder.messages_task_calendar_id = params[:message_task_calendar_id]
      reminder.calendar_staff_group_id = params[:truck_group]

      if reminder.save
        format.json { render json: reminder }
      else
        format.json { render json: reminder.errors }
      end
    end
  end

  def destroy_reminder_calendar_task
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      reminder = ReminderCalendarTask.find_by_id(params[:reminder])
      if reminder.destroy
        format.json { render json: reminder }
      else
        format.json { render json: reminder.errors }
      end
    end
  end

  def move_calendar_staff
    staff_roles = Role.where("roles.name != ? and roles.name != ? and roles.name != ? and roles.name != ?", "mover", "Owner Operator", "Swamper", "Customer").where(account_id: @current_user.account_id, active: true)
    @users = RoleUser.where(account_id: @current_user.account_id, role_id: staff_roles.map(&:id)).includes(:user)

    respond_to do |format|
      staff_available = StaffAvailable.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? and user_id in (?) ",
                                             params[:start].to_date.beginning_of_day, params[:start].to_date.end_of_day,
                                             @current_user.account_id, @users.map { |v| v.user })

      task_available = TaskAvailableCalendar.where("DATE(start_time) BETWEEN ? AND ? AND account_id = ? and user_id IS NOT NULL",
                                                   params[:start].to_date.beginning_of_day,
                                                   params[:start].to_date.end_of_day, @current_user.account_id)
      list_available = []
      @users.each do |temp_user|
        staff_color = 'gray'
        task_available_user = task_available.select { |v| (v.user_id == temp_user.user_id) }
        staff_available_user = staff_available.select { |v| (v.user_id == temp_user.user_id) }
        color_gray_bold = 0
        color_red = 0
        color_yellow = 0
        task_available_user.each do |temp_space|
          staff_available_user_temp = staff_available_user.select { |v| (v.start_time <= temp_space.start_time && v.end_time >= temp_space.start_time) ||
              (v.start_time <= temp_space.end_time && v.end_time >= temp_space.end_time)
          }
          if (staff_available_user.select { |v| (v.start_time < temp_space.start_time && v.end_time < temp_space.start_time) ||
              (v.start_time > temp_space.start_time && v.end_time > temp_space.start_time) ||
              (v.start_time < temp_space.end_time && v.end_time < temp_space.end_time) ||
              (v.start_time > temp_space.end_time && v.end_time > temp_space.end_time)
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
          staff_color = 'text-yellow'
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
      format.json { render json: {list: list_available,
                                  total_movers: list_available.select { |v| (v[:color] === 'text-gray' || v[:color] === 'text-green') }.size,
                                  total_availables: list_available.select { |v| (v[:color] === 'text-green') }.size} }
    end
  end

  def mover_display_name(name)
    user_info = name.split
    client = user_info[0][0..3].capitalize + (user_info[1].present? ? user_info[1][0].capitalize : '')
  end

  def task_calendar_available_time
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      task_available_time = TaskAvailableCalendar.new
      task_available_time.account_id = @current_user.account_id
      task_available_time.author = @current_user.id
      task_available_time.start_time = params[:start_time]
      task_available_time.end_time = params[:end_time]
      task_available_time.subtask_staff_group_id = params[:subtask_id]
      if task_available_time.save
        format.json { render json: task_available_time }
      else
        format.json { render json: task_available_time.errors }
      end
    end
  end

  def update_task_calendar_available_time
    #validate_permissions("edit.calendar_tasks") ? '' : return
    respond_to do |format|
      task_available_time = TaskAvailableCalendar.find(params[:task_available_time])
      task_available_time.user_id = params[:user_id]
      if task_available_time.save
        format.json { render json: task_available_time }
      else
        format.json { render json: task_available_time.errors }
      end
    end
  end

  def destroy_task_available_time
    respond_to do |format|
      truck_available = TaskAvailableCalendar.find(params[:task_available_time])
      if truck_available.destroy
        format.json { render json: truck_available }
      else
        format.json { render json: truck_available.errors }
      end
    end
  end
end
