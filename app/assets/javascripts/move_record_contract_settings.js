'use strict';
var enabled_icon = 'fa fa-check-circle icon-green disable';
var disabled_icon = 'fa fa-times icon-red enable';
var row_selectors = {
    number_of_clients: '.client-row',
    number_of_trucks: '.truck-row',
    number_of_origin: '.origin-row',
    number_of_destination: '.destination-row',
    number_of_date: '.date-row'
};

$(document).ready(function () {
    $('.add-line').click(function () {
        var key = $(this).attr('field');
        if ($(row_selectors[key]).length >= 3) return false;
        var data = build_data(key, 1);
        update_field(data).done(function () {
            var temp_row_html = $(row_selectors[key]).clone();
            temp_row_html.find('label').append(' ' + ($(row_selectors[key]).length + 1));
            $(row_selectors[key] + ':last').after('<div class="row ' + row_selectors[key].replace(".", '') + '">' + temp_row_html.html() + '</div>');
        });
    });

    $('.remove-line').click(function () {
        var key = $(this).attr('field');
        var data = build_data(key, -1);
        update_field(data).done(function () {
            if ($(row_selectors[key]).length > 1)
                $(row_selectors[key] + ':last').remove();
        });
    });

    $('body').on('change', '.contract-settings .change-select', function () {
        var data = build_data($(this).attr('data_id'), $(this).val());
        var selector = $(this);
        update_field(data).done(function () {
            $('[name="' + selector.attr('name') + '"]').val(selector.val());
        });
    });

    $('body').on('click', '.contract-settings .disable', function () {
        var data = build_data($(this).attr('field'), false);
        var selector = $(this);
        update_field(data).done(function () {
            toggle_icon(selector.attr('field'), disabled_icon);
        });
    });

    $('body').on('click', '.contract-settings .enable', function () {
        var selector = $(this);
        var data = build_data($(this).attr('field'), true);
        update_field(data).done(function () {
            toggle_icon(selector.attr('field'), enabled_icon);
        });
    });

    $('body').on('change', '.contract-settings .change-checked', function () {
        var data = build_data($(this).attr('field'), $(this).is(':checked'));
        update_field(data);
    });

    $('body').on('click', '.edit-dropdown-contract-settings', function (event) {
        var field = $(this).attr('field');
        var dialog = bootbox.dialog({
            message: '<div class="data_dropdown col-md-12 form-group"></div>',
            title: "Edit Values",
            closeButton: true,
            buttons: {
                cancel: {
                    label: "Close",
                    className: "btn-default",
                    callback: function () {
                        $(this).modal('hide');
                    }
                }
            }
        });
        dialog.init(function(){
            setTimeout(function(){
                data_dropdown(field);
            }, 100);
        });
    });

    $('body').on('click', '.new-data-dropdown', function (event) {
        var new_value = $(this).closest('tr').find('input').val();
        if ($.trim(new_value) == '') return $.jGrowl("Description field is required.", {
            header: 'Error',
            theme: 'error-jGrowl'
        });
        new_data_dropdown($(this).data('edit-key'), new_value);
    });

    $('body').on('change', '[name="default_dropdown"]', function () {
        var data = build_data($(this).attr('data-default-key'), $(this).val());
        var selector = $(this);
        update_field(data).done(function () {
            $('i[data-default-key="' + selector.attr('data-default-key') + '"]').attr('data-default', selector.val());
            $.jGrowl("Contract Settings Updated.", {header: 'Success', theme: 'success-jGrowl'});
        });
    });

    $('body').on('change', '.update-data-dropdown', function () {
        update_data_dropdown($(this).attr('data-edit-key'), $(this).is(':checked'), $(this).val());
    });

});

function build_data(key, value) {
    var data = {};
    data[key] = value;
    return data;
}

function update_field(action) {
    return $.ajax({
        url: '/contract_settings',
        type: 'PUT',
        data: action,
    }).fail(function (data) {
        error_permissions();
    });
}

function toggle_icon(selector, css_class) {
    $("[field=" + selector + "]").attr('class', css_class);
}

function data_dropdown(edit_key, move_source_id) {
    var default_value = $('[field="' + edit_key + '"]').attr('data-default');
    var default_key = $('[field="' + edit_key + '"]').attr('data-default-key');

    if (edit_key != "move_subsources") {
        $.ajax({
            url: '/data_edit_dropdown.json',
            type: 'GET',
            data: {edit_key: edit_key}
        }).done(function (data) {
            var temp_html = '<table class="table table-hover table-striped"><tr><th>Description</th><th>Active</th><th>Default</th></tr>';
            for (var i in data) {
                temp_html += '<tr>' +
                    '<td>' + data[i].description + '</td>' +
                    '<td><input class="update-data-dropdown" type="checkbox" ' + (data[i].active === true ? 'checked' : '') + ' data-edit-key="' + edit_key + '" value="' + data[i].id + '"';
                if (edit_key == "calendar_truck_groups") {
                    temp_html += ' onclick="return false"></td>';
                } else {
                    temp_html += '></td>';
                }
                temp_html += '<td><i class="fa fa-lock pop_lock pointer ' + (data[i].id.toString() === default_value ? 'icon-green' : 'icon-red') + '" onclick="$(this).next().click(); $(\'.pop_lock\').removeClass(\'icon-green\').addClass(\'icon-red\'); $(this).addClass(\'icon-green\');"></i> <input class="hidden" value="' + data[i].id + '" type="radio" name="default_dropdown" ' + (data[i].id.toString() === default_value ? 'checked' : '') + ' data-default-key="' + default_key + '"></td>' +
                    '</tr>';
            }
            var html_add_new = "", note = "";
            if (edit_key != "calendar_truck_groups") {
                html_add_new = '<tr>' +
                    '<td><input type="text" class="form-control input-sm" placeholder="Description"></td>' +
                    '<td colspan="2"><div class="btn btn-success new-data-dropdown" data-edit-key="' + edit_key + '"> Add new value</div></td>' +
                    '</tr>';
                note = '<b><div class="textOrange text-center">Note: New drop down values may not be deleted.</div></b>'
            }

            $('.data_dropdown').html(temp_html + html_add_new + '</table>' + note);
        }).fail(function (data) {
            $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
        });
    }
    // source/soubsource II-tire
    else {
        pull_sub_sources_by_source(edit_key, move_source_id);
    }
}

function pull_sub_sources_by_source(edit_key, move_source_id) {
    var default_value = $('[field="' + edit_key + '"]').attr('data-default');
    var default_key = $('[field="' + edit_key + '"]').attr('data-default-key');

    $.ajax({
        url: '/data_edit_dropdown.json',
        type: 'GET',
        data: {edit_key: "move_sources"}
    }).done(function (data0) {
        var temp_html = '<table class="table table-hover table-striped"><tr><th>Description</th><th>Active</th><th>Default</th></tr>';

        $.ajax({
            url: '/data_edit_dropdown.json',
            type: 'GET',
            data: {edit_key: "move_subsources", source_id: move_source_id}
        }).done(function (data) {
            for (var i in data) {
                temp_html += '<tr>' +
                    '<td>' + data[i].description + '</td>' +
                    '<td><input class="update-data-dropdown" type="checkbox" ' + (data[i].active === true ? 'checked' : '') + ' data-edit-key="' + edit_key + '" value="' + data[i].id + '" ></td>' +
                    '<td><i class="fa fa-lock pop_lock pointer ' + (data[i].id.toString() === default_value ? 'icon-green' : 'icon-red') + '" onclick="$(this).next().click(); $(\'.pop_lock\').removeClass(\'icon-green\').addClass(\'icon-red\'); $(this).addClass(\'icon-green\');"></i> <input class="hidden" value="' + data[i].id + '" type="radio" name="default_dropdown" ' + (data[i].id.toString() === default_value ? 'checked' : '') + ' data-default-key="' + default_key + '"></td>' +
                    '</tr>';
            }

            var sources = "";
            var is_selected = "";
            for (var i in data0) {
                if (data0[i].active == true) {
                    if (data0[i].id.toString() === move_source_id)
                        is_selected = "selected";
                    else
                        is_selected = "";
                    sources += ("<option value='" + data0[i].id + "' "+ is_selected +">" + data0[i].description + "</option>");
                }
                console.log("id: "+ data0[i].id.toString());
                console.log("move_source_id_list: "+ move_source_id);
            }

            var html_add_new = '<tr>' +
                '<td colspan="3"><table width="100%"><tr><td style="vertical-align: middle; border: 0; padding-left: 0;">' +
                '<b style="color: #000">Source:</b></td><td style="width: 100%; border: 0; padding-right: 0;">' +
                '<select id="soure_for_subsource" name="source_id" class="form-control input-sm" onchange="pull_sub_sources_by_source(\'move_subsources\', $(\'#soure_for_subsource\').val())">' + sources + '</select></td></tr><tr>' +
                '<td align="center" style="border: 0"><i class="fa fa-long-arrow-up" aria-hidden="true"></i>' +
                '<i class="fa fa-long-arrow-down" aria-hidden="true"></i></td>' +
                '<td style="border: 0">Select <b>source</b> for it\'s <b>sub-sources</b></td></tr></table></td>' +
                '</tr>';
            html_add_new += '<tr>' +
                '<td colspan="3"><table width="100%"><tr><td style="vertical-align: middle; border: 0; padding-left: 0; white-space: nowrap">' +
                '<b style="color: #000">Sub-Source:</b></td><td style="width: 100%; border: 0;">' +
                '<input type="text" class="form-control input-sm" placeholder="Description"></td>' +
                '<td style="border: 0; padding-right: 0;"><div class="btn btn-success new-data-dropdown" data-edit-key="' + edit_key + '"> Add new value</div></td></tr></table>' +
                '</td></tr>';
            $('.data_dropdown').html(temp_html + html_add_new + '</table><b><div class="textOrange text-center">Note: New drop down values may not be deleted.</div></b>');
        });

    }).fail(function (data) {
        $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
    });
}

function new_data_dropdown(edit_key, new_value) {
    $.ajax({
        url: '/new_data_dropdown.json',
        type: 'POST',
        data: {
            edit_key: edit_key,
            new_value: new_value,
            source_id: $('#soure_for_subsource').val()
        }
    }).done(function (data) {
        data_dropdown(edit_key, $('#soure_for_subsource').val());
        $.jGrowl("New data added.", {header: 'Success', theme: 'success-jGrowl'});
    }).fail(function (data) {
        $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
    });
}

function update_data_dropdown(edit_key, new_value, data_dropdown_id) {
    $.ajax({
        url: '/update_data_dropdown.json',
        type: 'PUT',
        data: {
            edit_key: edit_key,
            new_value: new_value,
            data_dropdown_id: data_dropdown_id
        }
    }).done(function (data) {
        $.jGrowl("Contract Settings Updated.", {header: 'Success', theme: 'success-jGrowl'});
    }).fail(function (data) {
        $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
    });
}
