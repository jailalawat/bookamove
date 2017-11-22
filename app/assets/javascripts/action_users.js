$(document).ready(function () {
    var id_user = $('.dropdown-assign-user-action').val();

    $(".dropdown-assign-user-action").change(function () {
        id_user = $('.dropdown-assign-user-action').val();
        $("#unassigned-user option").each(function () {
            $(this).val();
        }).remove();
        $("#assigned-user option").each(function () {
            $(this).val();
        }).remove();
        get_actions();
    });

    function get_actions() {
        $.ajax({
            url: '/action_users/get_actions.json',
            type: 'GET',
            data: {
                id: id_user
            }
        }).done(function (data) {
            if(data.assign.length > 0){
                $('#assigned-user').append('<option class="group_header bold calendars vk_blue_bg" value="">Calendars</option><option class="group_header bold settings" value="">Settings</option><option class="group_header bold company_profile" value="">Profiles</option><option class="group_header bold move_records" value="">Move records</option>');
            }
            if(data.unassign.length > 0){
                $('#unassigned-user').append('<option class="group_header bold calendars vk_blue_bg" value="">Calendars</option><option class="group_header bold settings" value="">Settings</option><option class="group_header bold company_profile" value="">Profiles</option><option class="group_header bold move_records" value="">Move records</option>');
            }

            var a_opt, b_opt;
            $.each(data.assign, function (i, item) {
                //$('#assigned-user').append($('<option>', {
                //    value: item.id,
                //    text: item.description
                //}));
                b_opt = $('<option>', {
                    value: item.id,
                    text: item.description
                });
                if(item.group == "Calendars") {
                    b_opt.insertAfter( "#assigned-user .calendars" );
                }
                else if(item.group == "Settings") {
                    b_opt.insertAfter( "#assigned-user .settings" );
                }
                else if(item.group == "Profiles") {
                    b_opt.insertAfter( "#assigned-user .company_profile" );
                }
                else if(item.group == "Move records") {
                    b_opt.insertAfter( "#assigned-user .move_records" );
                }
            });
            $.each(data.unassign, function (i, item) {
                a_opt = $('<option>', {
                    value: item.id,
                    text: item.description
                });
                if(item.group == "Calendars") {
                    a_opt.insertAfter( "#unassigned-user .calendars" );
                }
                else if(item.group == "Settings") {
                    a_opt.insertAfter( "#unassigned-user .settings" );
                }
                else if(item.group == "Profiles") {
                    a_opt.insertAfter( "#unassigned-user .company_profile" );
                }
                else if(item.group == "Move records") {
                    a_opt.insertAfter( "#unassigned-user .move_records" );
                }
            });
        });
    }

    if ($(".dropdown-assign-user-action").length > 0) {
        get_actions();
    }
    $('#add_one_user').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_action = $('#unassigned-user').val();
            if (id_action != null) {
                $.ajax({
                    url: '/action_users/new',
                    type: 'POST',
                    data: {
                        user_id: id_user,
                        action_id: id_action
                    }
                }).done(function (data) {
                    $("#assigned-user").append($("#unassigned-user").find('option:selected').remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#add_all_role').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_action = $.map($("#unassigned-user option"), function (a) {
                return a.value;
            });
            if (id_action.length != 0) {
                $.ajax({
                    url: '/action_users/new',
                    type: 'POST',
                    data: {
                        user_id: id_user,
                        action_id: id_action
                    }
                }).done(function (data) {
                    $("#assigned-user").append($("#unassigned-user option").each(function () {
                        $(this).val();
                    }).remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#remove_one_user').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_action = $('#assigned-user').val();
            if (id_action != null) {
                $.ajax({
                    url: '/action_users/remove',
                    type: 'DELETE',
                    data: {
                        user_id: id_user,
                        action_id: id_action
                    }
                }).done(function (data) {
                    $("#unassigned-user").append($("#assigned-user").find('option:selected').remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#remove_all_role').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_action = $.map($("#assigned-user option"), function (a) {
                return a.value;
            });
            if (id_action.length != 0) {
                $.ajax({
                    url: '/action_users/remove',
                    type: 'DELETE',
                    data: {
                        user_id: id_user,
                        action_id: id_action
                    }
                }).done(function (data) {
                    $("#unassigned-user").append($("#assigned-user option").each(function () {
                        $(this).val();
                    }).remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });
});