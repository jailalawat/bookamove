class MessagesMoveRecordsController < ApplicationController
  before_filter :current_user

  def index_messages
    if (params[:id].present?)
      @full_messages = []
      move_record = MoveRecord.find_by_id(params[:id])
      move_record_customer = move_record.move_record_client.first.client.user_id
      move_record_driver = move_record.move_record_truck.lead
      @all_messages = MessagesMoveRecord.where(account_id: @current_user.account_id, :move_record_id => params[:id])
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                          .select(:id, :parent_id)
      if (move_record_customer == @current_user.id || move_record_driver == @current_user.id)
        custom_messages = EmailMessagesMoveRecord.where(account_id: @current_user.account_id, user_id: @current_user.id)
        @all_messages = MessagesMoveRecord.where('account_id = ? and move_record_id = ? and user_id in (?) OR id in (?) ',
                                                 @current_user.account_id, params[:id], [move_record_customer, move_record_driver], custom_messages.map { |v| v.messages_move_record_id })
                            .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                            .select(:id, :parent_id)
      end

      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages.push({main: get_parent_message(info_message.id), reply: []})
        end
      end
      @full_messages = @full_messages.uniq { |e| e[:main] }
      @subject_suggestions = SubjectSuggestion.where(account_id: @current_user.account_id)
    end
  end

  def get_reply_message(message_id)
    return MessagesMoveRecord.where(account_id: @current_user.account_id, :parent_id => message_id)
               .order(created_at: :asc)

  end

  def get_parent_message(message_id)
    return MessagesMoveRecord.where(account_id: @current_user.account_id, id: message_id)
               .order(created_at: :desc)
               .first
  end

  def create
    @message = MessagesMoveRecord.new
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = params[:subject]
    @message.urgent = params[:urgent]
    @message.move_record_id = params[:move_record]
    @message.body = params[:template_mail].present? ? (!params[:template_mail].blank? ? params[:template_mail] : params[:body]) : params[:body]
    @message.message_type = params[:message_type]
    respond_to do |format|
      if @message.save
        if not params[:message_type] == "call"
          params[:to] ||= []
          params[:to].each do |temp_data|
            if (temp_data.match(/staff_all/))
              @all_staff_users.each do |user|
                u_messages = UserMessagesMoveRecord.new
                u_messages.account_id = @message.account_id
                u_messages.user_id = user.id
                u_messages.messages_move_record_id = @message.id
                u_messages.readed = false
                u_messages.save
              end
            end

            if (temp_data.match(/staff_\d+/))
              u_messages = UserMessagesMoveRecord.new
              u_messages.user_id = temp_data.gsub('staff_', '').to_i
              u_messages.messages_move_record_id = @message.id
              u_messages.account_id = @message.account_id
              u_messages.readed = false
              u_messages.save
            end

            if (temp_data.match(/task_\d+/))
              u_messages = TaskMessagesMoveRecord.new
              u_messages.subtask_staff_group_id = temp_data.gsub('task_', '').to_i
              u_messages.messages_move_record_id = @message.id
              u_messages.account_id = @message.account_id
              u_messages.readed = false
              u_messages.save
            end

            if (temp_data.match(/customer_\d+/))
              u_messages = EmailMessagesMoveRecord.new
              u_messages.user_id = temp_data.gsub('customer_', '').to_i
              u_messages.messages_move_record_id = @message.id
              u_messages.account_id = @message.account_id
              u_messages.save
              if (u_messages.user.email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/))
                url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
                MoverecordMail.customer_message(u_messages.user.email, u_messages.user.name, @message.subject, @message.body, @message.move_record_id, @message.id, url).deliver
              end
            end

            if (temp_data.match(/driver_\d+/))
              u_messages = EmailMessagesMoveRecord.new
              u_messages.user_id = temp_data.gsub('driver_', '').to_i
              u_messages.messages_move_record_id = @message.id
              u_messages.account_id = @message.account_id
              u_messages.save
              if (u_messages.user.email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/))
                url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
                MoverecordMail.customer_message(u_messages.user.email, u_messages.user.name, @message.subject, @message.body, @message.move_record_id, @message.id, url).deliver
              end
            end
          end

          params[:file] ||= []
          params[:file].each do |file|
            file = upload_attachment(file)
            attachment = MessagesMoveRecordAttachment.new
            attachment.messages_move_record_id = @message.id
            attachment.file_path = file[:url]
            attachment.name = file[:name]
            attachment.account_id = @message.account_id
            attachment.save
          end
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
    message = UserMessagesMoveRecord.find_by_messages_move_record_id_and_user_id(params[:message_id], @current_user.id)
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
    message = UserMessagesMoveRecord.find_by_messages_move_record_id_and_user_id(params[:message_id], @current_user.id)
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
    #message_reply = Message.where('parent_id= ? OR id= ?', params[:message_id], params[:message_id]).where.not( user_id: @current_user.id).last
    message_reply = MessagesMoveRecord.find_by_id(params[:message_id])
    @message = MessagesMoveRecord.new
    @message.account_id = @current_user.account_id
    @message.user_id = @current_user.id
    @message.subject = 'Re: ' + message_reply.subject
    @message.parent_id = params[:message_id]
    @message.move_record_id = message_reply.move_record_id
    @message.body = params[:body]
    respond_to do |format|
      if @message.save
        if params[:to].blank?
          params[:to] = @all_staff_users.map { |e| e[:id] }
        end
        params[:to].each do |user|
          u_messages = UserMessagesMoveRecord.new
          u_messages.account_id = @message.account_id
          u_messages.user_id = user
          u_messages.messages_move_record_id = @message.id
          u_messages.readed = false
          u_messages.save
        end
        params[:file] ||= []
        params[:file].each do |file|
          file = upload_attachment(file)
          attachment = MessagesMoveRecordAttachment.new
          attachment.messages_move_record_id = @message.id
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
end
