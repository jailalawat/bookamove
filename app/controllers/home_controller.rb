class HomeController < ApplicationController
  include MessagesHelper
  before_filter :current_user

  def index
    @page_title = ("<i class='icon-dashboard blank3 blue-text'></i>" + "Dashboard").html_safe

    # My mail
    get_personal_messages()

    # Calendar
    @reminders = []

    reminder_personal = ReminderCalendarPersonal.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ",
                                                       DateTime.now.midnight.to_s(:db),
                                                       DateTime.now.end_of_day.to_s(:db),
                                                       @current_user.account_id)
                            .where(user_id: @current_user.id)
                            .order(date: :desc)
    reminder_move = ReminderCalendarMoveRecord.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", DateTime.now.midnight.to_s(:db), DateTime.now.end_of_day.to_s(:db), @current_user.account_id)
                        .where("user_id=? OR user_id is null", @current_user.id).order(date: :desc)
    reminder_task = ReminderCalendarTask.where("DATE(date) BETWEEN ? AND ? AND account_id = ? ", DateTime.now.midnight.to_s(:db), DateTime.now.end_of_day.to_s(:db), @current_user.account_id)
                        .where("user_id=? OR user_id is null", @current_user.id).order(date: :desc)
    @reminders = reminder_personal + reminder_move + reminder_task
  end
end
