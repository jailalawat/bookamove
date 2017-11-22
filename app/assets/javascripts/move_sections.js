(function () {
    var url_reports = {
        quote: 'fill_table_quote_report.json',
        book: 'fill_table_book_report.json',
        dispatch: 'fill_table_dispatch_report.json',
        complete: 'fill_table_complete_report.json'
    }
    $(document).ready(function () {

        var url_data_table = url_reports[$(".data-table-column-filter-move-section").data('report')];
        $('.report-calendar-start').datetimepicker({
            defaultDate: moment().subtract(3, 'days').format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $('.report-calendar-end').datetimepicker({defaultDate: moment().format("YYYY/MM/DD"), format: 'YYYY/MM/DD'});
        $(".report-calendar-start").on("dp.change", function (e) {
            $('.report-calendar-end').data("DateTimePicker").minDate(e.date);
        });
        $(".report-calendar-end").on("dp.change", function (e) {
            $('.report-calendar-start').data("DateTimePicker").maxDate(e.date);
        });
        var table = $(".data-table-column-filter-move-section").DataTable({
            "serverSide": true,
            "processing": true,
            "ajax": {
                "url": url_data_table,
                "data": function (d) {
                    d.report_calendar_start = $('[name="report_calendar_start"]').val();
                    d.report_calendar_end = $('[name="report_calendar_end"]').val();
                }
            },
            sPaginationType: "bootstrap",
            "iDisplayLength": $(".data-table-column-filter-move-section").data("pagination-records") || 10,
            oLanguage: {
                sLengthMenu: "_MENU_ records per page",
                sEmptyTable: "No records found."
            },
            "columns": [
                {"data": "move_id"},
                {"data": "author"},
                {"data": "stage"},
                {"data": "comments"},
                {"data": "date"}
            ]
        });
        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-column-filter-move-section").dataTable().api().ajax.reload()
        });
    });

}).call(this);