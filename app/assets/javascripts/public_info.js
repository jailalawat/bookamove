$(document).ready(function () {
    var form_attachments = new FormData();
    $(".multi-select-new-message-to-public").chosen({search_contains: false});

    $(".new-message-move-record-public .star-priority").toggle(
        function () {
            $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "#E1E11E"});
            $(".new-message-move-record-public .message-priority").val('1');
        },
        function () {
            $(this).removeClass('icon-star-empty').addClass('icon-star').css({"color": "red"});
            $(".new-message-move-record-public .message-priority").val('2');
        },
        function () {
            $(this).addClass('icon-star-empty').removeClass('icon-star').css({"color": "black"});
            $(".new-message-move-record-public .message-priority").val('0');
        }
    );

    $('.send-new-message-move-record-public').on('click', function () {
        var form_files = form_attachments;
        var body = $(".new-message-move-record-public .message-body").val();

        if ($.trim(body) === '') {
            $.jGrowl("Message field is required.", {header: 'Required', theme: 'error-jGrowl', life: 6000});
            return false;
        }

        var move_record = $(this).data('move-record');
        var all_to = $(".new-message-move-record-public .multi-select-new-message-to-public").val() != null ? $(".new-message-move-record-public .multi-select-new-message-to-public").val() : [];
        form_files.append('to[]', all_to);
        var subject = $(".new-message-move-record-public .message-subject").val();

        var urgent = $(".new-message-move-record-public .message-priority").val();
        form_files.append('move_record', move_record);
        form_files.append('subject', subject);
        form_files.append('body', body);
        form_files.append('urgent', urgent);
        save_message_record_public(form_files);
    });


    function handleFileUpload(files) {
        for (var i = 0; i < files.length; i++) {
            form_attachments.append('file[]', files[i]);
        }
    }

    $('.attach-file-message').change(function (evt) {
        handleFileUpload(evt.target.files);
    });

    go_to_message();
});

function go_to_message() {
    var type_message = new RegExp('type=message').exec(window.location.href);
    if (type_message !== null) {
        $("body, html").animate({
            scrollTop: $('.new-message-move-record-public').offset().top - 145
        }, 600);
    }
    return false;
}

function save_message_record_public(form_files) {
    $.ajax({
            url: '/messages_move_records_public.json',
            type: 'POST',
            data: form_files,
            contentType: false,
            processData: false
        })
        .done(function (data) {
            location.href = location.pathname + '?message=' + data.id;
        })
        .fail(function () {
            $.jGrowl("Error. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        });
}

function showLabel(elem) {
    document.getElementById(elem).style.visibility = 'visible';
}
