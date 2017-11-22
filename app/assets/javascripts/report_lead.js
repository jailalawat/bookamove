(function () {
    $(document).ready(function () {
        var cal_range = parseInt($("#DataTables_Table_report").data("calendar-range"));

        $('.lead-report-calendar-start').datetimepicker({
            defaultDate: moment().subtract(cal_range, 'days').format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $('.lead-report-calendar-end').datetimepicker({
            defaultDate: moment().format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $(".lead-report-calendar-start").on("dp.change", function (e) {
            $('.lead-report-calendar-end').data("DateTimePicker").minDate(e.date);
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        }).on("input", function () {
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        });
        $(".lead-report-calendar-end").on("dp.change", function (e) {
            $('.lead-report-calendar-start').data("DateTimePicker").maxDate(e.date);
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        }).on("input", function () {
            $("#DataTables_Table_report").dataTable().api().ajax.reload();
        });

        var table = $(".data-table-lead-report").DataTable({
            "serverSide": true,
            "processing": true,
            "ajax": {
                "url": "fill_table_move_lead.json",
                "data": function (d) {
                    d.report_calendar_start = $('[name="report_calendar_start"]').val();
                    d.report_calendar_end = $('[name="report_calendar_end"]').val();
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
                {"data": "created", "orderable": true},
                {"data": "stage", "orderable": false},
                {"data": "notes", "orderable": false}
            ],
            order: [[1, 'desc']]
        });
        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-lead-report").dataTable().api().ajax.reload();
        });

        // hide search box
        $("#DataTables_Table_report_filter").addClass("hidden"); // hidden search input

        $("#DataTables_Table_report").show();

        $("#searchInput").on("input", function (e) {
            e.preventDefault();
            $('#DataTables_Table_report').DataTable().search($(this).val()).draw();
        });
    });

}).call(this);