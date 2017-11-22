$(document).ready(function () {
    var form_attachments_truck_calendar = new FormData();
    $(".multi-select-new-message-to").chosen({search_contains: true});

    $('body').on('click', '.send-new-message-truck-calendar', function () {
        var body = $(".new-message-truck-calendar .message-body").val();
        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            return false;
        }
        var truck_calendar = $(this).data('truck-calendar');
        var all_to = $(".new-message-truck-calendar .multi-select-new-message-to").val() != null ? $(".new-message-truck-calendar .multi-select-new-message-to").val() : [];
        $.each(all_to, function (index, value) {
            form_attachments_truck_calendar.append('to[]', value);
        });
        var subject = $(".new-message-truck-calendar .message-subject").val();
        var urgent = $(".new-message-truck-calendar .message-priority").val();
        var date_calendar = $('#calendar-move-record').fullCalendar('getDate').format('YYYY-MM-DD');
        form_attachments_truck_calendar.append('truck_calendar', truck_calendar);
        form_attachments_truck_calendar.append('subject', subject);
        form_attachments_truck_calendar.append('body', body);
        form_attachments_truck_calendar.append('urgent', urgent);
        form_attachments_truck_calendar.append('date_calendar', date_calendar);
        if (false) {
            var html_template_email = '<textarea class="form-control wysihtml5 template_edited_message" required="required" rows="20" placeholder="Your message..." >' +
                body +
                '</textarea>'
            bootbox.dialog({
                className: "modal-custom-lg",
                message: html_template_email,
                title: "Email Content Preview",
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
                        label: "Confirm",
                        className: "btn-primary",
                        callback: function () {
                            var template_edited = $('.template_edited_message').val();
                            form_attachments_truck_calendar.append('template_mail', template_edited);
                            save_message_record(form_attachments_truck_calendar);
                            form_attachment_message = new FormData();
                        }
                    }
                }
            });
            $('.wysihtml5').wysihtml5({
                "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
                "emphasis": true, //Italics, bold, etc. Default true
                "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
                "html": false, //Button which allows you to edit the generated HTML. Default false
                "link": true, //Button to insert a link. Default true
                "image": true, //Button to insert an image. Default true,
                "color": true //Button to change color of font
            });
            return false;
        }
        save_message_record(form_attachments_truck_calendar);
        form_attachment_message = new FormData();
    });

    function handleFileUpload(files) {
        for (var i = 0; i < files.length; i++) {
            form_attachments_truck_calendar.append('file[]', files[i]);
        }
    }

    $('body').on('change', '.attach-file-message', function (evt) {
        handleFileUpload(evt.target.files);
    });

    $('body').on('change', '.multi-select-new-message-to', function (evt, params) {
        if (params.selected === 'staff_all') {
            $(this).find('option[value="staff_all"] ~ option').attr('disabled', true);
        } else {
            $(this).find('option[value="staff_all"] ~ option').attr('disabled', false);
        }
        $(this).trigger("chosen:updated");
    });

});

function save_message_record(form_attachments_truck_calendar) {
    $.ajax({
            url: '/messages_truck_calendars.json',
            type: 'POST',
            data: form_attachments_truck_calendar,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            location.href = location.href.replace(/&message_calendar=([^&amp;#]*)/, "").replace(/&date_calendar=([^&amp;#]*)/, "&date_calendar=" + $('#calendar-move-record').fullCalendar('getDate').format('YYYY-MM-DD')) + '&message_calendar=' + data.id;
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}
