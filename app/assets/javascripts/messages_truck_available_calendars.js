$(document).ready(function () {
    var form_attachments_truck_available_calendar = new FormData();

    $('body').on('click', '.calendar-truck-available .send-new-truck-available-calendar, .calendar-truck .send-new-truck-available-calendar', function () {
        var temp_calendar = $(this).hasClass('calendar-truck-available') ? $('#calendar-truck-available') : $('#calendar-truck');
        var body = $(".new-truck-available-calendar .message-body").val();
        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            return false;
        }
        $(this).data('truck-available-calendar') === undefined ? '' : form_attachments_truck_available_calendar.append('truck', $(this).data('truck-available-calendar'));
        var subject = $(".new-truck-available-calendar .message-subject").val();
        var urgent = $(".new-truck-available-calendar .message-priority").val();
        var date_calendar = temp_calendar.fullCalendar('getDate').format('YYYY-MM-DD');
        form_attachments_truck_available_calendar.append('subject', subject);
        form_attachments_truck_available_calendar.append('body', body);
        form_attachments_truck_available_calendar.append('urgent', urgent);
        form_attachments_truck_available_calendar.append('date_calendar', date_calendar);
        save_message_truck_available_calendar(form_attachments_truck_available_calendar, temp_calendar);
    });

});

function save_message_truck_available_calendar(form_attachments_truck_available_calendar, calendar) {
    $.ajax({
            url: '/messages_truck_available_calendars.json',
            type: 'POST',
            data: form_attachments_truck_available_calendar,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            location.href = location.href.replace(/&message_calendar=([^&amp;#]*)/, "").replace(/&date_calendar=([^&amp;#]*)/, "&date_calendar=" + calendar.fullCalendar('getDate').format('YYYY-MM-DD')) + '&message_calendar=' + data.id;
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}
