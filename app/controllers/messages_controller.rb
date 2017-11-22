class MessagesController < ApplicationController
  include MessagesHelper
  before_filter :current_user, :title_page

  def index
    @page_title = ("<i class='icon-envelope blank3 blue-text'></i>" + "My Mail").html_safe

    get_personal_messages()

    @type = params[:type]
    @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
  end

  def title_page
    @title_page = params[:type].present? ? params[:type].titleize : ''
  end

  def create
    @message = Message.new
    @message.account_id = @current_user.account_id
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = params[:subject]
    @message.urgent = params[:urgent]
    @message.body = params[:template_mail].present? ? (!params[:template_mail].blank? ? params[:template_mail] : params[:body]) : params[:body]
    respond_to do |format|
      if @message.save
        params[:to].each do |user|
          if (user.match(/staff_all/))
            @all_staff_users.each do |user|
              u_messages = UserMessage.new
              u_messages.account_id = @message.account_id
              u_messages.user_id = user.id
              u_messages.message_id = @message.id
              u_messages.readed = false
              u_messages.save
            end
          end

          if (user.match(/staff_\d+/))
            u_messages = UserMessage.new
            u_messages.account_id = @message.account_id
            u_messages.user_id = user.gsub('staff_', '').to_i
            u_messages.message_id = @message.id
            u_messages.readed = false
            u_messages.save
          end

          if (user.match(/task_\d+/))
            @message_task = MessagesTask.new
            @message_task.account_id = @current_user.account_id
            @message_task.user_id = @current_user.id
            @message_task.subtask_staff_group_id = user.gsub('task_', '').to_i
            @message_task.subject = @message.subject
            @message_task.urgent = @message.urgent
            @message_task.body = @message.body
            @message_task.save

            user_task = StaffTask.where(subtask_staff_group_id: @message_task.subtask_staff_group_id, account_id: @message_task.account_id)

            user_task.each do |user|
              u_messages = UserMessagesTask.new
              u_messages.account_id = @message_task.account_id
              u_messages.user_id = user.user_id
              u_messages.messages_task_id = @message_task.id
              u_messages.readed = false
              u_messages.save
            end
          end

        end
        params[:file] ||= []
        params[:file].each do |file|
          file = upload_attachment(file)
          attachment = MessageAttachment.new
          attachment.message_id = @message.id
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

  def update_readed_message
    message = UserMessage.where(message_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first if params[:message_type] == 'personal'
    message = UserMessagesMoveRecord.where(messages_move_record_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first if params[:message_type] == 'move_record'
    message = UserMessageTruckCalendar.where(messages_truck_calendar_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first if params[:message_type] == 'truck_calendar'
    message.readed = true
    respond_to do |format|
      if message.save
        format.json { render json: true }
        UserMessage.update_readed_notification(message) if params[:message_type] == 'personal'
        UserMessagesMoveRecord.update_readed_notification(message) if params[:message_type] == 'move_record'
        UserMessageTruckCalendar.update_readed_notification(message) if params[:message_type] == 'truck_calendar'
      else
        format.json { render json: message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_message
    # delete
    if params[:hard_delete]
      message = TaskMessagesMoveRecord.where(messages_move_record_id: params[:message_id], account_id: @current_user.account_id).first if params[:message_type] == 'task_move_record'

      respond_to do |format|
        if message.destroy
          format.json { render json: true }
        else
          format.json { render json: message.errors, status: :unprocessable_entity }
        end
      end

    # only trash status
    else
      message = UserMessage.where(message_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first if params[:message_type] == 'personal'
      message = UserMessagesMoveRecord.where(messages_move_record_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first if params[:message_type] == 'move_record'
      message = UserMessageTruckCalendar.where(messages_truck_calendar_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first if params[:message_type] == 'truck_calendar'
      message.trash = true

      respond_to do |format|
        if message.save
          format.json { render json: true }
          UserMessage.update_trash_notification(message) if params[:message_type] == 'personal'
          UserMessagesMoveRecord.update_trash_notification(message) if params[:message_type] == 'move_record'
          UserMessageTruckCalendar.update_trash_notification(message) if params[:message_type] == 'truck_calendar'
        else
          format.json { render json: message.errors, status: :unprocessable_entity }
        end
      end

    end
  end

  def add_reply_message
    #validate the user cant auto-reply their messages
    #message_reply = Message.where('parent_id= ? OR id= ?', params[:message_id], params[:message_id]).where.not( user_id: @current_user.id).last
    message_reply = Message.find_by_id(params[:message_id])
    @message = Message.new
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = 'Re: ' + message_reply.subject
    @message.parent_id = params[:message_id]
    @message.body = params[:body]
    respond_to do |format|
      if @message.save
        u_messages = UserMessage.new
        u_messages.account_id = @message.account_id
        u_messages.user_id = message_reply.user_id
        u_messages.message_id = @message.id
        u_messages.readed = false
        u_messages.save
        params[:file] ||= []
        params[:file].each do |file|
          file = upload_attachment(file)
          attachment = MessageAttachment.new
          attachment.message_id = @message.id
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

  def mark_message
    message = params[:mark_type] === 'personal' ? UserMessage.where(message_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first :
        (params[:message_type] === 'move_record' ? UserMessagesMoveRecord.where(messages_move_record_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first :
            UserMessageTruckCalendar.where(messages_truck_calendar_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first)

    message.marked = params[:unmarked]
    respond_to do |format|
      if message.save
        format.json { render json: message }
      else
        format.json { render json: message.errors, status: :unprocessable_entity }
      end
    end
  end

end
