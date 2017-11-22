(function () {
    var cal_range = parseInt($("#DataTables_Table_report").data("calendar-range"));

    $(document).ready(function () {
        $('.complete-report-calendar-start').datetimepicker({
            defaultDate: moment().subtract(cal_range, 'days').format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $('.complete-report-calendar-end').datetimepicker({
            defaultDate: moment().format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $(".complete-report-calendar-start").on("dp.change", function (e) {
            $('.complete-report-calendar-end').data("DateTimePicker").minDate(e.date);
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        }).on("input", function () {
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        });
        $(".complete-report-calendar-end").on("dp.change", function (e) {
            $('.complete-report-calendar-start').data("DateTimePicker").maxDate(e.date);
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        }).on("input", function () {
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        });

        var table = $(".data-table-complete-report").DataTable({
            "serverSide": true,
            "processing": true,
            "ajax": {
                "url": "fill_table_complete_book.json",
                "data": function (d) {
                    d.report_calendar_start = $('[name="report_calendar_start"]').val();
                    d.report_calendar_end = $('[name="report_calendar_end"]').val();
                    d.state_filter = $('[name="state"]').val();
                    d.group_filter = $('[name="group"]').val();
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
                {"data": "completed_date", "orderable": true},
                {"data": "move_date", "orderable": false},
                {"data": "group", "orderable": false},
                {"data": "stage", "orderable": false},
                {"data": "notes", "orderable": false}
            ],
            order: [[1, 'desc']]
        });
        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-complete-report").dataTable().api().ajax.reload();
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
            $(".data-table-complete-report").dataTable().api().ajax.reload();
        });

        // group filter reload
        $("#filter_param_group").on("change", function (e) {
            e.preventDefault();
            $(".data-table-complete-report").dataTable().api().ajax.reload();
        });

        // append groups
        $(".data-table-complete-report").on('xhr.dt', function (e, settings, json, xhr) {
            json.groups.forEach(function (group) {
                var optionExists = ($('#filter_param_group option[value=' + group + ']').length > 0);

                if (!optionExists) {
                    $("#filter_param_group").append('<option value="' + group + '">' + group + '</option>');
                }
            });
        });

    });

}).call(this);