$(function () {

    $('#calendar-home').fullCalendar({
        defaultView: 'timelineDay',
        header: false,
        businessHours: {
            start: '7:00',
            end: '19:00',
            dow: [0, 1, 2, 3, 4, 5, 6]
        },
        timeFormat: 'hh(:mm)t',
        minTime: '07:00:00',
        maxTime: '19:00:00',
        slotDuration: '00:15:00',
        allDaySlot: false,
        eventLimit: true, // allow "more" link when too many events
        snapDuration: '00:15:00',
        aspectRatio: 15,
        contentHeight: 'auto',
        events: {
            url: '/calendar_personal.json',
            type: 'GET',
            error: function () {
                $('#error-calendar').show();
            }
        },
        eventRender: function (event, element) {
            if (event.type == 'move_record') {
                element.find('.fc-content').html('<a href="/move_records/' + event.move_id + '/edit" target="_blank"><i class="icon-truck"></i>' + event.title + '</a>');
            }
            if (event.type == 'reminder') {
                element.find('.fc-content').text('');
                element.addClass('fc-custom-timeline-reminder');
                element.find('.fc-content').append('<i class="icon-time"></i>');
                element.find('.fc-content').addClass('has-popover pointer');
                element.find('.fc-content').attr('data-content', event.comment);
                element.find('.fc-content').attr('data-placement', 'right');
                element.find('.fc-content').attr('data-title', event.start.format('hh:mm A'));

            }
            if (event.type == 'task') {
                element.find('.fc-content').prepend('<i class="icon-male"></i>');
            }
            element.addClass(event.className);

        },
        eventAfterAllRender: function (view) {
            $('.has-popover').popover("hide");
        }
    });

    $(".dataTables_wrapper .dataTables_length").css("margin","0px");
    $(".dataTables_wrapper .dataTables_filter").css("margin", "0px 0px 5px 10px");

});

function expand_my_mail(mode) {
    var state_down = $(".expand-my-mail").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-my-mail").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
        }
        else {
            $(".expand-my-mail").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        }
        $(".my-mail-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-my-mail").html("<i class='fa fa-chevron-up'></i>");
        $(".my-mail-section").slideDown();
    }
    else if(mode == "colapse") {
        $(".expand-my-mail").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        $(".my-mail-section").slideUp();
    }
}

function expand_my_calendar(mode) {
    var state_down = $(".expand-my-calendar").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-my-calendar").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
        }
        else {
            $(".expand-my-calendar").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        }
        $(".my-calendar-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-my-calendar").html("<i class='fa fa-chevron-up'></i>");
        $(".my-calendar-section").slideDown();
    }
    else if(mode == "colapse") {
        $(".expand-my-calendar").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        $(".my-calendar-section").slideUp();
    }
}

function expand_my_statements(mode) {
    var state_down = $(".expand-my-statements").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-my-statements").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
        }
        else {
            $(".expand-my-statements").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        }
        $(".my-statements-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-my-statements").html("<i class='fa fa-chevron-up'></i>");
        $(".my-statements-section").slideDown();
    }
    else if(mode == "colapse") {
        $(".expand-my-statements").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        $(".my-statements-section").slideUp();
    }
}