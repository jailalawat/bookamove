(function () {
    var url_reports = {statement: 'fill_table_statement.json'}
    $(document).ready(function () {
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

        var url_data_table = url_reports[$(".data-table-column-filter-statement").data('report')];

        var table = $(".data-table-column-filter-statement").DataTable({
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
            "iDisplayLength": $(".data-table-column-filter-statement").data("pagination-records") || 10,
            oLanguage: {
                sLengthMenu: "_MENU_ records per page",
                sEmptyTable: "No records found."
            },
            "columns": [
                {"data": "name"},
                {"data": "move_stages", "bSortable": false},
                {"data": "date"},
                {"data": "total_cost"}
            ],
            "footerCallback": function (row, data, start, end, display) {
                var api = this.api(), data;
                if (api.column(1).data().length > 0) {
                    // Remove the formatting to get integer data for summation
                    var intVal = function (i) {
                        return typeof i === 'string' ?
                        i.replace(/[\$,]/g, '') * 1 :
                            typeof i === 'number' ?
                                i : 0;
                    };
                    // Total over this page
                    pageTotal = api
                        .column(3, {page: 'current'})
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);
                    pageTotal = pageTotal.toFixed(2);
                    // Update footer
                    $(api.column(3).footer()).html(
                        '$' + pageTotal
                    );
                } else {
                    $(api.column(3).footer()).html(
                        '$0'
                    );
                }
            }
        });
        $('#form-date-post-report').on('submit', function (event) {
            event.preventDefault();
            $(".data-table-column-filter-statement").dataTable().api().ajax.reload()
        });
    });
}).call(this);
