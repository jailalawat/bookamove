class MessagesTasksController < ApplicationController
  before_filter :current_user
  before_filter :security

  def security
    @role_level >= SubtaskStaffGroup.where(id: params[:task], account_id: @current_user.account_id).pluck("role_level").join.to_i ? '' : unauthorized
  end

  def index
    @full_messages = []
    if (params[:type] == 'inbox')
      @all_messages = MessagesTask.where(account_id: @current_user.account_id, subtask_staff_group_id: params[:task], id: UserMessagesTask.where(account_id: @current_user.account_id, user_id: @current_user.id).select(:messages_task_id)).order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc)).select(:id, :parent_id, :created_at)

      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages.push({
                                  main: get_parent_message(info_message.id),
                                  reply: [],
                                  type: 'task',
                                  created_at: info_message.created_at
                              })
        end
      end

      @full_messages_move_record = []
      @all_messages = MessagesMoveRecord.where(account_id: @current_user.account_id, id: TaskMessagesMoveRecord.where(account_id: @current_user.account_id, subtask_staff_group_id: params[:task]).select(:messages_move_record_id))
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                          .select(:id, :parent_id, :created_at)
      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages_move_record.push({main: get_parent_message_move_record(info_message.id),
                                           reply: [],
                                           type: 'task_move_record',
                                           created_at: info_message.created_at})
        end
      end
      @full_messages_move_record = @full_messages_move_record.uniq { |e| e[:main] }
      @full_messages = @full_messages.uniq { |e| e[:main] }
      @full_messages = @full_messages + @full_messages_move_record
      @full_messages = (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? @full_messages.sort { |a, b| a[:created_at] <=> b[:created_at] } : @full_messages.sort { |a, b| b[:created_at] <=> a[:created_at] }) : @full_messages.sort { |a, b| b[:created_at] <=> a[:created_at] })
    end

=begin
    if(params[:type] == 'sent')
      if(params[:search].present?)
        @all_messages = MessagesTask.where(account_id: @current_user.account_id, user_id: @current_user.id, :subtask_staff_group_id => params[:task])
                               .where("subject like ? or body like ?", "%#{params[:term]}%","%#{params[:term]}%"  )
                               .order('messages_task.created_at '+ params[:sort] )
        @to_with_user = UserMessagesTask.where(account_id: @current_user.account_id, messages_task_id: @all_messages.map{|v| v.id.to_i})
                                    .includes(:user)
      else
        @all_messages = MessagesTask.where(account_id: @current_user.account_id, user_id: @current_user.id, :subtask_staff_group_id => params[:task])
                               .order(created_at: :desc)
        @to_with_user = UserMessagesTask.where(account_id: @current_user.account_id, messages_task_id: @all_messages.map{|v| v.id.to_i})
                                    .includes(:user)
      end
    end
=end

    @subtask = SubtaskStaffGroup.find_by_id(params[:task])
    @task_name = @subtask.name
    @title_page = @task_name.capitalize
    @type = params[:type]
    @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
  end

  def get_reply_message(message_id)
    return MessagesTask.where(account_id: @current_user.account_id, :parent_id => message_id)
               .order(created_at: :asc)

  end

  def get_parent_message(message_id)
    return MessagesTask.where(account_id: @current_user.account_id, id: message_id)
               .order(created_at: :desc)
               .first
  end

  def get_reply_message_move_record(message_id)
    return MessagesMoveRecord.where(account_id: @current_user.account_id, :parent_id => message_id)
               .order(created_at: :asc)

  end

  def get_parent_message_move_record(message_id)
    return MessagesMoveRecord.where(account_id: @current_user.account_id, id: message_id)
               .order(created_at: :desc)
               .first
  end

  def create
    respond_to do |format|
      params[:to].each do |task|
        @message = MessagesTask.new
        @message.account_id = @current_user.account_id
        @message.user_id = @current_user.id
        @message.subtask_staff_group_id = task.gsub('task_', '').to_i
        @message.subject = params[:subject]
        @message.urgent = params[:urgent]
        @message.body = params[:body]
        @message.task_sender_id = params[:task]
        if @message.save
          user_task = StaffTask.where(subtask_staff_group_id: @message.subtask_staff_group_id, account_id: @message.account_id)
          user_task.each do |user|
            u_messages = UserMessagesTask.new
            u_messages.account_id = @message.account_id
            u_messages.user_id = user.user_id
            u_messages.messages_task_id = @message.id
            u_messages.readed = false
            u_messages.save
          end
          params[:file] ||= []
          params[:file].each do |file|
            file = upload_attachment(file)
            attachment = MessagesTaskAttachment.new
            attachment.messages_task_id = @message.id
            attachment.file_path = file[:url]
            attachment.name = file[:name]
            attachment.account_id = @message.account_id
            attachment.save
          end
          params[:forward] ||= []
          params[:forward].each do |file|
            attachment = MessagesTaskAttachment.new
            attachment.messages_task_id = @message.id
            attachment.file_path = file[:url]
            attachment.name = file[:name]
            attachment.account_id = @message.account_id
            attachment.save
          end
        end
        if !@message.blank?
          format.json { render json: @message }
        else
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def upload_attachment(file_param)
    name = (rand() * 4).to_s + '_' + Time.now.to_i.to_s + '_' + file_param.original_filename
    return {url: upload_bucket_file(file_param, name, 'mmo-attachments-dev'), name: name}
  end

  def update_readed_message
    if params[:message_type] == "task_move_record"
      message = TaskMessagesMoveRecord.find_by(messages_move_record_id: params[:message_id], account_id: @current_user.account_id)
    else
      message = UserMessagesTask.find_by_messages_task_id_and_user_id(params[:message_id], @current_user.id)
    end
    message.readed = true

    respond_to do |format|
      if message.save
        format.json { render json: message }
      else
        format.json { render json: message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_message
    message = UserMessagesTask.find_by_message_id_and_user_id(params[:message_id], @current_user.id)
    respond_to do |format|
      if message.destroy
        format.json { render json: message }
      else
        format.json { render json: message.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_reply_message
    #validate the user cant auto-reply their messages
    #message_reply = MessagesTask.where('parent_id= ? OR id= ?', params[:message_id], params[:message_id]).where.not( user_id: @current_user.id).last
    message_reply = MessagesTask.find_by_id(params[:message_id])
    @message = MessagesTask.new
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = 'Re: ' + message_reply.subject
    @message.subtask_staff_group_id = message_reply.subtask_staff_group_id
    @message.parent_id = params[:message_id]
    @message.body = params[:body]
    respond_to do |format|
      if @message.save
        u_messages = UserMessagesTask.new
        u_messages.account_id = @message.account_id
        u_messages.user_id = message_reply.user_id
        u_messages.messages_task_id = @message.id
        u_messages.readed = false
        u_messages.save
        params[:file] ||= []
        params[:file].each do |file|
          file = upload_attachment(file)
          attachment = MessagesTaskAttachment.new
          attachment.messages_task_id = @message.id
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
    message = UserMessagesTask.where(messages_task_id: params[:message_id], account_id: @current_user.account_id, user_id: @current_user.id).first
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
