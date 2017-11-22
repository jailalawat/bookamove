$(document).ready(function () {

    var global_group = new RegExp('[\?&amp;]group=([^&amp;#]*)').exec(window.location.href);
    global_group = global_group === null ? [] : global_group;
    var calendar_task_resources = global_group.length == 0 ? '' : 'group=' + global_group[1];
    var url_update_time = '/update_time_calendar_tasks.json',
        url_update_day = '/update_day_calendar_tasks.json',
        url_update_task_information = '/update_task_information.json';
    var date_dropped = '', temp_date_month = '';
    var calendar_rendered = false;
    var current_user = $('.user-name').data('user');

    var calendar = $('#calendar-staff-task').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month'
        },
        fixedWeekCount: true,
        editable: true,
        businessHours: {
            start: '7:00',
            end: '19:00',
            dow: [0, 1, 2, 3, 4, 5, 6]
        },
        timeFormat: 'hh(:mm)t',
        minTime: '07:00:00',
        maxTime: '19:00:00',
        defaultDate: current_date_calendar(),
        defaultView: default_type_calendar(),
        slotDuration: '00:30:00',
        scrollTime: '07:00:00',
        allDaySlot: false,
        eventLimit: true,
        selectable: true,
        selectOverlap: false,
        defaultTimedEventDuration: '00:00:00',
        snapDuration: '00:30:00',
        events: {
            url: '/calendar_task.json',
            type: 'GET',
            data: {
                group_id: global_group ? global_group[1] : ''
            },
            error: function () {
                $('#error-calendar').show();
            }
        },
        resources: '/task_calendar_resources.json?' + calendar_task_resources,
        select: function (start, end, jsEvent, view, env) {
            if (jsEvent.data === undefined)  return calendar.fullCalendar('unselect');
            var temp_event_calendar = $.grep(view.calendar.clientEvents(), function (event) {
                return event.type === 'task-available' &&
                    event.resources[0] == jsEvent.data.id &&
                    ( moment(event.start.format('YYYY-MM-DD HH:mm:ss')).isBetween(start.format('YYYY-MM-DD HH:mm:ss'), end.format('YYYY-MM-DD HH:mm:ss')) ||
                    moment(event.end.format('YYYY-MM-DD HH:mm:ss')).isBetween(start.format('YYYY-MM-DD HH:mm:ss'), end.format('YYYY-MM-DD HH:mm:ss')));
            });
            if (temp_event_calendar.length > 0) return calendar.fullCalendar('unselect');
            var start_time = start.format('YYYY-MM-DD hh:mm A');
            if (((end - start) === 900000) || (start.endOf("day") < end)) {
                return calendar.fullCalendar('unselect');
            }
            if (jsEvent.data.id === "") return calendar.fullCalendar('unselect');

            task_available_time(start_time,
                end.format('YYYY-MM-DD hh:mm A'),
                $('#calendar-staff-task'),
                jsEvent.data.id);
        },
        dayClick: function (date, jsEvent, view) {
            if (view.name === 'month') {
                calendar.fullCalendar('changeView', 'resourceDay')
                calendar.fullCalendar('gotoDate', date.format());
                if (!current_link_id()) {
                    var taskgroup = global_group[1];
                    var data_link = JSON.parse(localStorage.getItem(current_user + '_' + 'taskcalendar_' + taskgroup));
                    if (data_link) {
                        data_link.show_date = date.format('MMM DD');
                        data_link.date = calendar.fullCalendar('getDate').format('YYYY-MM-DD');
                        data_link.type = 'resourceDay';
                        localStorage.setItem(current_user + '_' + 'taskcalendar_' + taskgroup, JSON.stringify(data_link));
                        $('.static-link-group a[data-taskcalendar="' + taskgroup + '"]').find('span').text(data_link.name + ' - ' + data_link.show_date);
                        $('.static-link-group a[data-taskcalendar="' + taskgroup + '"]').attr('href', data_link.url + '&kind_calendar=' + data_link.type + '&date_calendar=' + data_link.date);
                    }
                }
            }
            $(window).trigger('resize');
        },
        eventDrop: function (event, delta, revertFunc, jsEvent, ui, view) {
            if (view.name === 'month') {
                task_update({
                        staff_task_id: event.staff_task_id,
                        start_time: event.start.format('YYYY/MM/DD hh:mm A'),
                        end_time: event.end.format('YYYY/MM/DD hh:mm A'),
                    },
                    url_update_day, calendar);
            } else {
                if (event.newResource == "") {
                    revertFunc();
                    return false;
                }
                task_update({
                        staff_task_id: event.staff_task_id,
                        new_id_subtask: event.newResource ? event.newResource : event.resources[0],
                        start_time: event.start.format('YYYY/MM/DD hh:mm A'),
                        end_time: event.end.format('YYYY/MM/DD hh:mm A')
                    },
                    url_update_time, calendar);
            }
        },
        eventResize: function (event, jsEvent, ui, view) {
            task_update({
                    staff_task_id: event.staff_task_id,
                    new_id_subtask: event.resources[0],
                    start_time: event.start.format('YYYY/MM/DD hh:mm A'),
                    end_time: event.end.format('YYYY/MM/DD hh:mm A')
                },
                url_update_time, calendar);
        },
        drop: function (date, jsEvent, ui) {
            var date_dropped = date;
            var data_task = jsEvent;
            var message_task_calendar_id = ui.helper.data('message-task-calendar-id');
            if (calendar.fullCalendar('getView').name == 'month') {
                if (message_task_calendar_id === undefined) return false;
                var date = date_dropped.format('YYYY/MM/DD hh:mm A');
                add_reminder_task(message_task_calendar_id, date_dropped, date_dropped.format('hh:mm A'), null, calendar, global_group[1]);

            } else {
                if (data_task.data.id === "") {
                    return false;
                }
                if (message_task_calendar_id === undefined) return false;
                var date = date_dropped.format('YYYY/MM/DD hh:mm A');
                add_reminder_task(message_task_calendar_id, date_dropped, date_dropped.format('hh:mm A'), data_task.data.id, calendar, global_group[1]);
            }
        },
        eventAfterAllRender: function (view) {
            $('.has-popover').popover("hide");
            if (!current_link_id() && calendar_rendered) {
                var truckgroup = global_group[1];
                var data_link = JSON.parse(localStorage.getItem(current_user + '_' + 'taskcalendar_' + truckgroup));
                if (data_link) {
                    data_link.show_date = view.name === 'month' ? calendar.fullCalendar('getDate').format('MMM') : calendar.fullCalendar('getDate').format('MMM DD');
                    data_link.date = calendar.fullCalendar('getDate').format('YYYY-MM-DD');
                    data_link.type = view.name;
                    localStorage.setItem(current_user + '_' + 'taskcalendar_' + truckgroup, JSON.stringify(data_link));
                    $('.static-link-group a[data-taskcalendar="' + truckgroup + '"]').find('span').text(data_link.name + ' - ' + data_link.show_date);
                    $('.static-link-group a[data-taskcalendar="' + truckgroup + '"]').attr('href', data_link.url + '&kind_calendar=' + data_link.type + '&date_calendar=' + data_link.date);
                }
            }
            if (view.name !== 'month') {
                $('.task-available-droppable').droppable({
                    accept: ".user-task-event",
                    activeClass: "border-droppable",
                    drop: function (event, ui) {
                        var task_available = $(event.target).data('task');
                        var user = ui.draggable.data('user');
                        task_available_update(task_available, user, calendar);
                        list_staff_available_task_calendar($('#calendar-staff-task').fullCalendar('getDate').format('YYYY-MM-DD'));
                    }
                });
                $("#calendar-staff-task").removeClass("col-md-12").addClass("col6");
                $("#calendar-staff-task").removeClass("ptop16").addClass("ptop8");
                $('.change-view-time').hide();
                $('.fc-button-month').show();
                $('.full-list-staff').show();
                $(window).trigger('resize');
                // insert 7pm label for 12 hrs
                $('#lbl7pm').html('7pm');
            }
            else {
                $('.change-view-time').hide();
                $('.fc-button-month').hide();
                $('.full-list-staff').hide();
                $("#calendar-staff-task").removeClass("col6").addClass("col-md-12");
                $("#calendar-staff-task").removeClass("ptop8").addClass("ptop16");
                $(window).trigger('resize');
            }
            calendar_rendered = true;
            $(window).trigger('resize');
        },
        droppable: true,
        viewRender: function (view, element) {
            var current_date = $('#calendar-staff-task').fullCalendar('getDate');
            if (view.name === 'month') {
                $('.calendar-days-line').html('');
                $('#calendar-staff-task').find('.fc-header-left').removeClass('hide-arrows-calendar');
                $('#calendar-staff-task').fullCalendar('option', 'aspectRatio', 1.61);
                $(window).trigger('resize');
            } else {
                display_days_numbers_line($('#calendar-staff-task'));
                $('#calendar-staff-task').find('.fc-header-left').addClass('hide-arrows-calendar');
                list_staff_available_task_calendar(current_date.format('YYYY-MM-DD'));
                $('#calendar-staff-task').fullCalendar('option', 'aspectRatio', 1.35);
                $(window).trigger('resize');
            }
            if (temp_date_month != current_date.format('YYYY-MM')) {
                updated_messages_task_calendar(global_group[1], current_date.format('YYYY-MM-DD'));
                temp_date_month = current_date.format('YYYY-MM');
            }
            $('.popover').remove();
        },
        eventAfterRender: function (event, element, view) {
            if (event.className[0] !== 'fc-helper') {
                element.find('.fc-event-title').prepend('<div class="pull-right tools"><i class="fa fa-plus-circle small_icon pull-right pointer" data-toggle="modal" data-target="#'+ event.task_available_id +'Modal"></i> <i class="icon-trash pull-right remove-event-task-available small_icon pointer mright2" data-id="' + event.task_available_id + '"></i></div>');
            }
            if (view.name === 'month') {
                $('.tools').hide();
            }
            $(window).trigger('resize');
        }
    });

    $(".user-task-event").draggable({
        zIndex: 999,
        revert: true,
        revertDuration: 2
    });

    $('.update-task-calendar').on('click', function () {
        global_task = $(this).data('taskid');
        calendar.fullCalendar('removeEvents');
        calendar.fullCalendar('addEventSource', {
            url: '/calendar_task.json',
            type: 'GET',
            data: {
                task_id: global_task
            },
            error: function () {
                $('#error-calendar').show();
            }
        });
    });

    $('.all-update-task-calendar').on('click', function () {
        calendar.fullCalendar('removeEvents');
        calendar.fullCalendar('addEventSource', {
            url: '/calendar_task.json',
            type: 'GET',
            data: {
                group_id: global_group[1]
            },
            error: function () {
                $('#error-calendar').show();
            }
        });
    });

    $("body").on("dblclick", ".user-task-event", function () {
        var temp_date_calendar = $('#calendar-staff-task').fullCalendar('getDate').format('YYYY-MM-DD');
        window.location.href = '/staff_availables?staff=' + $(this).data('user') + '&date_calendar=' + temp_date_calendar;
    });

    $('body').on('click', '.remove-event-task-available', function (event) {
        destroy_task_available_time(calendar, $(this).data('id'));
    });

    $('body').on('click', '.fc-button-month', function () {
        $(window).trigger('resize');
        $('#lbl7pm').empty();
    });

});


function updated_messages_task_calendar(group, date_calendar) {
    $.ajax({
        url: '/update_messages_task_calendar.json',
        type: 'GET',
        data: {
            group: group,
            date_calendar: date_calendar,
            respond_html: true
        },
        dataType: 'text'
    }).done(function (data) {
        $('.update-messages-task-calendar').html(data);
        $(".multi-select-new-message-to").chosen({search_contains: true});
        current_message_truck_calendar();
        $(".new-message-task-calendar .star-priority").toggle(
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
                $(".new-message-task-calendar .message-priority").val('1');
            },
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
                $(".new-message-task-calendar .message-priority").val('2');
            },
            function () {
                $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
                $(".new-message-task-calendar .message-priority").val('0');
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

function task_available_time(start_time, end_time, calendar_task_available, subtask_id) {
    $.ajax({
            url: '/task_calendar_available_time.json',
            type: 'POST',
            data: {
                start_time: start_time,
                end_time: end_time,
                subtask_id: subtask_id
            },
        })
        .done(function () {
            calendar_task_available.fullCalendar('refetchEvents');
            calendar_task_available.fullCalendar('unselect');
        })
        .fail(function () {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });

}

function task_available_update(task_available_time, user_id, calendar) {
    $.ajax({
        url: '/task_calendar_available_time.json',
        type: 'PUT',
        data: {
            task_available_time: task_available_time,
            user_id: user_id
        }
    }).done(function () {
        calendar.fullCalendar('refetchEvents');
        $.jGrowl("Role updated", {header: 'Success', theme: 'success-jGrowl'});
    }).fail(function (data) {
        error_permissions();
    });
}

function task_update(data, url, calendar) {
    return $.ajax({
        url: url,
        type: 'PUT',
        data: data
    }).done(function () {
        calendar.fullCalendar('removeEvents');
        calendar.fullCalendar('refetchEvents');
        $.jGrowl("Role updated", {header: 'Success', theme: 'success-jGrowl'});
    }).fail(function (data) {
        error_permissions();
    });
}

function add_staff_subtask(subtask, start_time, end_time, user, rate, calendar) {
    $.ajax({
        url: '/add_staff_calendar_task.json',
        type: 'POST',
        data: {
            subtask: subtask,
            start_time: start_time,
            end_time: end_time,
            user: user,
            rate: rate
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

function add_reminder_task(message_task_calendar_id, date, time, task, calendar, task_group) {
    $.ajax({
        url: '/add_reminder_calendar_task.json',
        type: 'POST',
        data: {
            message_task_calendar_id: message_task_calendar_id,
            date: date.format('YYYY/MM/DD') + ' ' + time,
            task: task,
            task_group: task_group
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

function delete_staff_subtask(subtask, calendar) {
    var subtask = subtask;
    bootbox.dialog({
        message: "Are you sure?",
        title: "Remove role",
        closeButton: true,
        buttons: {
            cancel: {
                label: "Cancel",
                className: "btn-default",
                callback: function () {
                    $(this).modal('hide');
                }
            },
            primary: {
                label: "Ok",
                className: "btn-primary",
                callback: function () {
                    $.ajax({
                        url: '/destroy_staff_calendar_task.json',
                        type: 'DELETE',
                        data: {
                            staff_task_id: subtask
                        }
                    }).done(function (data) {
                        calendar.fullCalendar('refetchEvents');
                    }).fail(function (data) {
                        error_permissions();
                    });
                }
            }
        }
    });

}

function destroy_task_available_time(calendar_task, task_available_time) {
    $.ajax({
            url: '/destroy_task_available_time.json',
            type: 'DELETE',
            data: {task_available_time: task_available_time},
        })
        .done(function () {
            calendar_task.fullCalendar('refetchEvents');
            list_staff_available_task_calendar(calendar_task.fullCalendar('getDate').format('YYYY-MM-DD'));
        })
        .fail(function () {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });

}

function type_calendar(calendar) {
    var type_calendar = new RegExp('kind_calendar=([a-zA-Z]*)').exec(window.location.href);
    type_calendar = type_calendar === null ? [] : type_calendar;
    if (type_calendar.length != 0) {
        date_calendar(calendar);
        $('.fc-button-' + type_calendar[1]).trigger('click');

    }
}

function date_calendar(calendar) {
    var date_calendar = new RegExp('date_calendar=([^&amp;#]*)').exec(window.location.href);
    date_calendar = date_calendar === null ? [] : date_calendar;
    calendar.fullCalendar('gotoDate', date_calendar[1]);
}

function current_date_calendar() {
    var date_calendar = new RegExp('date_calendar=([^&amp;#]*)').exec(window.location.href);
    date_calendar = date_calendar === null ? [] : date_calendar;
    return date_calendar === null ? false : date_calendar[1];
}

function default_type_calendar() {
    var type_calendar = new RegExp('kind_calendar=([a-zA-Z]*)').exec(window.location.href);
    type_calendar = type_calendar === null ? [] : type_calendar;
    return type_calendar.length > 0 ? type_calendar[1] : 'month';
}


function current_date(calendar) {
    if (calendar.length > 0) {
        return calendar.fullCalendar('getView').name === 'month' ? calendar.fullCalendar('getDate').format('MMM') : calendar.fullCalendar('getDate').format('MMM DD');
    }
    return moment().format('MMM');
}

function current_date_month() {
    return moment().format('MMM');
}

function current_full_date(calendar) {
    if (calendar.length > 0) {
        return calendar.fullCalendar('getDate').format('YYYY-MM-DD');
    }
    return moment().format('YYYY-MM-DD');
}

function current_view_calendar(calendar) {
    if (calendar.length > 0) {
        return calendar.fullCalendar('getView').name;
    }
    return 'month';
}

function current_link_id() {
    var link_id = new RegExp('link_id=([^&amp;#]*)').exec(window.location.href);
    link_id = link_id === null ? [] : link_id;
    return link_id[1];
}

function list_staff_available_task_calendar(start_date) {
    $.ajax({
        url: '/calendar_task_available_list.json',
        type: 'GET',
        data: {
            start: start_date
        }
    }).done(function (data) {
        var html = '';
        for (var i = 0; data.list.length > i; i++) {
            html += '<div class="user-task-event ui-draggable draggable-item-staff pointer has-popover" data-user="' + data.list[i].id + '" >' +
                '<i class="icon-male ' + data.list[i].color + '"></i>&nbsp;<span class="' + data.list[i].available + '">' + data.list[i].name + '</span>' +
                '</div>';
        }
        ;
        movers_html = '<div class="list-movers-title">Staff: ' + data.total_movers + ' > ' + data.total_availables + '</div>'
        $('.full-list-staff').html(movers_html + html);
        $('.draggable-item-staff').draggable({revert: true});
    }).fail(function (data) {
        error_permissions();
    });
}
