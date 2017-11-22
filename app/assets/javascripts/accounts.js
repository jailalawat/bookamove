$(document).ready(function () {
    $(".users_type_account").change(function () {
        var val = $(this).val();
        if (val == 'inactive') {
            $(".table-users-inactive").removeClass("hidden");
            $(".table-users-active").addClass("hidden");
        } else {
            $(".table-users-active").removeClass("hidden");
            $(".table-users-inactive").addClass("hidden");
        }
    });
});

(function () {
    var url_reports = {list_accounts: 'fill_table_accounts_list.json'}
    $(document).ready(function () {
        var cal_range = parseInt($("#DataTables_Table_report").data("calendar-range"));

        var url_data_table = url_reports[$(".data-table-column-filter-account").data('report')];
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
        var table = $(".data-table-column-filter-account").DataTable({
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
            "iDisplayLength": $(".data-table-column-filter-account").data("pagination-records") || 10,
            oLanguage: {
                sLengthMenu: "_MENU_ records per page",
                sEmptyTable: "No records found."
            },
            "columns": [
                {"data": "name"},
                {"data": "email"},
                {"data": "site"},
                {"data": "office_phone"},
                {"data": "subdomain"}
            ]
        });
        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-column-filter-account").dataTable().api().ajax.reload()
        });
    });

}).call(this);