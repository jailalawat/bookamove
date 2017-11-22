$(document).ready(function () {

    var global_group = new RegExp('[\?&amp;]group=([^&amp;#]*)').exec(window.location.href);
    global_group = global_group === null ? [] : global_group;
    var calendar_truck_resources = global_group.length == 0 ? '' : '&group=' + global_group[1];
    var date_dropped = '';
    var my_truck_calendar = $('#calendar-truck');

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
            url: '/calendar_truck.json',
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
            var current_date = my_truck_calendar.fullCalendar('getView');
            updated_messages_my_truck_calendar(current_date.start.format('YYYY-MM-DD'), current_date.end.format('YYYY-MM-DD'));
            $('.popover.fade.in').remove();
            $('a.calavailabletime').attr('href', $('a.calavailabletime').data('url') + '&date_calendar=' + current_date.start.format('YYYY-MM-DD'));
        },
        droppable: true,
        drop: function (date, jsEvent, ui) {
            var message_truck_calendar_id = ui.helper.data('message-truck-calendar-id');
            if (message_truck_calendar_id === undefined) return false;
            add_reminder_truck_calendar(date.format('YYYY/MM/DD hh:mm A'), my_truck_calendar, message_truck_calendar_id)
        },
    };

    my_truck_calendar.fullCalendar(optPersonalCalendar);

    $('body').on('click', '.change-view-truck-calendar', function (event) {
        $("#calRight").empty();
        var temp_calendar = my_truck_calendar;
        var type_time = $(this).attr('data-type-time') == 'part' ? true : false;
        optPersonalCalendar.minTime = type_time ? "07:00:00" : "00:00:00";
        optPersonalCalendar.maxTime = type_time ? "19:00:00" : "24:00:00";
        optPersonalCalendar.scrollTime = type_time ? "07:00:00" : "00:00:00";
        optPersonalCalendar.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optPersonalCalendar.defaultView = temp_calendar.fullCalendar('getView').name;
        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optPersonalCalendar);
        $("#calRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-truck-calendar" unselectable="on">' + (type_time ? '24' : '12') + ' hrs</span></div>');
        $('.change-view-truck-calendar').attr('data-type-time', type_time ? 'full' : 'part');
        $("#calRight div:first").remove();

    });

    if (my_truck_calendar.length == 1) {
        $("#calRight div:first").remove();
        $('#calRight').append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-truck-calendar" unselectable="on">24 hrs</span></div>');
    }

    $(".reminder-event").draggable({
        zIndex: 999,
        revert: true,
        revertDuration: 2
    });

    $('body').on('click', '.update-truck-calendar-available', function () {
        $("#calAfterRight").empty();
        var type_info = $(this).attr('data-type-info') == 'available' ? true : false;
        var temp_calendar = my_truck_calendar;
        optPersonalCalendar.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optPersonalCalendar.defaultView = temp_calendar.fullCalendar('getView').name;
        if (type_info) {
            optPersonalCalendar.events = {
                url: '/calendar_truck.json',
                type: 'GET',
                data: {available: true},
                error: function () {
                    $('#error-calendar').show();
                }
            };
        } else {
            optPersonalCalendar.events = {
                url: '/calendar_truck.json',
                type: 'GET',
                error: function () {
                    $('#error-calendar').show();
                }
            };
        }

        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optPersonalCalendar);
        $("#calAfterRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right update-truck-calendar-available" unselectable="on" data-type-info = "available">' + (!type_info ? 'Available' : 'All') + '</span></div>');
        $('.update-truck-calendar-available').attr('data-type-info', !type_info ? 'available' : 'all');
        $("#calRight div:first").remove();
    });

    $('body').on('click', '.fc-button-month', function () {
        $('#lbl7pm').empty();
    });

});

function add_reminder_truck_calendar(date, calendar, message_truck_calendar_id) {
    $.ajax({
        url: '/add_reminder_truck_calendar.json',
        type: 'POST',
        data: {
            message_truck_calendar_id: message_truck_calendar_id,
            date: date,
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

function updated_messages_my_truck_calendar(date_calendar_start, date_calendar_end) {
    $.ajax({
        url: '/update_messages_my_truck_calendar.json',
        type: 'GET',
        data: {
            date_calendar_start: date_calendar_start,
            date_calendar_end: date_calendar_end,
            respond_html: true
        },
        dataType: 'text'
    }).done(function (data) {
        $('.update-messages-truck-calendar').html(data);
        $(".update-messages-truck-calendar .star-priority").toggle(
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
                $(".update-messages-truck-calendar .message-priority").val('1');
            },
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
                $(".update-messages-truck-calendar .message-priority").val('2');
            },
            function () {
                $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
                $(".update-messages-truck-calendar .message-priority").val('0');
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

