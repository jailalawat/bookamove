var redirect_to_loc = true;
var token;

$(document).ready(function () {
    var form_attachments = new FormData();
    $(".multi-select-new-message-to").chosen({search_contains: true});

    $(".new-message-move-record .star-priority").toggle(
        function () {
            $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
            $(".new-message-move-record .message-priority").val('1');
        },
        function () {
            $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
            $(".new-message-move-record .message-priority").val('2');
        },
        function () {
            $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
            $(".new-message-move-record .message-priority").val('0');
        }
    );

    $('.send-new-message-move-record').on('click', function () {
        var form_files = form_attachments;
        var body = $(".new-message-move-record .message-body").val();

        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            return false;
        }

        var move_record = $(this).data('move-record');
        token = $(this).data('token');
        var all_to = $(".new-message-move-record .multi-select-new-message-to").val() != null ? $(".new-message-move-record .multi-select-new-message-to").val() : [];
        $.each(all_to, function (index, value) {
            form_files.append('to[]', value);
        });
        var subject = $(".new-message-move-record .message-subject").val();

        var urgent = $(".new-message-move-record .message-priority").val();
        form_files.append('move_record', move_record);
        form_files.append('subject', subject);
        form_files.append('body', body);
        form_files.append('urgent', urgent);
        if (all_to.join().match(/(driver|customer)/)) {
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
                            form_files.append('message_type', 'email');
                            form_files.append('template_mail', template_edited);
                            save_messages_record(form_files);
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
        save_messages_record(form_files);
    });


    $('.send-new-call-move-record').on('click', function (event, auto_save) {
        var form_files = form_attachments;
        var body = $(".new-message-move-record .message-body-call").val();

        if (get_first_phone() == undefined) {
            $.jGrowl("There is no phone specified. Enter a phone first and try again.", {
                header: 'Required',
                theme: 'error-jGrowl',
                life: 6000
            });
            return false;
        }

        call_save_btn_clicked = true;

        var move_record = $(this).data('move-record');
        var to = $(".new-message-move-record .name-call").val();

        var subject = $(".new-message-move-record .message-subject-call").val();

        var urgent = $(".new-message-move-record .message-priority").val();
        form_files.append('move_record', move_record);
        form_files.append('to', to);
        form_files.append('subject', subject);
        form_files.append('body', body);
        form_files.append('urgent', urgent);
        form_files.append('message_type', "call");
        if (auto_save == "yes") {
            redirect_to_loc = false;
        }
        save_messages_record(form_files);
    });


    $('.message-inbox-move-record .reply-message-move-record').on('click', function () {
        $('.reply').remove();
        var textarea_body = $('.new-message-move-record .message-body').clone();
        var message_id = $(this).data('message');
        textarea_body.addClass('reply-message-' + message_id);
        var html_reply_body = '<div class="form-group body">' + textarea_body[0].outerHTML + '</div>';
        var html_reply_submit = '<div class="text-right">' +
            '<div class="btn btn-default cancel-new-reply-move-record" href="#" data-message="' + message_id + '">Cancel</div>' +
            '<div class="btn btn-primary send-new-reply-move-record" href="#" data-message="' + message_id + '">Send</div>' +
            '</div>';
        var html_reply = '<div class="row"><div class="col-md-12 reply box wrap-message-' + message_id + '"><div class="form-group">' +
            html_reply_body + html_reply_submit + '</div></div></div>';
        $(this).parents('.wrap-full-message:first').after(html_reply);
    });

    $(".message-inbox-move-record").on('click', '.cancel-new-reply-move-record', function () {
        var message_id = $(this).data('message');
        $('.message-inbox-move-record .wrap-message-' + message_id).remove();
    });

    $(".message-inbox-move-record").on('click', '.send-new-reply-move-record', function () {
        var message_id = $(this).data('message');
        var body = $(this).parents('.wrap-message-' + message_id).find('.message-body').val()
        form_files.append('body', body);
        form_files.append('message_id', message_id);
        $.ajax({
                url: '/add_reply_message_move_record.json',
                type: 'POST',
                data: form_files,
                contentType: false,
                processData: false
            })
            .done(function (data) {
                location.href = location.pathname + '?message=' + data.id + '&type=inbox';
            });
    });

    function handleFileUpload(files) {
        for (var i = 0; i < files.length; i++) {
            form_attachments.append('file[]', files[i]);
        }
    }

    $('.attach-file-message').change(function (evt) {
        handleFileUpload(evt.target.files);
    });

    $('.multi-select-new-message-to').on('change', function (evt, params) {
        if (params.selected === 'staff_all') {
            $(this).find('option[value="staff_all"] ~ option').attr('disabled', true);
        } else {
            $(this).find('option[value="staff_all"] ~ option').attr('disabled', false);
        }
        $(this).trigger("chosen:updated");
    });

    $('.btn-new-message').on('click', function (event) {
        event.preventDefault();
        if ($('.new-message-move-record').length > 0) {
            $("body, html").animate({
                scrollTop: $('.new-message-move-record').offset().top - 145
            }, 600);
            $('.message-body').focus();
            return;
        }
        location.href = '/messages?type=inbox';
    });
    go_to_message();
});

function go_to_message() {
    var type_message = new RegExp('type=message').exec(window.location.href);
    if (type_message !== null) {
        $("body, html").animate({
            scrollTop: $('.new-message-move-record').offset().top - 145
        }, 600);
    }
    return false;
}

function save_messages_record(form_files) {
    console.log(token);
    $.ajax({
            url: '/messages_move_records.json',
            type: 'POST',
            data: form_files,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            if (redirect_to_loc) {
                location.href = location.pathname + '?message=' + data.id + '&token=' + token;
            }
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}
