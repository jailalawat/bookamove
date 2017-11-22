(function () {
    $(document).ready(function () {
        var table = $(".data-table-book-report").DataTable({
            "serverSide": true,
            "processing": true,
            "ajax": {
                "url": "fill_table_move_book.json",
                "data": function (d) {
                    d.group_filter = $('[name="group"]').val();
                    d.state_filter = $('[name="state"]').val();
                    d.truck_filter = $('[name="truck"]').val();
                    d.booker_filter = $('[name="booker"]').val();
                    d.driver_filter = $('[name="driver"]').val();
                }
            },
            bPaginate: false,
            bInfo: false,
            bFilter: true,
            oLanguage: {
                sEmptyTable: "No records found."
            },
            "columns": [
                {"data": "name", "orderable": false},
                {"data": "move_date", "orderable": true},
                {"data": "stage", "orderable": false},
                {"data": "booker", "orderable": false},
                {"data": "truck_name", "orderable": false},
                {"data": "driver", "orderable": false},
                {"data": "status", "orderable": false},
                {"data": "notes", "orderable": false}
            ],
            order: [[1, 'desc']]
        });

        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-book-report").dataTable().api().ajax.reload();
        });

        // hide search box
        $("#DataTables_Table_report_filter").addClass("hidden"); // hidden search input

        $("#DataTables_Table_report").show();

        // search reload
        $("#searchInput").on("input", function (e) {
            e.preventDefault();
            $('#DataTables_Table_report').DataTable().search($(this).val()).draw();
        });

        // state filter reload
        $("#filter_param_state").on("change", function (e) {
            e.preventDefault();
            $(".data-table-book-report").dataTable().api().ajax.reload();
        });

        // group filter reload
        $("#filter_param_group").on("change", function (e) {
            e.preventDefault();
            $(".data-table-book-report").dataTable().api().ajax.reload();
        });

        // truck filter reload
        $("#filter_param_truck").on("change", function (e) {
            e.preventDefault();
            $(".data-table-book-report").dataTable().api().ajax.reload();
        });

        // truck filter reload
        $("#filter_param_booker").on("change", function (e) {
            e.preventDefault();
            $(".data-table-book-report").dataTable().api().ajax.reload();
        });

        // driver filter reload
        $("#filter_param_driver").on("change", function (e) {
            e.preventDefault();
            $(".data-table-book-report").dataTable().api().ajax.reload();
        });

        // append trucks, groups, bookers
        $(".data-table-book-report").on('xhr.dt', function (e, settings, json, xhr) {
            json.trucks.forEach(function (truck) {
                var optionExists = ($('#filter_param_truck option[value="' + truck + '"]').length > 0);

                if (!optionExists && truck != null) {
                    $("#filter_param_truck").append('<option value="' + truck + '">' + truck + '</option>');
                }
            });

            json.groups.forEach(function (group) {
                var optionExists = ($('#filter_param_group option[value="' + group + '"]').length > 0);

                if (!optionExists && group != null) {
                    $("#filter_param_group").append('<option value="' + group + '">' + group + '</option>');
                }
            });

            json.bookers.forEach(function (booker) {
                var optionExists = ($('#filter_param_booker option[value="' + booker + '"]').length > 0);

                if (!optionExists && booker != null) {
                    $("#filter_param_booker").append('<option value="' + booker + '">' + booker + '</option>');
                }
            });

            json.drivers.forEach(function (driver) {
                var optionExists = ($('#filter_param_driver option[value="' + driver + '"]').length > 0);

                if (!optionExists && driver != null) {
                    $("#filter_param_driver").append('<option value="' + driver + '">' + driver + '</option>');
                }
            });

        });

    });

}).call(this);