$(document).ready(function () {
    var id_user = $('.dropdown-assign-user-role').val();

    $(".dropdown-assign-user-role").change(function () {
        id_user = $('.dropdown-assign-user-role').val();
        $("#unassigned-user-role option").each(function () {
            $(this).val();
        }).remove();
        $("#assigned-user-role option").each(function () {
            $(this).val();
        }).remove();
        get_roles();
    });

    function get_roles() {
        $.ajax({
            url: '/role_users/get_roles.json',
            type: 'GET',
            data: {
                id: id_user
            }
        }).done(function (data) {
            $.each(data.assign, function (i, item) {
                $('#assigned-user-role').append($('<option>', {
                    value: item.id,
                    text: item.description
                }));
            });
            $.each(data.unassign, function (i, item) {
                $('#unassigned-user-role').append($('<option>', {
                    value: item.id,
                    text: item.description
                }));
            });
        }).fail(function (data) {
            error_permissions();
        });
    }

    if ($(".dropdown-assign-user-role").length > 0) {
        get_roles();
    }

    $('#add_one_user_role').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_role = $('#unassigned-user-role').val();
            if (id_role != null) {
                $.ajax({
                    url: '/role_users/new',
                    type: 'POST',
                    data: {
                        user_id: id_user,
                        role_id: id_role
                    }
                }).done(function (data) {
                    $("#assigned-user-role").append($("#unassigned-user-role").find('option:selected').remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#add_all_user_role').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_role = $.map($("#unassigned-user-role option"), function (a) {
                return a.value;
            });
            if (id_role != null) {
                $.ajax({
                    url: '/role_users/new',
                    type: 'POST',
                    data: {
                        user_id: id_user,
                        role_id: id_role
                    }
                }).done(function (data) {
                    $("#assigned-user-role").append($("#unassigned-user-role option").each(function () {
                        $(this).val();
                    }).remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#remove_one_user_role').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_role = $('#assigned-user-role').val();
            if (id_role != null) {
                $.ajax({
                    url: '/role_users/remove',
                    type: 'DELETE',
                    data: {
                        user_id: id_user,
                        role_id: id_role
                    }
                }).done(function (data) {
                    $("#unassigned-user-role").append($("#assigned-user-role").find('option:selected').remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });

    $('#remove_all_user_role').on('click', function () {
        if (typeof id_user != 'undefined') {
            var id_role = $.map($("#assigned-user-role option"), function (a) {
                return a.value;
            });
            if (id_role != null) {
                $.ajax({
                    url: '/role_users/remove',
                    type: 'DELETE',
                    data: {
                        user_id: id_user,
                        role_id: id_role
                    }
                }).done(function (data) {
                    $("#unassigned-user-role").append($("#assigned-user-role option").each(function () {
                        $(this).val();
                    }).remove());
                }).fail(function (data) {
                    error_permissions();
                });
            }
        }
    });
});