class NotificationRelayJob < ApplicationJob
  queue_as :notifications

  def perform(notification)

    # on_create
    if notification[:mode] == "create" && notification[:type] == "personal"
      ActionCable.server.broadcast "notifications:#{notification[:recipient_id]}", message: notification[:message], type: "personal", from_name: notification[:from_name], to_name: notification[:to_name], mode: "create"
    end

    if notification[:mode] == "create" && notification[:type] == "personal_move_record"
      ActionCable.server.broadcast "notifications:#{notification[:recipient_id]}", message: notification[:message], type: "personal_move_record", from_name: notification[:from_name], to_name: notification[:to_name], move_record_id: notification[:move_record_id], move_record_name: notification[:move_record_name], mode: "create"
    end

    if notification[:mode] == "create" && notification[:type] == "personal_truck_calendar"
      ActionCable.server.broadcast "notifications:#{notification[:recipient_id]}", message: notification[:message], type: "personal_truck_calendar", from_name: notification[:from_name], to_name: notification[:to_name], mode: "create"
    end

    # on_move_to_trash
    if notification[:mode] == "trash"
      ActionCable.server.broadcast "notifications:#{notification[:recipient_id]}", message: notification[:message], type: notification[:type], readed: notification[:readed], mode: "trash"
    end

    # on_readed
    if notification[:mode] == "readed"
      ActionCable.server.broadcast "notifications:#{notification[:recipient_id]}", message: notification[:message], type: notification[:type], readed: notification[:readed], mode: "readed"
    end

  end

end