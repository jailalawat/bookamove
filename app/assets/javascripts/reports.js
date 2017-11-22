(function () {
    var url_reports = {
        lead: 'fill_table_lead_report.json',
        post: 'fill_table_post_report.json',
        card_batch: 'fill_table_card_batch_report.json',
        source: 'fill_table_source_report.json'
    }
    $(document).ready(function () {
        var cal_range = ($("#DataTables_Table_report").data("calendar-range") != "") ? parseInt($("#DataTables_Table_report").data("calendar-range")) : 5;

        $('.report-calendar-start').datetimepicker({
            defaultDate: moment().subtract(cal_range, 'days').format("YYYY/MM/DD"),
            format: 'YYYY/MM/DD'
        });
        $('.report-calendar-end').datetimepicker({defaultDate: moment().format("YYYY/MM/DD"), format: 'YYYY/MM/DD'});
        $(".report-calendar-start").on("dp.change", function (e) {
            $('.report-calendar-end').data("DateTimePicker").minDate(e.date);
        });
        $(".report-calendar-end").on("dp.change", function (e) {
            $('.report-calendar-start').data("DateTimePicker").maxDate(e.date);
        });

        var url_data_table = url_reports[$(".data-table-column-filter").data('report')];

        var table = $(".data-table-column-filter").DataTable({
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
            "iDisplayLength": $(".data-table-column-filter").data("pagination-records") || 10,
            oLanguage: {
                sLengthMenu: "_MENU_ records per page",
                sEmptyTable: "No records found."
            },
            "columns": [
                {"data": "name"},
                {"data": "move_id"},
                {"data": "date"},
                {"data": "group"},
                {"data": "truck"},
                {"data": "author"},
                {"data": "source"},
                {"data": "total_cost"}
            ]
        });

        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-column-filter").dataTable().api().ajax.reload()
        });
    });

}).call(this);