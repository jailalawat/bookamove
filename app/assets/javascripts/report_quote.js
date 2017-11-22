(function () {
    $(document).ready(function () {
        var cal_range = parseInt($("#DataTables_Table_report").data("calendar-range"));

        $('.quote-report-calendar-start').datetimepicker({
            defaultDate: moment().subtract(cal_range, 'days').format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $('.quote-report-calendar-end').datetimepicker({
            defaultDate: moment().format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $(".quote-report-calendar-start").on("dp.change", function (e) {
            $('.quote-report-calendar-end').data("DateTimePicker").minDate(e.date);
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        }).on("input", function () {
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        });
        $(".quote-report-calendar-end").on("dp.change", function (e) {
            $('.quote-report-calendar-start').data("DateTimePicker").maxDate(e.date);
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        }).on("input", function () {
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        });

        var table = $(".data-table-quote-report").DataTable({
            "serverSide": true,
            "processing": true,
            "ajax": {
                "url": "fill_table_move_quote.json",
                "data": function (d) {
                    d.report_calendar_start = $('[name="report_calendar_start"]').val();
                    d.report_calendar_end = $('[name="report_calendar_end"]').val();
                    d.group_filter = $('[name="group"]').val();
                    d.state_filter = $('[name="state"]').val();
                    d.estimator_filter = $('[name="estimator"]').val();
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
                {"data": "estimated", "orderable": true},
                {"data": "stage", "orderable": false},
                {"data": "estimator", "orderable": false},
                {"data": "notes", "orderable": false}
            ],
            order: [[1, 'desc']]
        });
        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-quote-report").dataTable().api().ajax.reload();
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
            $(".data-table-quote-report").dataTable().api().ajax.reload();
        });

        // estimator filter reload
        $("#filter_param_estimator").on("change", function (e) {
            e.preventDefault();
            $(".data-table-quote-report").dataTable().api().ajax.reload();
        });

        // append estimators
        $(".data-table-quote-report").on('xhr.dt', function (e, settings, json, xhr) {
            json.estimators.forEach(function (estimator) {
                var optionExists = ($('#filter_param_estimator option[value=' + estimator + ']').length > 0);

                if (!optionExists) {
                    $("#filter_param_estimator").append('<option value="' + estimator + '">' + estimator + '</option>');
                }
            });
        });

        // group filter reload
        $("#filter_param_group").on("change", function (e) {
            e.preventDefault();
            $(".data-table-quote-report").dataTable().api().ajax.reload();
        });

        // append groups
        $(".data-table-quote-report").on('xhr.dt', function (e, settings, json, xhr) {
            json.groups.forEach(function (group) {
                var optionExists = ($('#filter_param_group option[value=' + group + ']').length > 0);

                if (!optionExists) {
                    $("#filter_param_group").append('<option value="' + group + '">' + group + '</option>');
                }
            });
        });

    });

}).call(this);