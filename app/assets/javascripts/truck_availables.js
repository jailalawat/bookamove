$(document).ready(function () {
    var colorSelectedCalendar = '';
    var start_time = '';
    var end_time = '';
    var modal_bootbox = '';
    var calendar_truck_available = $('#calendar-truck-available');
    var optTruckAvalaible = {
        header: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        defaultView: 'agendaWeek',
        fixedWeekCount: true,
        events: {
            url: '/calendar_truck_available.json',
            type: 'GET',
            data: {truck_id: current_truck_id()}
        },
        aspectRatio: 1.61,
        defaultDate: current_date_available(),
        timeFormat: 'hh(:mm)t',
        minTime: '07:00:00',
        maxTime: '19:00:00',
        slotDuration: '00:30:00',
        allDaySlot: false,
        snapDuration: '00:30:00',
        selectOverlap: false,
        selectable: true,
        selectHelper: true,
        contentHeight: "auto",
        select: function (start, end, jsEvent, view) {
            if (start.endOf("day") < end) {
                calendar_truck_available.fullCalendar('unselect');
            }

            $(document).off('mousedown');
        },
        eventRender: function (event, element) {
            if (event.className[0] !== 'fc-helper') {
                if (event.title == "Available") {
                    element.find('.fc-content').prepend('<i class="icon-trash pull-right remove-event-available" data-id="' + event.truck_time_id + '"></i>');
                }
                else if (event.title == "Unavailable") {
                    element.find('.fc-content').prepend('<i class="icon-trash pull-right remove-event-available" data-id="' + event.truck_time_id + '"></i>');
                }
            }
        },
        eventAfterAllRender: function (view) {
            var style = $(".btn-unavailable").attr("style");
            $(".btn-unavailable").attr("style", style + " background: #cccccc url('/images/cross_hatching2.png') round !important");
            $('.has-popover').popover();
            $(function () {
                $('[data-toggle="popover"]').popover()
            });
            var timeDisplay = $(".change-view-time-available").text();
            if (timeDisplay == "24 hrs") {
                $('#lbl7pm').html('7pm');
                $('#calendar-truck-available').fullCalendar('option', 'aspectRatio', 1.71);
            }
            else {
                $('#lbl7pm').html('');
                $('#calendar-truck-available').fullCalendar('option', 'aspectRatio', 1.685);
            }
        },
        eventAfterRender: function (event, element, view) {
            if (event.type == "reminder") {
                var temp_reminder_html = "<div class='has-popover pull-right pointer' data-content='" + event.comment +
                    "' data-placement='top' data-title='" + event.subject +
                    "' data-original-title='" + event.subject + "' data-container='body' data-selector='i.icon-time' data-html=true >" +
                    "<i class='icon-time' style='margin:3px;'></i>" +
                    "</div>";
                $('.reminder-weekly[data-reminder-time="' + event.start.format('YYYY-MM-DD') + '"]').append(temp_reminder_html);
            }
        },
        viewRender: function (view, element) {
            var current_date = calendar_truck_available.fullCalendar('getView');
            updated_messages_truck_available_calendar(current_truck_id(), current_date.start.format('YYYY-MM-DD'), current_date.end.format('YYYY-MM-DD'));
            $('#calendar-truck-available .fc-axis').first().append('<div style="height: 37px; background-color: #fbfbfb; margin-bottom: -10px; width: 39px; margin-left: -5px; display: inline-block"></div><div style="height: 37px; background-color: #fbfbfb; margin-bottom: -10px; width: 15px; margin-left: -5px; display: inline-block"></div>');
            $('#calendar-truck-available .fc-body').append('<tr><td style="border: 0"><div style="height: 20px; background-color: #fbfbfb; margin-top: -2px; width: 50px; margin-left: -2px; display: inline-block"></div></td></tr>');
            var style = $(".btn-unavailable").attr("style");
            $('a.calavailabletime').attr('href', $('a.calavailabletime').data('url') + '?date_calendar=' + current_date.start.format('YYYY-MM-DD'));
        },
        droppable: true,
        drop: function (date, jsEvent, ui) {
            var message_truck_calendar_id = ui.helper.data('message-truck-calendar-id');
            if (message_truck_calendar_id === undefined) return false;
            add_reminder_truck_available(current_truck_id(), date.format('YYYY/MM/DD hh:mm A'), calendar_truck_available, message_truck_calendar_id);
        },
    };

    calendar_truck_available.fullCalendar(optTruckAvalaible);

    $('body').on('click', '.unavailable-truck', function (event) {
        var start_time = $(this).data('start-time');
        var end_time = $(this).data('end-time');
        update_truck_available_time(start_time, end_time, calendar_truck_available, false);
    });

    $('body').on('click', '.available-truck', function (event) {
        var start_time = $(this).data('start-time');
        var end_time = $(this).data('end-time');
        update_truck_available_time(start_time, end_time, calendar_truck_available, true);
    });

    $('body').on('click', '.remove-event-available', function (event) {
        destroy_truck_available_time(calendar_truck_available, $(this).data('id'));
    });

    $('body').on('click', '.change-view-time-available', function (event) {
        $("#calRight").empty();
        var temp_calendar = $('#calendar-truck-available');
        var type_time = $(this).attr('data-type-time') == 'part' ? true : false;
        optTruckAvalaible.minTime = type_time ? "07:00:00" : "00:00:00";
        optTruckAvalaible.maxTime = type_time ? "19:00:00" : "24:00:00";
        optTruckAvalaible.scrollTime = type_time ? "07:00:00" : "00:00:00";
        optTruckAvalaible.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optTruckAvalaible.defaultView = temp_calendar.fullCalendar('getView').name;
        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optTruckAvalaible);
        $("#calRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time-available" unselectable="on">' + (type_time ? '24' : '12') + ' hrs</span></div>');
        $('.change-view-time-available').attr('data-type-time', type_time ? 'full' : 'part');
        $("#calRight div:first").remove();

    });

    if (calendar_truck_available.length == 1) {
        $("#calRight div:first").remove();
        $('#calRight').append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time-available" unselectable="on">24 hrs</span></div>');
    }
});

function update_truck_available_time(start_time, end_time, calendar_truck_available, available) {
    $.ajax({
            url: '/update_truck_available_time.json',
            type: 'POST',
            data: {
                start_time: start_time,
                end_time: end_time,
                truck_id: current_truck_id(),
                available: available
            },
        })
        .done(function () {
            calendar_truck_available.fullCalendar('refetchEvents');
            calendar_truck_available.fullCalendar('unselect');
        })
        .fail(function () {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });

}

function destroy_truck_available_time(calendar_truck_available, truck_time_id) {
    $.ajax({
            url: '/destroy_truck_available_time.json',
            type: 'DELETE',
            data: {truck_time_id: truck_time_id},
        })
        .done(function () {
            calendar_truck_available.fullCalendar('refetchEvents');
            calendar_truck_available.fullCalendar('unselect');
        })
        .fail(function () {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });

}

function current_truck_id() {
    var truck_id = new RegExp('truck=([^&amp;#]*)').exec(window.location.href);
    truck_id = truck_id === null ? [] : truck_id;
    return truck_id[1];
}

function current_date_available() {
    var date_available = new RegExp('date_calendar=([^&amp;#]*)').exec(window.location.href);
    return date_available === null ? null : date_available[1];
}

function updated_messages_truck_available_calendar(truck, date_calendar_start, date_calendar_end) {
    $.ajax({
        url: '/update_messages_truck_available_calendar.json',
        type: 'GET',
        data: {
            truck: truck,
            date_calendar_start: date_calendar_start,
            date_calendar_end: date_calendar_end,
            respond_html: true
        },
        dataType: 'text'
    }).done(function (data) {
        $('.update-messages-truck-available-calendar').html(data);
        $(".multi-select-new-message-to").chosen({search_contains: true});
        current_message_truck_calendar();
        $(".update-messages-truck-available-calendar .star-priority").toggle(
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
                $(".update-messages-truck-available-calendar .message-priority").val('1');
            },
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
                $(".update-messages-truck-available-calendar .message-priority").val('2');
            },
            function () {
                $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
                $(".update-messages-truck-available-calendar .message-priority").val('0');
            }
        );
        $(".reminder-event").draggable({
            zIndex: 999,
            revert: true,
            revertDuration: 2,
            live: true
        });
    }).fail(function (data) {
        error_permissions();
    });
}

function add_reminder_truck_available(truck_id, date, calendar, message_truck_calendar_id) {
    $.ajax({
        url: '/add_reminder_truck_calendar.json',
        type: 'POST',
        data: {
            message_truck_calendar_id: message_truck_calendar_id,
            date: date,
            truck_id: truck_id
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

