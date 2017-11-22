$(document).ready(function () {
    var form_attachment_message = new FormData();
    $('.message-inbox-task').on('click', '.non-read', function () {
        var non_read = $(this);
        var message_id = non_read.data('message');
        var message_type = non_read.data('type-message');
        //if (message_type == 'task') {
            $.ajax({
                    url: 'update_readed_message_task.json',
                    type: 'PUT',
                    data: {message_id: message_id, message_type: message_type}
                })
                .done(function (data) {
                    non_read.removeClass('non-read');
                    non_read.off("click");
                    //var temp_notification = $('.notification-message-' + message_id);
                    //if (temp_notification.length > 0) {
                    //    temp_notification.remove();
                    //    $('.number-new-messages-notification').text(($('.number-new-messages-notification').text() - 1) <= 0 ? 0 : $('.number-new-messages-notification').text() - 1);
                    //}
                    //var number_new_messages = ($('.number-new-messages:first').text() - 1) <= 0 ? 0 : $('.number-new-messages:first').text() - 1;
                    //$('.number-new-messages').text(number_new_messages);
                });
        //}
    });

    $(".message-inbox-task .star-priority").toggle(
        function () {
            $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
            $(".new-message-task .message-priority").val('1');
        },
        function () {
            $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
            $(".new-message-task .message-priority").val('2');
        },
        function () {
            $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
            $(".new-message-task .message-priority").val('0');
        }
    );

    $('.message-inbox-task .mark-message').on('click', function (event) {
        var message_id = $(this).data('message-tag-id');
        var mark_type = $(this).data('type-message');

        if ($(this).hasClass('icon-yellow')) {
            mark_message_task(message_id, mark_type, false);
            $(this).removeClass('icon-yellow').addClass('icon-gray');
            return false;
        }
        if ($(this).hasClass('icon-gray')) {
            mark_message_task(message_id, mark_type, true);
            $(this).removeClass('icon-gray').addClass('icon-yellow');
            return false;
        }
    });

    $('.message-inbox-task').on('click', '.delete-message', function(){
        var deleted = $(this);
        var message_id = deleted.data('message');
        var message_type = deleted.data('type-message');
        bootbox.dialog({
            message: "Are you sure?",
            title: "Remove message",
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
                                url: 'destroy_message.json',
                                type: 'DELETE',
                                data: {message_id: message_id, message_type: message_type, hard_delete: true}
                            })
                            .done(function (data) {
                                deleted.parents('.wrap-full-message:first').remove();
                                if ($('.wrap-full-message').length == 0) {
                                    location.reload();
                                }
                            });
                    }
                }
            }
        });
     });

    $('.send-new-message-task').on('click', function () {
        var multiselect = $(".new-message-task .multi-select-new-message-to");
        var body = $(".new-message-task .message-body").val();
        var required = false;

        if (multiselect.val() === null) {
            $.jGrowl("Name field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            required = true;
        }

        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            required = true;
        }

        if (required) {
            return false;
        }

        var all_to = multiselect.val() != null ? multiselect.val() : [];
        $.each(all_to, function (index, value) {
            form_attachment_message.append('to[]', value);
        });
        var subject = $(".new-message-task .message-subject").val();
        var urgent = $(".new-message-task .message-priority").val();
        var current_task = $(this).data('task');
        form_attachment_message.append('subject', subject);
        form_attachment_message.append('body', body);
        form_attachment_message.append('urgent', urgent);
        form_attachment_message.append('task', current_task);
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
                            form_attachment_message.append('template_mail', template_edited);
                            save_message_task(form_attachment_message);
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
        save_message_task(form_attachment_message);
        form_attachment_message = new FormData();
    });

    /*$('.message-inbox-task .reply-message, .dashboard-home .reply-message').on('click', function(){
     $('.reply').remove();
     var textarea_body = $('.new-message-task .message-body').clone();
     var message_id = $(this).data('message');
     textarea_body.addClass('reply-message-'+ message_id);
     var html_reply_body = '<div class="form-group body">'+ textarea_body[0].outerHTML  + '</div>';
     var html_reply_submit = '<div class="text-right">'+
     '<div class="btn btn-default cancel-new-reply" href="#" data-message="' + message_id + '">Cancel</div>'+
     '<div class="btn btn-primary send-new-reply" href="#" data-message="' + message_id + '">Send</div>'+
     '</div>';
     var html_reply = '<div class="row"><div class="col-md-12 reply box wrap-message-' + message_id + '"><div class="form-group">' +
     html_reply_body +html_reply_submit +'</div></div></div>';
     $(this).parents('.wrap-full-message:first').after(html_reply);
     });

     $( ".message-inbox-task, .dashboard-home" ).on('click','.cancel-new-reply', function(){
     var message_id = $(this).data('message');
     $('.message-inbox-task .wrap-message-' + message_id).remove();
     });

     $( ".message-inbox-task, .dashboard-home" ).on('click','.send-new-reply', function(){
     var message_id = $(this).data('message');
     var body = $(this).parents('.wrap-message-' + message_id).find('.message-body').val()
     var form_attachment_message = form_attachment_message;
     form_attachment_message.append('body', body);
     form_attachment_message.append('message_id', message_id);
     $.ajax({
     url: 'add_reply_message_task.json',
     type: 'POST',
     data: form_attachment_message,
     contentType:false,
     processData: false
     })
     .done(function(data) {
     location.href = location.pathname + '?message=' + data.id + '&reply=true&type=inbox';
     });
     });*/

    function handleFileUpload(files) {
        for (var i = 0; i < files.length; i++) {
            form_attachment_message.append('file[]', files[i]);
        }
    }

    $('.message-inbox-task .attach-file-message').change(function (evt) {
        handleFileUpload(evt.target.files);
    });

    $('.redirect_move_record').bind('click', '.selector', function (event) {
        window.location = $(this).attr('href');
    });

});

function mark_message_task(message_id, mark_type, unmark) {
    $.ajax({
            url: '/mark_message_task.json',
            type: 'PUT',
            data: {message_id: message_id, unmarked: unmark, mark_type: mark_type},
        })
        .done(function () {
            $.jGrowl("Message updated.", {header: 'Success', theme: 'success-jGrowl'});
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });

}


function save_message_task(form_attachment_message) {
    $.ajax({
            url: '/messages_tasks.json',
            type: 'POST',
            data: form_attachment_message,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            $('.wrap-new-message').find('input,textarea,select').val('');
            $('.wrap-new-message').find('select option').removeAttr('selected');
            $('a.search-choice-close').trigger('click');
            $(".multi-select-new-message-to").trigger("chosen:updated");
            $(".message-inbox-task .star-priority").addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
            $.jGrowl("Message sent.", {header: 'Success', theme: 'success-jGrowl'});
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}
