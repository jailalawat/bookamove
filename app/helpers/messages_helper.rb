module MessagesHelper

  def get_personal_messages
    @full_messages = []
    @full_messages_move_record = []
    @full_messages_truck_calendar = []

    if (params[:type] == 'inbox' or not params[:type].present?)
      @all_messages = Message.where(account_id: @current_user.account_id, id: UserMessage.where(account_id: @current_user.account_id, user_id: @current_user.id, trash: false).select(:message_id)).order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc)).select(:id, :parent_id, :created_at)

      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages.push({main: get_parent_message(info_message.id),
                               reply: [],
                               type: 'personal',
                               created_at: info_message.created_at})
        end
      end

      @all_messages = MessagesMoveRecord.where(account_id: @current_user.account_id, id: UserMessagesMoveRecord.where(account_id: @current_user.account_id, user_id: @current_user.id, trash: false).select(:messages_move_record_id)).order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc)).select(:id, :parent_id, :created_at)

      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages_move_record.push({main: get_parent_message_move_record(info_message.id),
                                           reply: [],
                                           type: 'move_record',
                                           created_at: info_message.created_at})
        end
      end

      @all_messages = MessagesTruckCalendar.where(account_id: @current_user.account_id, id: UserMessageTruckCalendar.where(account_id: @current_user.account_id, user_id: @current_user.id, trash: false).select(:messages_truck_calendar_id)).order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc)).select(:id, :parent_id, :created_at)

      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages_truck_calendar.push({main: get_parent_truck_calendar(info_message.id),
                                              reply: [],
                                              type: 'truck_calendar',
                                              created_at: info_message.created_at})
        end
      end
    end

    if (params[:type] == 'sent')
      @all_messages = Message.where(account_id: @current_user.account_id, user_id: @current_user.id)
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                          .select(:id, :parent_id, :created_at)

      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages.push({main: get_parent_message(info_message.id),
                               reply: [],
                               type: 'personal',
                               created_at: info_message.created_at})
        end
      end


      @all_messages = MessagesMoveRecord.where(account_id: @current_user.account_id, user_id: @current_user.id)
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                          .select(:id, :parent_id, :created_at)
      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages_move_record.push({main: get_parent_message_move_record(info_message.id),
                                           reply: [],
                                           type: 'move_record',
                                           created_at: info_message.created_at})
        end
      end
    end

    if (params[:type] == 'trash')
      @all_messages = Message.where(account_id: @current_user.account_id, id: UserMessage.where(account_id: @current_user.account_id, user_id: @current_user.id, trash: true).select(:message_id))
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                          .select(:id, :parent_id, :created_at)
      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages.push({main: get_parent_message(info_message.id),
                               reply: [],
                               type: 'personal',
                               created_at: info_message.created_at})
        end
      end

      @all_messages = MessagesMoveRecord.where(account_id: @current_user.account_id, id: UserMessagesMoveRecord.where(account_id: @current_user.account_id, user_id: @current_user.id, trash: true).select(:messages_move_record_id))
                          .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))
                          .select(:id, :parent_id, :created_at)
      @all_messages.each do |info_message|
        if (info_message.parent_id.blank?)
          @full_messages_move_record.push({main: get_parent_message_move_record(info_message.id),
                                           reply: [],
                                           type: 'move_record',
                                           created_at: info_message.created_at})
        end
      end
    end

    @full_messages_move_record = @full_messages_move_record.uniq { |e| e[:main] }
    @full_messages_truck_calendar = @full_messages_truck_calendar.uniq { |e| e[:main] }
    @full_messages = @full_messages.uniq { |e| e[:main] }
    @full_messages = @full_messages + @full_messages_move_record + @full_messages_truck_calendar
    @full_messages = (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? @full_messages.sort { |a, b| a[:created_at] <=> b[:created_at] } : @full_messages.sort { |a, b| b[:created_at] <=> a[:created_at] }) : @full_messages.sort { |a, b| b[:created_at] <=> a[:created_at] })
  end

  def get_reply_message(message_id)
    return Message.where(account_id: @current_user.account_id, :parent_id => message_id)
               .order(created_at: :asc)
  end

  def get_parent_message(message_id)
    return Message.where(account_id: @current_user.account_id, id: message_id)
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

  def get_reply_truck_calendar(message_id)
    return MessagesTruckCalendar.where(account_id: @current_user.account_id, :parent_id => message_id)
               .order(created_at: :asc)
  end

  def get_parent_truck_calendar(message_id)
    return MessagesTruckCalendar.where(account_id: @current_user.account_id, id: message_id)
               .order(created_at: :desc)
               .first
  end

end