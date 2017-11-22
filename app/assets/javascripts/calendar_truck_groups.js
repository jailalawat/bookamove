$(document).ready(function () {
    $(".multi-select-calendar-trucks").chosen({max_selected_options: 6});

    $('.truck-profile-form').on('click', '.search-choice', function (event) {
        var index_id = $(this).find('a').data('option-array-index');
        var truck_id = $('#calendar_truck_group_trucks option').eq(index_id).val();
        window.open(location.origin + "/trucks/" + truck_id + "/edit");
    });

    $("#sprovinces").on("change", function () {
        $.get("/get_city_by_province",
            {
                "province_id": $("#sprovinces").val()
            },
            function (data) {
                $("#scities").empty();
                $("#scities").append("<option></option>");
                $("#slocales").empty();
                $("#slocales").append("<option></option>");
                $.each(data, function (i, item) {
                    var html = '<option value="' + item.id + '" ';
                    if ($("#hcalendar_city_id").val() == item.id) {
                        html += 'selected';
                    }
                    html += '>' + item.description + '</option>';

                    $("#scities").append(html);
                });
            }, "json");
    });

    $("#scities").on("change", function () {
        $.get("/get_locale_by_city",
            {
                "city_id": $("#scities").val(),
            },
            function (data) {
                $("#slocales").empty();
                $("#slocales").append("<option></option>");
                $.each(data, function (i, item) {
                    var html = '<option value="' + item.id + '" ';
                    if ($("#hcalendar_locale_id").val() == item.id) {
                        html += 'selected';
                    }
                    html += '>' + item.locale_name + '</option>';

                    $("#slocales").append(html);
                });
            }, "json");
    });

    $("#saveLocale").on("click", function () {
        $('#localeModal').modal('hide');
        $.post("/city_locales",
            {
                "city_locale[locale_name]": $("#locale_name").val(),
                "city_locale[city_id]": $("#scities").val()
            },
            function (data) {
                $("#slocales").append('<option value="' + data.id + '" selected>' + data.locale_name + '</option>');
                $("#locale_name").val("");
            }, "json");
    });

});

function show_locale_modal() {
    if ($("#sprovinces option:selected").val() != "" && $("#scities option:selected").val() != "") {
        $('#localeModal').modal('show');
    }
    else {
        alert("You need to enter or select truck group province and city first!");
    }
}