class MessagesTaskCalendarsController < ApplicationController
  before_filter :current_user

  def index_messages
    if params[:date_calendar].present?
      @all_messages = MessagesTaskCalendar.where(account_id: @current_user.account_id, :calendar_staff_group_id => params[:group])
                          .where(:date_calendar => params[:date_calendar].to_date.beginning_of_month..params[:date_calendar].to_date.end_of_month)
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
      @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
      if (params[:respond_html])
        respond_to do |format|
          format.json { render partial: 'messages_task_calendars/index', locals: {subject_suggestions: @subject_suggestions, all_messages: @all_messages}, :formats => [:html] }
        end
      end
    end
  end

  def create
    @message = MessagesTaskCalendar.new
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = params[:subject]
    @message.urgent = params[:urgent]
    @message.calendar_staff_group_id = params[:task_calendar]
    @message.body = params[:body]
    @message.date_calendar = params[:date_calendar]
    respond_to do |format|
      if @message.save
        params[:to] ||= []
        params[:to].each do |temp_data|
          if (temp_data.match(/staff_all/))
            @all_staff_users.each do |user|
              u_messages = UserMessageTaskCalendar.new
              u_messages.account_id = @message.account_id
              u_messages.user_id = user.id
              u_messages.messages_task_calendar_id = @message.id
              u_messages.readed = false
              u_messages.save
            end
          end

          if (temp_data.match(/staff_\d+/))
            u_messages = UserMessageTaskCalendar.new
            u_messages.user_id = temp_data.gsub('staff_', '').to_i
            u_messages.messages_task_calendar_id = @message.id
            u_messages.account_id = @message.account_id
            u_messages.readed = false
            u_messages.save
          end

          if (temp_data.match(/task_\d+/))
            u_messages = TaskMessageTaskCalendar.new
            u_messages.subtask_staff_group_id = temp_data.gsub('task_', '').to_i
            u_messages.messages_task_calendar_id = @message.id
            u_messages.account_id = @message.account_id
            u_messages.readed = false
            u_messages.save
          end

        end

        params[:file] ||= []
        params[:file].each do |file|
          file = upload_attachment(file)
          attachment = TaskCalendarAttachment.new
          attachment.messages_task_calendar_id = @message.id
          attachment.file_path = file[:url]
          attachment.name = file[:name]
          attachment.account_id = @message.account_id
          attachment.save
        end
        format.json { render json: @message }
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_attachment(file_param)
    name = (rand() * 4).to_s + '_' + Time.now.to_i.to_s + '_' + file_param.original_filename
    return {url: upload_bucket_file(file_param, name, 'mmo-attachments-dev'), name: name}
  end

end
