$(document).ready(function () {
    //$('.btn-add-subtask-group').on('click', function (event) {
    //    event.preventDefault();
    //    var name_subtask = $('.name-subtask-group').val();
    //    var description_subtask = $('.description-subtask-group').val();
    //    var active_subtask = $('.active-subtask-group').is(':checked');
    //    var mailbox = $('.mailbox-subtask-group').is(':checked');
    //    var task_group = $(this).data('taskgroup');
    //    $.ajax({
    //        url: '/add_subtask_group.json',
    //        type: 'POST',
    //        data: {
    //            name: name_subtask,
    //            description: description_subtask,
    //            active: active_subtask,
    //            mailbox: mailbox,
    //            taskgroup: task_group
    //        }
    //    }).done(function () {
    //        location.reload();
    //    }).fail(function (data) {
    //        error_permissions();
    //    })
    //});

    $('#btn_assign_cal_role').on('click', function (event) {
        event.preventDefault();
        var role_id = $("#assigned_role").val();
        var cal_id = $(this).data("calendar");
        if (role_id) {
            $.ajax({
                url: '/assign_calendar_role.json',
                type: 'PUT',
                data: {
                    role_id: role_id,
                    cal_id: cal_id
                }
            }).done(function (data) {
                $("#assigned_role option[value='"+ role_id +"']").hide(800);

                setTimeout(function() {
                    $("#no_roles").remove();

                    $("#cal_roles_table").append('<tr bgcolor="white"><td><a href="/roles/'+ data[0].id +'/edit">'+ data[0].name +'</a></td><td>'+ data[0].role_level +'</td><td><a href="/remove_calendar_role?role_id='+ data[0].id +'">remove</a></td></tr>');
                    $("#cal_roles_table tr:last").hide().slideToggle();
                }, 600);
            }).fail(function (data) {
                error_permissions();
            })
        }
    });

});