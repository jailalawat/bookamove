$(document).ready(function () {
    var colorSelectedCalendar = '';
    var start_time = '';
    var end_time = '';
    var modal_bootbox = '';
    var calendar_staff_available = $('#calendar-staff-available');
    var optStaffAvalaible = {
        header: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        defaultView: 'agendaWeek',
        fixedWeekCount: true,
        events: {
            url: '/calendar_staff_available.json',
            data: {staff: current_staff_id()},
            type: 'GET'
        },
        aspectRatio: 1.685,
        timeFormat: 'hh(:mm)t',
        minTime: '07:00:00',
        maxTime: '19:00:00',
        slotDuration: '00:30:00',
        allDaySlot: false,
        defaultDate: current_date_available(),
        snapDuration: '00:30:00',
        selectOverlap: false,
        selectable: true,
        selectHelper: true,
        select: function (start, end, jsEvent, view) {
            if (start.endOf("day") < end) {
                return $('#calendar-staff-available').fullCalendar('unselect');
            }
            $('#calendar-staff-available .fc-helper').find('.fc-time').remove();
            $(document).off('mousedown');
        },
        eventRender: function (event, element) {
            if (event.className[0] !== 'fc-helper') {
                if (event.title == "Available") {
                    element.find('.fc-content').prepend('<i class="icon-trash pull-right remove-event-available" data-id="' + event.staff_time_id + '"></i>');
                }
                else if (event.title == "Unavailable") {
                    element.find('.fc-content').prepend('<i class="icon-trash pull-right remove-event-available" data-id="' + event.staff_time_id + '"></i>');
                }
            }
        },
        viewRender: function (view, element) {
            var current_date = $('#calendar-staff-available').fullCalendar('getView');
            updated_messages_staff_available_calendar(current_staff_id(), current_date.start.format('YYYY-MM-DD'), current_date.end.format('YYYY-MM-DD'));
            $('.has-popover').popover("hide");
            $('#calendar-staff-available .fc-axis').first().append('<div style="height: 37px; background-color: #fbfbfb; margin-bottom: -10px; width: 39px; margin-left: -5px; display: inline-block"></div><div style="height: 37px; background-color: #fbfbfb; margin-bottom: -10px; width: 15px; margin-left: -5px; display: inline-block"></div>');
            $('#calendar-staff-available .fc-body').append('<tr><td style="border: 0"><div style="position: absolute; height: 20px; background-color: #fbfbfb; margin-top: -2px; width: 50px; margin-left: -2px; display: inline-block"></div></td></tr>');
            $('a.calavailabletime').attr('href', $('a.calavailabletime').data('url') + '?date_calendar=' + current_date.start.format('YYYY-MM-DD'));
        },
        eventAfterAllRender: function (view) {
            $('.popover.fade.in').remove();
            $('.has-popover').popover();
            $('.change-view-time').hide();
            $(function () {
                $('[data-toggle="popover"]').popover()
            });
            var style = $(".btn-unavailable").attr("style");
            $(".btn-unavailable").attr("style", style + " background: #cccccc url('/images/cross_hatching2.png') round !important");

            var timeDisplay = $(".change-view-time-staff-available").text();
            if (timeDisplay == "24 hrs") {
                $('#lbl7pm').html('7pm');
                $('#calendar-staff-available').fullCalendar('option', 'aspectRatio', 1.71);
            }
            else {
                $('#lbl7pm').html('');
                $('#calendar-staff-available').fullCalendar('option', 'aspectRatio', 1.685);
            }
        },
        droppable: true,
        drop: function (date, jsEvent, ui) {
            var message_staff_calendar_id = ui.helper.data('message-staff-calendar-id');
            if (message_staff_calendar_id === undefined) return false;
            add_reminder_staff(current_staff_id(), date.format('YYYY/MM/DD hh:mm A'), calendar_staff_available, message_staff_calendar_id)
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
        }
    };

    calendar_staff_available.fullCalendar(optStaffAvalaible);
    $("#calendar-staff-available").addClass("col-md-12");

    $('body').on('click', '.unavailable-truck', function (event) {
        var start_time = moment($(this).data('start-time')).format('YYYY-MM-DD hh:mm A');
        var end_time = moment($(this).data('end-time')).format('YYYY-MM-DD hh:mm A');
        update_staff_available_time(start_time, end_time, calendar_staff_available, false);
    });

    $('body').on('click', '.available-truck', function (event) {
        var start_time = moment($(this).data('start-time')).format('YYYY-MM-DD hh:mm A');
        var end_time = moment($(this).data('end-time')).format('YYYY-MM-DD hh:mm A');
        update_staff_available_time(start_time, end_time, calendar_staff_available, true);
    });

    $('body').on('click', '.remove-event-available', function (event) {
        destroy_staff_available_time(calendar_staff_available, $(this).data('id'));
    });

    $('body').on('click', '.change-view-time-staff-available', function (event) {
        $("#calRight").empty();
        var temp_calendar = $('#calendar-staff-available');
        var type_time = $(this).attr('data-type-time') == 'part' ? true : false;
        optStaffAvalaible.minTime = type_time ? "07:00:00" : "00:00:00";
        optStaffAvalaible.maxTime = type_time ? "19:00:00" : "24:00:00";
        optStaffAvalaible.scrollTime = type_time ? "07:00:00" : "00:00:00";
        optStaffAvalaible.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optStaffAvalaible.defaultView = temp_calendar.fullCalendar('getView').name;
        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optStaffAvalaible);
        $("#calRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time-staff-available" unselectable="on">' + (type_time ? '24' : '12') + ' hrs</span></div>');
        $('.change-view-time-staff-available').attr('data-type-time', type_time ? 'full' : 'part');
        $("#calRight div:first").remove();

    });

    if (calendar_staff_available.length == 1) {
        $("#calRight div:first").remove();
        $('#calRight').append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time-staff-available" unselectable="on">24 hrs</span></div>');
    }
});

function update_staff_available_time(start_time, end_time, calendar_staff_available, available) {
    $.ajax({
            url: '/update_staff_available_time.json',
            type: 'POST',
            data: {
                start_time: start_time,
                end_time: end_time,
                available: available,
                staff: current_staff_id()
            },
        })
        .done(function () {
            calendar_staff_available.fullCalendar('refetchEvents');
            calendar_staff_available.fullCalendar('unselect');
        })
        .fail(function () {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });

}

function destroy_staff_available_time(calendar_staff_available, staff_time_id) {
    $.ajax({
            url: '/destroy_staff_available_time.json',
            type: 'DELETE',
            data: {staff_time_id: staff_time_id},
        })
        .done(function () {
            calendar_staff_available.fullCalendar('refetchEvents');
            calendar_staff_available.fullCalendar('unselect');
        })
        .fail(function () {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });

}

function add_reminder_staff(staff_id, date, calendar, message_staff_calendar_id) {
    $.ajax({
        url: '/add_reminder_calendar_personal.json',
        type: 'POST',
        data: {
            message_staff_calendar_id: message_staff_calendar_id,
            date: date,
            staff_id: staff_id
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

function current_staff_id() {
    var staff_id = new RegExp('staff=([^&amp;#]*)').exec(window.location.href);
    return staff_id === null ? null : staff_id[1];
}

function current_date_available() {
    var date_available = new RegExp('date_calendar=([^&amp;#]*)').exec(window.location.href);
    return date_available === null ? null : date_available[1];
}

function updated_messages_staff_available_calendar(staff, date_calendar_start, date_calendar_end) {
    $.ajax({
        url: '/update_messages_staff_available_calendar.json',
        type: 'GET',
        data: {
            staff: staff,
            date_calendar_start: date_calendar_start,
            date_calendar_end: date_calendar_end,
            respond_html: true
        },
        dataType: 'text'
    }).done(function (data) {
        $('.update-messages-staff-available-calendar').html(data);
        $(".multi-select-new-message-to").chosen({search_contains: true});
        current_message_truck_calendar();
        $(".update-messages-staff-available-calendar .star-priority").toggle(
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
                $(".update-messages-staff-available-calendar .message-priority").val('1');
            },
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
                $(".update-messages-staff-available-calendar .message-priority").val('2');
            },
            function () {
                $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
                $(".update-messages-staff-available-calendar .message-priority").val('0');
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
