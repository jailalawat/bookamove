$(document).ready(function () {

    var global_group = new RegExp('[\?&amp;]group=([^&amp;#]*)').exec(window.location.href);
    global_group = global_group === null ? [] : global_group;
    var tmp_disabled_stage_emails = new RegExp('[\?&amp;]disabled_stage_emails=([^&amp;#]*)').exec(window.location.href);
    tmp_disabled_stage_emails = tmp_disabled_stage_emails === null ? [] : tmp_disabled_stage_emails;
    var disabled_stage_emails = tmp_disabled_stage_emails.length == 0 ? '' : tmp_disabled_stage_emails[1];
    var calendar_truck_resources = global_group.length == 0 ? '' : 'group=' + global_group[1];
    var url_update_time = '/update_time_calendar_movers.json',
        url_update_day = '/update_day_calendar_movers.json',
        url_update_add_man = '/update_add_man_movers.json',
        url_information_add_man = '/information_staff_truck.json',
        url_add_truck = 'add_truck_move_record.json',
        url_clone_move = 'add_truck_clone.json';
    var date_dropped = '';
    var last_resource_dropped = null;
    var calendar_rendered = false;
    var disable_month_view = current_move_referred_selectable() ? '' : 'month';
    var current_user = $('.user-name').data('user');
    var cut_action = '', copy_action = '', temp_date_month = '';
    var optCalendar = {
        header: {
            left: 'prev,next',
            center: 'title',
            right: disable_month_view
        },
        fixedWeekCount: true,
        editable: true,
        eventDurationEditable: false,
        businessHours: {
            dow: [0, 1, 2, 3, 4, 5, 6]
        },
        defaultTimedEventDuration: '00:00:00',
        selectOverlap: false,
        timeFormat: 'hh(:mm)t',
        minTime: '07:00:00',
        maxTime: '19:00:00',
        slotDuration: '00:30:00',
        scrollTime: '07:00:00',
        defaultDate: current_date_calendar(),
        defaultView: default_type_calendar(),
        allDaySlot: false,
        eventLimit: true, // allow "more" link when too many events
        snapDuration: '00:30:00',
        events: {
            url: '/calendar_movers.json',
            type: 'GET',
            data: {
                group_id: global_group ? global_group[1] : ''
            },
            error: function () {
                $('#error-calendar').show();
            }
        },
        resources: '/truck_calendar_resources.json?' + calendar_truck_resources,
        dayClick: function (date, jsEvent, view) {
            if (view.name === 'month') {
                calendar.fullCalendar('changeView', 'resourceDay');
                calendar.fullCalendar('gotoDate', date.format());
                calendar.fullCalendar('refetchEvents');
                if (!current_link_id()) {
                    var truckgroup = global_group[1];
                    var data_link = JSON.parse(localStorage.getItem(current_user + '_' + 'truckcalendar_' + truckgroup));
                    if (data_link) {
                        data_link.show_date = date.format('MMM DD');
                        data_link.date = calendar.fullCalendar('getDate').format('YYYY-MM-DD');
                        data_link.type = 'resourceDay';
                        localStorage.setItem(current_user + '_' + 'truckcalendar_' + truckgroup, JSON.stringify(data_link));
                        $('.static-link-group a[data-truckcalendar="' + truckgroup + '"]').find('span').text(data_link.name + ' - ' + data_link.show_date);
                        $('.static-link-group a[data-truckcalendar="' + truckgroup + '"]').attr('href', data_link.url + '&kind_calendar=' + data_link.type + '&date_calendar=' + data_link.date);
                    }
                }

            }
        },
        eventDrop: function (event, delta, revertFunc, jsEvent, ui, view) {
            if (view.name === 'month') {
                revertFunc();
                return false;
            } else {
                if (event.newResource == "") {
                    revertFunc();
                    return false;
                }
                last_resource_dropped = event.oldResource == 'undefined' ? event.newResource : event.oldResource;
                event.oldResource = 'undefined';
                move_update({
                        move_id: event.move_id,
                        old_id_truck: last_resource_dropped,
                        new_id_truck: event.newResource,
                        start_time: event.start.format('hh:mm A'),
                        end_time: event.end.format('hh:mm A')
                    },
                    url_update_time).done(function () {
                    $.jGrowl("Move record updated", {header: 'Success', theme: 'success-jGrowl'});
                }).fail(function (data) {
                    $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
                });
            }
        },
        eventAfterAllRender: function (view) {
            $('.has-popover').popover("hide");
            if (!current_link_id() && calendar_rendered) {
                var truckgroup = global_group[1];
                var data_link = JSON.parse(localStorage.getItem(current_user + '_' + 'truckcalendar_' + truckgroup));
                if (data_link) {
                    data_link.show_date = view.name === 'month' ? calendar.fullCalendar('getDate').format('MMM') : calendar.fullCalendar('getDate').format('MMM DD');
                    data_link.date = calendar.fullCalendar('getDate').format('YYYY-MM-DD');
                    data_link.type = view.name;
                    localStorage.setItem(current_user + '_' + 'truckcalendar_' + truckgroup, JSON.stringify(data_link));
                    $('.static-link-group a[data-truckcalendar="' + truckgroup + '"]').find('span').text(data_link.name + ' - ' + data_link.show_date);
                    $('.static-link-group a[data-truckcalendar="' + truckgroup + '"]').attr('href', data_link.url + '&kind_calendar=' + data_link.type + '&date_calendar=' + data_link.date);
                }
            }

            if (view.name !== 'month') {
                var temp_event_calendar = $.grep(view.calendar.clientEvents(), function (event) {
                    return event.type === 'move_record' && (event.start.format('YYYY-MM-DD') === view.calendar.getDate().format('YYYY-MM-DD'));
                });
                for (var i = 0; i < temp_event_calendar.length; i++) {
                    var event = temp_event_calendar[i];
                    if ((moment(event.start.format('YYYY-MM-DD HH:mm:ss')).isBefore(view.calendar.getDate().format('YYYY-MM-DD') + ' ' + view.calendar.option('minTime'))) ||
                        (moment(event.end.format('YYYY-MM-DD HH:mm:ss')).isAfter(view.calendar.getDate().format('YYYY-MM-DD') + ' ' + view.calendar.option('maxTime')))) {
                        $('.change-view-time').addClass('highlighttime');
                    }
                }
                ;

                $('.move-record-droppable').droppable({
                    accept: ".user-truck-event",
                    activeClass: "border-droppable",
                    drop: function (event, ui) {
                        var move = $(event.target).data('move');
                        var user = ui.draggable.data('user');
                        move_update({
                            move_id: move,
                            user_id: user,
                        }, url_update_add_man).done(function (data) {
                            if (!data.error) {
                                $('#calendar-move-record').fullCalendar('refetchEvents');
                                $.jGrowl("Move record updated", {header: 'Success', theme: 'success-jGrowl'});
                            } else {
                                $.jGrowl(data.msg, {header: 'Error', theme: 'error-jGrowl'});
                            }
                            list_staff_available($('#calendar-move-record').fullCalendar('getDate').format('YYYY-MM-DD'), global_group[1]);
                        });

                    }
                });
                $("#calendar-move-record").removeClass("col-md-12").addClass("col6");
                $("#calendar-move-record").removeClass("ptop16").addClass("ptop8");
                $(window).trigger('resize');
                $("#calPreRight").removeClass("col1").addClass("col1-5");
                $('.fc-button-month').show();
                // insert 7pm label for 12 hrs
                $('#lbl7pm').html('7pm');
                if ($(".change-view-time").attr('data-type-time') == 'part') {
                    $('#lbl7pm').empty();
                }

            } else {
                $('.change-view-time').hide();
                $('.fc-button-month').hide();
                $("#calendar-move-record").removeClass("col6").addClass("col-md-12");
                $("#calendar-move-record").removeClass("ptop8").addClass("ptop16");
                $(window).trigger('resize');
                $("#calPreRight").removeClass("col1-5").addClass("col1");
                $('#lbl7pm').empty();
            }
            calendar_rendered = true;
        },
        drop: function (date, jsEvent, ui) {
            var date_dropped = date;
            var data_truck = jsEvent;
            var message_truck_calendar_id = ui.helper.data('message-truck-calendar-id');
            if (calendar.fullCalendar('getView').name == 'month') {
                if (message_truck_calendar_id === undefined) return false;
                var date = date_dropped.format('YYYY/MM/DD hh:mm A');
                add_reminder(message_truck_calendar_id, date_dropped, date_dropped.format('hh:mm A'), null, calendar, global_group[1]);

            } else {
                if (data_truck.data.id === "") {
                    return false;
                }
                if (message_truck_calendar_id === undefined) return false;
                var date = date_dropped.format('YYYY/MM/DD hh:mm A');
                add_reminder(message_truck_calendar_id, date_dropped, date_dropped.format('hh:mm A'), data_truck.data.id, calendar, global_group[1]);
            }
        },
        selectable: current_move_referred_selectable() || current_cut_move_selectable(),
        select: function (start, end, jsEvent, view) {
            if (view.name !== 'month') {
                var new_truck_id = jsEvent.data.id;
                var time_booked = start.format('YYYY/MM/DD hh:mm A');
                if (new_truck_id === '') return calendar.fullCalendar('unselect');
                if (current_move_referred_selectable()) {
                    bootbox.dialog({
                        message: 'Are you sure?',
                        title: "Confirmation",
                        closeButton: true,
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function () {
                                    calendar.fullCalendar('unselect');
                                    $(this).modal('hide');
                                }
                            },
                            primary: {
                                label: "Save",
                                className: "btn-primary",
                                callback: function () {
                                    $.ajax({
                                        url: url_add_truck,
                                        type: 'POST',
                                        data: {
                                            move_id: current_move_referred(),
                                            new_id_truck: new_truck_id,
                                            start_time: time_booked,
                                            group: global_group[1],
                                            disabled_stage_emails: disabled_stage_emails
                                        }
                                    }).done(function (data) {
                                        calendar.fullCalendar('refetchEvents');
                                        location.href = "/move_records/" + current_move_referred() + "/edit";
                                    }).fail(function (data) {
                                        error_permissions();
                                        $.jGrowl("A problem has occurred. Try again.", {
                                            header: 'Error',
                                            theme: 'error-jGrowl'
                                        });
                                    });
                                }
                            }
                        }
                    });
                }

                if (current_cut_move_selectable()) {
                    bootbox.dialog({
                        message: 'Are you sure?',
                        title: "Confirmation",
                        closeButton: true,
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function () {
                                    calendar.fullCalendar('unselect');
                                    $(this).modal('hide');
                                }
                            },
                            primary: {
                                label: "Save",
                                className: "btn-primary",
                                callback: function () {
                                    $.ajax({
                                        url: url_add_truck,
                                        type: 'POST',
                                        data: {
                                            move_id: current_cut_move(),
                                            new_id_truck: new_truck_id,
                                            start_time: time_booked,
                                            group: global_group[1],
                                            resource: current_resource_move()
                                        }
                                    }).done(function (data) {
                                        calendar.fullCalendar('unselect');
                                        calendar.fullCalendar('refetchEvents');
                                        location.href = window.location.href.replace(/&cut_move=([^&amp;#]*)/, "").replace(/&resource=([^&amp;#]*)/, "").replace(/date_calendar=([^&amp;#]*)/, "date_calendar=" +
                                            calendar.fullCalendar('getDate').format('YYYY-MM-DD'));
                                    }).fail(function (data) {
                                        error_permissions();
                                        $.jGrowl("A problem has occurred. Try again.", {
                                            header: 'Error',
                                            theme: 'error-jGrowl'
                                        });
                                    });
                                }
                            }
                        }
                    });
                }
            }

        },
        selectHelper: function (start, end) {
            if (current_cut_move_selectable()) {
                return $("<div class='stage-calendar-Book text-center'>Paste move - " + start.format('hh:mm A') + "</div>");
            }
            return $("<div class='stage-calendar-Book text-center'>Book - " + start.format('hh:mm A') + "</div>");
        },
        unselectAuto: false,
        droppable: true,
        viewRender: function (view, element) {
            var current_date = $('#calendar-move-record').fullCalendar('getDate');
            if (view.name === 'month') {
                $('.calendar-days-line').html('');
                $('#calendar-move-record').find('.fc-header-left').removeClass('hide-arrows-calendar');
                $('#calendar-move-record').fullCalendar('option', 'aspectRatio', 1.61);
                $('.list-trucks-calendar').show();
                $('.reminder-monthly, .change-view-time, .list-staff-truck-calendar').hide();
            } else {
                display_days_numbers_line($('#calendar-move-record'));
                $('#calendar-move-record').find('.fc-header-left').addClass('hide-arrows-calendar');
                $('#calendar-move-record').fullCalendar('option', 'aspectRatio', 1.35);
                $('.list-trucks-calendar').hide();
                $('.reminder-monthly, .change-view-time, .list-staff-truck-calendar').show();
                list_staff_available(current_date.format('YYYY-MM-DD'), global_group[1]);
            }
            if (temp_date_month != current_date.format('YYYY-MM')) {
                updated_messages_truck_calendar(global_group[1], current_date.format('YYYY-MM-DD'));
                temp_date_month = current_date.format('YYYY-MM');
            }
            $('.popover').remove();
            $('.change-view-time').removeClass('highlighttime');
        },
        eventAfterRender: function (event, element, view) {
            if (!current_move_referred_selectable() && !current_cut_move_selectable() && view.name !== 'month' && event.type === 'move_record') {
                cut_action = '<a href="' + window.location.href.replace(/date_calendar=([^&amp;#]*)/, "date_calendar=" +
                                calendar.fullCalendar('getDate').format('YYYY-MM-DD')) +
                                '&cut_move=' + event.move_id + '&resource=' + event.resources[0] +
                              '"><i class="icon-cut"></i></a>';
                copy_action = '<a class="truck-event-description clone-move" data-resource="' + event.resources[0] +
                              '" data-move="' + event.move_id + '"><i class="icon-copy"></i></a>';

                // if big event show tools
                if (element.context.offsetHeight > 80 && !event.all_info_blacked_out && event.cut_copy_and_paste) {
                    element.find('.fc-event-title').after('<div class="truck-event-description end-travel" style="border: 0">' + cut_action + copy_action + '</div>');
                }
                //element.find('.end-travel').prepend('<div class="truck-event-description">' + cut_action + copy_action + '</div>');
                // enable popover
                $(function () {
                    $('[data-toggle="popover"]').popover()
                });
            }
        }
    };

    var calendar = $('#calendar-move-record').fullCalendar(optCalendar);

    //$('#calendar-move-record .fc-header-right').append('<span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time" unselectable="on">24 hrs</span>');
    if ($('#calendar-move-record').length == 1) {
        $("#calRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right' + ' change-view-time"' + ' unselectable="on">24 hrs</span></div>');
    }

    $('.update-move-record-calendar').on('click', function () {
        global_truck = $(this).attr('data-truckId');
        calendar.fullCalendar('removeEvents');
        calendar.fullCalendar('addEventSource', {
            url: '/calendar_movers.json',
            type: 'GET',
            data: {
                truck_id: global_truck
            },
            error: function () {
                $('#error-calendar').show();
            }
        });
    });

    $('.all-update-move-record-calendar').on('click', function () {
        calendar.fullCalendar('removeEvents');
        calendar.fullCalendar('addEventSource', {
            url: '/calendar_movers.json',
            type: 'GET',
            data: {
                group_id: global_group[1]
            },
            error: function () {
                $('#error-calendar').show();
            }
        });
    });

    $('body').on('click', '.clone-move', function (event) {
        event.preventDefault();
        var move = $(this).data('move');
        var resource = $(this).data('resource');
        $.ajax({
            url: url_clone_move,
            type: 'POST',
            data: {
                move_id: move,
                new_id_truck: resource
            }
        }).done(function (data) {
            calendar.fullCalendar('unselect');
            calendar.fullCalendar('refetchEvents');
        }).fail(function (data) {
            error_permissions();
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });
    });

    $('body').on('click', '.more-reminder', function (event) {
        var message_truck_calendar = $(this).data('link-message');
        $('div[data-message*="' + message_truck_calendar + '"]:first .panel-heading').trigger('click');
        if ($('[data-message*="' + message_truck_calendar + '"]').length > 0) {
            $("body, html").animate({
                scrollTop: $('[data-message*="' + message_truck_calendar + '"]').offset().top - 250
            }, 600);
            $('div[data-message*="' + message_truck_calendar + '"]:last').effect("highlight", {}, 3000);
        }
    });

    $('body').on('click', '.change-view-time', function (event) {
        $("#calRight").empty();
        var temp_calendar = $('#calendar-move-record');
        var type_time = $(this).attr('data-type-time') == 'part' ? true : false;
        optCalendar.minTime = type_time ? "07:00:00" : "00:00:00";
        optCalendar.maxTime = type_time ? "19:00:00" : "24:00:00";
        optCalendar.scrollTime = type_time ? "07:00:00" : "00:00:00";
        optCalendar.defaultDate = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        optCalendar.defaultView = temp_calendar.fullCalendar('getView').name;
        temp_calendar.fullCalendar('destroy');
        temp_calendar.fullCalendar(optCalendar);
        //$('.fc-header-right').append('<span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time" unselectable="on">' + (type_time ? '24' : '12') + ' hrs</span>');
        $("#calRight").append('<div class="btn btn-none"><span class="fc-button fc-state-default fc-corner-left fc-corner-right change-view-time" unselectable="on">' + (type_time ? '24' : '12') + ' hrs</span></div>');
        $('.change-view-time').attr('data-type-time', type_time ? 'full' : 'part');

        $(function () {
            if (!type_time) {
                $('#lbl7pm').empty();
            }
        });
    });

    $("body").on("dblclick", ".user-truck-event", function () {
        var temp_date_calendar = $('#calendar-move-record').fullCalendar('getDate').format('YYYY-MM-DD');
        window.location.href = '/staff_availables?staff=' + $(this).data('user') + '&date_calendar=' + temp_date_calendar;
    });

});

function move_update(data_post, url) {
    return $.ajax({
        url: url,
        type: 'PUT',
        data: data_post
    }).fail(function (data) {
        error_permissions();
    });
}

function add_reminder(message_truck_calendar_id, date, time, truck, calendar, truck_group) {
    $.ajax({
        url: '/add_reminder_calendar_mover.json',
        type: 'POST',
        data: {
            message_truck_calendar_id: message_truck_calendar_id,
            date: date.format('YYYY/MM/DD') + ' ' + time,
            truck: truck,
            truck_group: truck_group
        }
    }).done(function (data) {
        calendar.fullCalendar('refetchEvents');
    }).fail(function (data) {
        error_permissions();
    });
}

function updated_messages_truck_calendar(group, date_calendar) {
    $.ajax({
        url: '/update_messages_truck_calendar.json',
        type: 'GET',
        data: {
            group: group,
            date_calendar: date_calendar,
            respond_html: true
        },
        dataType: 'text'
    }).done(function (data) {
        $('.update-messages-truck-calendar').html(data);
        $(".multi-select-new-message-to").chosen({search_contains: true});
        current_message_truck_calendar();
        $(".new-message-truck-calendar .star-priority").toggle(
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
                $(".new-message-truck-calendar .message-priority").val('1');
            },
            function () {
                $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
                $(".new-message-truck-calendar .message-priority").val('2');
            },
            function () {
                $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
                $(".new-message-truck-calendar .message-priority").val('0');
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

function current_move_referred() {
    var move_referred = new RegExp('move_referred=([^&amp;#]*)').exec(window.location.href);
    return move_referred === null ? null : move_referred[1];
}

function current_move_referred_selectable() {
    return current_move_referred() === null ? false : true;
}


function current_cut_move() {
    var cut_move = new RegExp('cut_move=([^&amp;#]*)').exec(window.location.href);
    return cut_move === null ? null : cut_move[1];
}

function current_cut_move_selectable() {
    return current_cut_move() === null ? false : true;
}

function current_resource_move() {
    var resource = new RegExp('resource=([^&amp;#]*)').exec(window.location.href);
    return resource === null ? null : resource[1];
}

function current_message_truck_calendar() {
    var message_param = new RegExp('message_calendar=([^&amp;#]*)').exec(window.location.href);
    if (message_param !== null) {
        $('div[data-message*="' + message_param[1] + '"]:first .panel-heading').trigger('click');
        if ($('[data-message*="' + message_param[1] + '"]').length > 0) {
            $("body, html").animate({
                scrollTop: $('[data-message*="' + message_param[1] + '"]').offset().top - 250
            }, 600);
            $('div[data-message*="' + message_param[1] + '"]:last').parents('.wrap-full-message').effect("highlight", {}, 1000);
        }

    }
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

function list_staff_available(start_date, group) {
    $.ajax({
        url: '/calendar_truck_available_list.json',
        type: 'GET',
        data: {
            start: start_date,
            group: group
        }
    }).done(function (data) {
        var html = '';
        for (var i = 0; data.list.length > i; i++) {
            html += '<div class="user-truck-event ui-draggable draggable-item-staff pointer has-popover" data-user="' + data.list[i].id + '" >' +
                '<i class="icon-male ' + data.list[i].color + '"></i>&nbsp;<span class="' + data.list[i].available + '">' + data.list[i].name + '</span>' +
                '</div>';
        }
        ;
        movers_html = '<div class="list-movers-title">Movers: ' + data.total_movers + ' > ' + data.total_availables + '</div>'
        $('.full-list-staff').html(movers_html + html);
        $('.draggable-item-staff').draggable({revert: true});
    }).fail(function (data) {
        error_permissions();
    });
}
