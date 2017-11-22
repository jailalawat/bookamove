App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
      var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    // Personal msg
      if(data.type == "personal" || data.type == "personal_move_record" || data.type == "personal_truck_calendar") {
          var tmp_type = "";
          if (data.type == "personal") tmp_type = "personal";
          if (data.type == "personal_move_record") tmp_type = "move_record";
          if (data.type == "personal_truck_calendar") tmp_type = "truck_calendar";

          // Bell and my mail number notification
          var msg_num = parseInt($(".number-new-messages-notification").text());

          if (data.mode == "create") {
              $(".number-new-messages-notification").removeClass("hidden");
              if (data.message.urgent == "2") $(".number-new-messages-notification").addClass("red-bg");
              $(".number-new-messages-notification").text(msg_num + 1).hide().fadeIn("slow");
          }
          if (data.mode == "trash"){
              if (data.readed == false) $(".number-new-messages-notification").text(msg_num - 1).hide().fadeIn("slow");
          }
          if (data.mode == "readed"){
              $(".number-new-messages-notification").text(msg_num - 1).hide().fadeIn("slow");
          }

          // Urgent and Personal numbers
          var urgent_msg_num = parseInt($(".urgent-number-new-messages-notification").text());
          var personal_msg_num = parseInt($(".personal-number-new-messages-notification").text());

          if (data.mode == "create") {
              if (data.message.urgent == "2") $(".urgent-number-new-messages-notification").text(urgent_msg_num + 1);
              else $(".personal-number-new-messages-notification").text(personal_msg_num + 1);
          }
          if (data.mode == "trash") {
              if (data.readed == false) {
                  if (data.message.urgent == "2") $(".urgent-number-new-messages-notification").text(urgent_msg_num - 1);
                  else $(".personal-number-new-messages-notification").text(personal_msg_num - 1);
                  if (data.message.urgent == "2" && urgent_msg_num <= 1) $(".number-new-messages-notification").removeClass("red-bg");
              }
          }
          if (data.mode == "readed") {
              if (data.message.urgent == "2") $(".urgent-number-new-messages-notification").text(urgent_msg_num - 1);
              else $(".personal-number-new-messages-notification").text(personal_msg_num - 1);
              if (data.message.urgent == "2" && urgent_msg_num <= 1) $(".number-new-messages-notification").removeClass("red-bg");
          }

          // Message
          if (data.mode == "create") {
              var created_date = new Date(data.message.created_at.replace("T", " ").replace("Z", ""));

              var msg = "<div class='panel panel-default wrap-full-message non-read' data-message='" + data.message.id + "' data-type-message='" + tmp_type + "'>";
              msg += "<div class='panel-heading accordion-toggle collapsed' data-parent='#accordion0" + data.message.id + "' data-toggle='collapse' href='#collapse-0" + data.message.id + "-0" + data.message.id + "' title='Click to expand/collapse'>";
              msg += "<div class='row'>";
              msg += "<div class='col-md-1'>";
              if (data.message.urgent == "2") msg += "<i class='icon-star star-urgent' title='Urgent'></i>";
              else if (data.message.urgent == "1") msg += "<i class='icon-star star-urgent color-yellow' title='Important'></i>";
              msg += "<i class='icon-tags pointer mark-message icon-gray' title='Mark' data-type-message='" + tmp_type + "' data-message-tag-id='" + data.message.id + "'></i>";
              msg += "</div>";
              msg += "<div class='col-md-1'>";
              msg += "<span><b>" + data.from_name + "</b></span>";
              msg += "</div>";
              msg += "<div class='row col-md-8'>";
              msg += "<div class='col-md-4'>";
              msg += "<span><b>" + data.to_name + "</b></span>";
              msg += "</div>";
              msg += "<div class='col-md-4'>";
              msg += "<span class='subject'><b>" + data.message.subject + "</b></span>";
              msg += "<span class='text-gray p13'> - " + data.message.body.substring(0, 39) + "</span>";
              msg += "</div>";
              if (data.type == "personal_move_record") {
                  msg += "<div class='col-md-3'>";
                  msg += "<a href='/move_records/"+ data.move_record_id +"/edit?message="+ data.message.id +"' target='_blank' class='redirect_move_record'>";
                  msg += "<i class='icon-truck'></i>&nbsp; "+ data.move_record_name;
                  msg += "</a>";
                  msg += "</div>";
              }
              if (data.type == "personal_truck_calendar") {
                  msg += "<div class='col-md-3'>";
                  msg += "<a href='#' target='_blank' class='redirect_move_record'>";
                  msg += "<i class='icon-calendar'></i>&nbsp; ";
                  msg += "</a>";
                  msg += "</div>";
              }
              msg += "</div>";
              msg += "<div class='col-md-2'>";
              msg += "<span><b>" + created_date.toLocaleTimeString().replace(/:\d+ /, ' ').toLowerCase() + ' ' + monthNames[created_date.getMonth()] + ' ' + created_date.getDate() + "</b></span>";
              msg += " <i class='icon-trash pointer delete-message' title='Trash' data-message='" + data.message.id + "' data-type-message='" + tmp_type + "'></i>";
              msg += "</div>";
              msg += "</div>";
              msg += "</div>";
              msg += "<div class='panel-collapse collapse' id='collapse-0" + data.message.id + "-0" + data.message.id + "'>";
              msg += "<div class='panel-body body-warp-message'>";
              msg += "<div class='body-message col-md-8 col-md-offset-2 p13'>" + data.message.body + "</div>";
              msg += "<div class='col-md-2'>";
              msg += "</div>";
              msg += "</div>";
              msg += "</div>";
              msg += "</div>";

              // Append personal msg to inbox
              $("#inbox_msg_panel").prepend(msg);
              $('[data-message="' + data.message.id + '"]').fadeOut("fast").fadeIn("slow");

              // Append to bell list if urgent
              if (data.message.urgent == "2") {
                  $(".notification-list > li:nth-child(2)").after("<li class='text-center notification-message-" + data.message.id + "'><a href='#'><div class='widget-body'><a href='/messages?type=inbox'><div class='pull-left col-md-5 text-right'><i class='icon-star text-error' title='Urgent'></i> " + data.from_name.substring(0, 14) + "</div><div class='pull-left col-md-6 no-pright'>" + data.message.subject.substring(0, 14) + "</div></a></div></a></li><li class='divider'></li>");
              }


              // Show flash alert and append
              if (data.message.urgent == "2") {
                  $(".new-msg-alert").removeClass("alert-info");
                  $(".new-msg-alert").addClass("alert-danger");
              }
              else {
                  $(".new-msg-alert").removeClass("alert-danger");
                  $(".new-msg-alert").addClass("alert-info");
              }
              $(".new-msg-alert").removeClass("hidden").fadeIn("fast").fadeOut(20000);

              var tmp_msg_alert = "<div class='panel panel-default wrap-full-message non-read notification-message-"+ data.message.id +"'>";
              tmp_msg_alert += "<div class='panel-heading accordion-toggle collapsed'>";
              tmp_msg_alert += "<div class='row'>";
              tmp_msg_alert += "<div class='pull-left col-md-6 text-center'>";
              if (data.message.urgent == "2") tmp_msg_alert += "<i class='icon-star star-urgent' title='Urgent'></i> ";
              else if (data.message.urgent == "1") tmp_msg_alert += "<i class='icon-star star-urgent color-yellow' title='Important'></i> ";
              else tmp_msg_alert += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
              tmp_msg_alert += "<a href='/messages?type=inbox'>" + data.from_name.substring(0, 14) + "</a></div>";
              tmp_msg_alert += "<div class='pull-left col-md-6'>";
              if (data.type == "personal_move_record") {
                  tmp_msg_alert += "<a href='/messages?type=inbox'><i class='icon-truck'></i></a>&nbsp; ";
              }
              if (data.type == "personal_truck_calendar") {
                  tmp_msg_alert += "<a href='/messages?type=inbox'><i class='icon-calendar'></i></a>&nbsp; ";
              }
              tmp_msg_alert += "<a href='/messages?type=inbox'>"+ data.message.subject.substring(0, 14) +"</a>";
              tmp_msg_alert += "</div>";
              tmp_msg_alert += "</div></div></div>";

              $("#alert_msgs").prepend(tmp_msg_alert);
          }

          // remove
          if (data.mode == "trash") {
              var temp_notification = $('.notification-message-' + data.message.id);
              if ($('.notification-message-' + data.message.id).length > 0) temp_notification.remove();
              var msg = $('[data-message="' + data.message.id + '"]');
              if ($('[data-message="' + data.message.id + '"]').length > 0) $('[data-message="' + data.message.id + '"]').remove();
          }
          // unread
          if (data.mode == "readed") {
              $('[data-message="' + data.message.id + '"]').removeClass("non-read");
          }

    }

  }
});
