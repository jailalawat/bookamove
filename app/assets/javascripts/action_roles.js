$(document).ready(function () {
    var id_role = $('.dropdown-assign-role-action').val();

    $(".dropdown-assign-role-action").change(function () {
        id_role = $('.dropdown-assign-role-action').val();
        //$("#unassigned-role option").each(function () {
        //    $(this).val();
        //}).remove();
        $("#unassigned-role option").each(function () {
            $(this).prop("disabled", true);
        });
        $("#assigned-role option").each(function () {
            $(this).val();
        }).remove();
        get_actions();
    });

    function get_actions() {
        $.ajax({
            url: '/action_roles/get_actions.json',
            type: 'GET',
            data: {
                id: id_role
            }
        }).done(function (data) {
            if(data.assign.length > 0){
                $('#assigned-role').append('<option class="group_header bold calendars vk_blue_bg" value="">Calendars</option><option class="group_header bold settings" value="">Settings</option><option class="group_header bold company_profile" value="">Profiles</option><option class="group_header bold move_records" value="">Move records</option>');
            }

            var a_opt, b_opt;
            $.each(data.assign, function (i, item) {
                //$('#assigned-role').append($('<option>', {
                //    value: item.id,
                //    text: item.description
                //}));
                b_opt = $('<option>', {
                    value: item.id,
                    text: item.role_level +" "+ item.description
                });
                if(item.group == "Calendars") {
                    b_opt.insertAfter( "#assigned-role .calendars" );
                }
                else if(item.group == "Settings") {
                    b_opt.insertAfter( "#assigned-role .settings" );
                }
                else if(item.group == "Profiles") {
                    b_opt.insertAfter( "#assigned-role .company_profile" );
                }
                else if(item.group == "Move records") {
                    b_opt.insertAfter( "#assigned-role .move_records" );
                }
            });
            $.each(data.unassign, function (i, item) {
                var opts = $('#unassigned-role option[value="' + item.id + '"]');
                opts.prop("disabled", false);
            });
        });
    }

    if ($(".dropdown-assign-role-action").length > 0) {
        get_actions();
    }

    $('#add_one_role').on('click', function () {
        if (typeof id_role != 'undefined') {
            var id_action = $('#unassigned-role').val();
            if (id_action != null) {
                $.ajax({
                    url: '/action_roles/new',
                    type: 'POST',
                    data: {
                        role_id: id_role,
                        action_id: id_action
                    }
                }).done(function (data) {
                    //$("#assigned-role").append($("#unassigned-role").find('option:selected').remove());
                    var opts = $("#unassigned-role").find('option:selected');
                    opts.prop("disabled", true);
                    $("#assigned-role").append($("<option></option>").attr("value",opts.attr("value")).text(opts.text()));
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#add_all_role').on('click', function () {
        if (typeof id_role != 'undefined') {
            var id_action = $.map($("#unassigned-role option"), function (a) {
                return a.value;
            });
            if (id_action != null) {
                $.ajax({
                    url: '/action_roles/new',
                    type: 'POST',
                    data: {
                        role_id: id_role,
                        action_id: id_action
                    }
                }).done(function (data) {
                    //$("#assigned-role").append($("#unassigned-role option").each(function () {
                    //    $(this).val();
                    //}).remove());

                    $("#unassigned-role option").each(function () {
                        $(this).prop("disabled", true);
                        $("#assigned-role").append($("<option></option>").attr("value",$(this).attr("value")).text($(this).text()));
                    });
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#remove_one_role').on('click', function () {
        if (typeof id_role != 'undefined') {
            var id_action = $('#assigned-role').val();
            if (id_action != null) {
                $.ajax({
                    url: '/action_roles/remove',
                    type: 'DELETE',
                    data: {
                        role_id: id_role,
                        action_id: id_action
                    }
                }).done(function (data) {
                    //$("#unassigned-role").append($("#assigned-role").find('option:selected').remove());
                    var opts = $("#assigned-role").find('option:selected');
                    opts.remove();
                    var opts2 = $('#unassigned-role option[value="' + opts.attr("value") + '"]');
                    opts2.prop("disabled", false);
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#remove_all_role').on('click', function () {
        if (typeof id_role != 'undefined') {
            var id_action = $.map($("#assigned-role option"), function (a) {
                return a.value;
            });
            if (id_action != null) {
                $.ajax({
                    url: '/action_roles/remove',
                    type: 'DELETE',
                    data: {
                        role_id: id_role,
                        action_id: id_action
                    }
                }).done(function (data) {
                    //$("#unassigned-role").append($("#assigned-role option").each(function () {
                    //    $(this).val();
                    //}).remove());

                    $("#assigned-role option").each(function () {
                        $(this).remove();
                        $('#unassigned-role option[value="' + $(this).attr("value") + '"]').prop("disabled", false);
                    });
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#default_role_permissions').on('click', function () {
        if (typeof id_role != 'undefined') {
            window.location = '/return_to_default_role_permissions?id=' + id_role;
        }
    });
});