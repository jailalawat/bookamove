$(document).ready(function () {
    var form_attachments_staff_available_calendar = new FormData();

    $('body').on('click', '.calendar-staff-available .send-new-staff-available-calendar', function () {
        var body = $(".new-staff-available-calendar .message-body").val();
        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            return false;
        }
        $(this).data('staff-available-calendar') === undefined ? '' : form_attachments_staff_available_calendar.append('staff_id', $(this).data('staff-available-calendar'));
        var subject = $(".new-staff-available-calendar .message-subject").val();
        var urgent = $(".new-staff-available-calendar .message-priority").val();
        var date_calendar = $('#calendar-staff-available').fullCalendar('getDate').format('YYYY-MM-DD');
        form_attachments_staff_available_calendar.append('subject', subject);
        form_attachments_staff_available_calendar.append('body', body);
        form_attachments_staff_available_calendar.append('urgent', urgent);
        form_attachments_staff_available_calendar.append('date_calendar', date_calendar);
        save_message_staff_available_calendar(form_attachments_staff_available_calendar);
    });

});

function save_message_staff_available_calendar(form_attachments_staff_available_calendar) {
    $.ajax({
            url: '/messages_staff_available_calendars.json',
            type: 'POST',
            data: form_attachments_staff_available_calendar,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            location.href = location.href.replace(/&message_calendar=([^&amp;#]*)/, "").replace(/&date_calendar=([^&amp;#]*)/, "&date_calendar=" + $('#calendar-staff-available').fullCalendar('getDate').format('YYYY-MM-DD')) + '&message_calendar=' + data.id;
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}
