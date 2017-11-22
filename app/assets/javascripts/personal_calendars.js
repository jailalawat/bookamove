$(document).ready(function () {

    var global_group = new RegExp('[\?&amp;]group=([^&amp;#]*)').exec(window.location.href);
    global_group = global_group === null ? [] : global_group;
    var calendar_truck_resources = global_group.length == 0 ? '' : '&group=' + global_group[1];
    var date_dropped = '';
    var personal_calendar = $('#calendar-personal');

    var optPersonalCalendar = {
        header: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        defaultView: 'agendaWeek',
        fixedWeekCount: true,
        editable: false,
        businessHours: {
            start: '7:00',
            end: '19:00',
            dow: [0, 1, 2, 3, 4, 5, 6]
        },
        defaultDate: current_date_calendar(),
        timeFormat: 'hh(:mm) a',
        minTime: '07:00:00',
        maxTime: '19:00:00',
        slotDuration: '00:30:00',
        scrollTime: '07:00:00',
        allDaySlot: false,
        eventLimit: true,
        aspectRatio: 1.35,
        snapDuration: '00:30:00',
        selectOverlap: false,
        events: {
            url: '/calendar_personal.json',
            type: 'GET',
            data: {
                group_id: global_group ? global_group[1] : ''
            },
            error: function () {
                $('#error-calendar').show();
            }
        },
        eventAfterAllRender: function (view) {
            $('.has-popover').popover();
            $('.change-view-time').hide();
            $(function () {
                $('[data-toggle="popover"]').popover()
            });
            if (view.name !== 'month') {
                // insert 7pm label for 12 hrs
                $('#lbl7pm').html('7pm');
            }
        },
        viewRender: function (view, element) {
            var current_date = personal_calendar.fullCalendar('getView');
            updated_messages_personal_calendar(current_date.start.format('YYYY-MM-DD'), current_date.end.format('YYYY-MM-DD'));
            $('.popover.fade.in').remove();
            $('a.calavailabletime').attr('href', $('a.calavailabletime').data('url') + '&date_calendar=' + current_date.start.format('YYYY-MM-DD'));
        },
        droppable: true,
        drop: function (date, jsEvent, ui) {
            var message_staff_calendar_id = ui.helper.data('message-staff-calendar-id');
            if (message_staff_calendar_id === undefined) return false;
            add_reminder_personal(date.format('YYYY/MM/DD hh:mm A'), personal_calendar, message_staff_calendar_id)
        },
    };

    personal_calendar.fullCalendar(optPersonalCalendar);

    $('body').on('click', '.change-view-personal-calendar', function (event) {
        $("#calRight").empty();
        var temp_calendar = personal_calendar;
        var type_time = $(this).attr('data-type-time') == 'part' ? true : false;
        optPersonalCalendar.minTime = type_time ? "07:00:00" : "00:00:00";
        optPersonalCalendar.maxTime = type_time ? "19:00:00" : "24:00:00";
        optPersonalCalendar.scrollTime = type_time ? "07:00:00" : "00:00:00";
        optPersonalCalendar.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optPersonalCalendar.defaultView = temp_calendar.fullCalendar('getView').name;
        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optPersonalCalendar);
        $("#calRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-personal-calendar" unselectable="on">' + (type_time ? '24' : '12') + ' hrs</span></div>');
        $('.change-view-personal-calendar').attr('data-type-time', type_time ? 'full' : 'part');

    });

    if (personal_calendar.length == 1) {
        $('#calRight').append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-personal-calendar" unselectable="on">24 hrs</span></div>');
    }

    $(".reminder-event").draggable({
        zIndex: 999,
        revert: true,
        revertDuration: 2
    });

    $('body').on('click', '.update-personal-calendar-available', function () {
        $("#calAfterRight").empty();
        var type_info = $(this).attr('data-type-info') == 'available' ? true : false;
        var temp_calendar = personal_calendar;
        optPersonalCalendar.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optPersonalCalendar.defaultView = temp_calendar.fullCalendar('getView').name;
        if (type_info) {
            optPersonalCalendar.events = {
                url: '/calendar_personal.json',
                type: 'GET',
                data: {available: true},
                error: function () {
                    $('#error-calendar').show();
                }
            };
        } else {
            optPersonalCalendar.events = {
                url: '/calendar_personal.json',
                type: 'GET',
                error: function () {
                    $('#error-calendar').show();
                }
            };
        }

        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optPersonalCalendar);
        $("#calAfterRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right update-personal-calendar-available" unselectable="on" data-type-info = "available">' + (!type_info ? 'Available' : 'All') + '</span></div>');
        $('.update-personal-calendar-available').attr('data-type-info', !type_info ? 'available' : 'all');
        $("#calRight div:first").remove();
    });

    var form_attachments_staff_available_calendar = new FormData();
    $('body').on('click', '.calendar-personal .send-new-staff-available-calendar', function () {
        var body = $(".new-staff-available-calendar .message-body").val();
        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            return false;
        }
        $(this).data('staff-available-calendar') === undefined ? '' : form_attachments_staff_available_calendar.append('staff_id', $(this).data('staff-available-calendar'));
        var subject = $(".new-staff-available-calendar .message-subject").val();
        var urgent = $(".new-staff-available-calendar .message-priority").val();
        var date_calendar = personal_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        form_attachments_staff_available_calendar.append('subject', subject);
        form_attachments_staff_available_calendar.append('body', body);
        form_attachments_staff_available_calendar.append('urgent', urgent);
        form_attachments_staff_available_calendar.append('date_calendar', date_calendar);
        save_message_personal_calendar(form_attachments_staff_available_calendar);
    });

    $('body').on('click', '.fc-button-month', function () {
        $('#lbl7pm').empty();
    });

});

function add_reminder_personal(date, calendar, message_staff_calendar_id) {
    $.ajax({
        url: '/add_reminder_calendar_personal.json',
        type: 'POST',
        data: {
            message_staff_calendar_id: message_staff_calendar_id,
            date: date,
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

function updated_messages_personal_calendar(date_calendar_start, date_calendar_end) {
    $.ajax({
        url: '/update_messages_personal_calendar.json',
        type: 'GET',
        data: {
            date_calendar_start: date_calendar_start,
            date_calendar_end: date_calendar_end,
            respond_html: true
        },
        dataType: 'text'
    }).done(function (data) {
        $('.update-messages-personal-calendar').html(data);
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

function save_message_personal_calendar(form_attachments_staff_available_calendar) {
    $.ajax({
            url: '/messages_staff_available_calendars.json',
            type: 'POST',
            data: form_attachments_staff_available_calendar,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            location.href = location.href.replace(/&message_calendar=([^&amp;#]*)/, "").replace(/&date_calendar=([^&amp;#]*)/, "&date_calendar=" + $('#calendar-personal').fullCalendar('getDate').format('YYYY-MM-DD')) + '&message_calendar=' + data.id;
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}

