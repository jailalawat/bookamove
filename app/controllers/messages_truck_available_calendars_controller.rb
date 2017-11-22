class MessagesTruckAvailableCalendarsController < ApplicationController
  before_filter :current_user

  def index_messages
    @all_messages = MessagesTruckAvailableCalendar.where(account_id: @current_user.account_id, :truck_id => params[:truck])
                        .where(:date_calendar => params[:date_calendar_start]..params[:date_calendar_end])
                        .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
    @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
    if (params[:respond_html])
      respond_to do |format|
        format.json { render partial: 'messages_truck_available_calendars/index', locals: {subject_suggestions: @subject_suggestions, all_messages: @all_messages}, :formats => [:html] }
      end
    end
  end

  def create
    @message = MessagesTruckAvailableCalendar.new
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = params[:subject]
    @message.urgent = params[:urgent]
    @message.truck_id = params[:truck].present? ? params[:truck] : @current_user.driver.id
    @message.body = params[:body]
    @message.date_calendar = params[:date_calendar]
    respond_to do |format|
      if @message.save
        format.json { render json: @message }
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

end
