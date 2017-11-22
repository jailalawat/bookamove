var type = 'year';
var month = '';
$(document).ready(function () {

    $('.data-table-column-filter-stats').dataTable({
        "paging": false,
        "ordering": false,
        "searching": false,
        "info": false,
        "processing": true,
        "ajax": {
            "url": 'fill_table_stats',
            "data": function (d) {
                d.year = $('.year-stats').val();
                d.type = type;
                d.month = month;
                d.stats_user = $('.user_stats :selected').val();
            }
        },
        oLanguage: {
            sLengthMenu: "_MENU_ records per page",
            sEmptyTable: "No records found."
        },
        "columns": [
            {"data": "month", "className": "pointer"},
            {"data": "lead"},
            {"data": "quote"},
            {"data": "book"},
            {"data": "dispatch"},
            {"data": "confirm"},
            {"data": "invoice"},
            {"data": "aftercare"},
            {"data": "canceled"},
            {"data": "follow_up"},
            {"data": "receive"},
            {"data": "unable"},
            {"data": "submit"},
            {"data": "post"},
            {"data": "completed"},
            {"data": "percentage"},
            {"data": "total_commission"}
        ],
        "footerCallback": function (row, data, start, end, display) {
            var api = this.api(), data;
            // Remove the formatting to get integer data for summation
            var intVal = function (i) {
                return typeof i === 'string' ?
                i.replace(/[\$,%]/g, '') * 1 :
                    typeof i === 'number' ?
                        i : 0;
            };
            column1 = api
                .column(1, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(1).footer()).html(
                column1
            );
            column2 = api
                .column(2, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(2).footer()).html(
                column2
            );
            column3 = api
                .column(3, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(3).footer()).html(
                column3
            );
            column4 = api
                .column(4, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(4).footer()).html(
                column4
            );
            column5 = api
                .column(5, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(5).footer()).html(
                column5
            );
            column6 = api
                .column(6, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(6).footer()).html(
                column6
            );
            column7 = api
                .column(7, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(7).footer()).html(
                column7
            );
            column8 = api
                .column(8, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(8).footer()).html(
                column8
            );
            column9 = api
                .column(9, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(9).footer()).html(
                column9
            );
            column10 = api
                .column(10, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(10).footer()).html(
                column10
            );
            column11 = api
                .column(11, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(11).footer()).html(
                column11
            );
            column12 = api
                .column(12, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(12).footer()).html(
                column12
            );
            column13 = api
                .column(13, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(13).footer()).html(
                column13
            );
            column14 = api
                .column(14, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(14).footer()).html(
                column14
            );
            column15 = api
                .column(15, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            $(api.column(15).footer()).html(
                column15
            );
            ;
            percentage = 100 - parseFloat(column3 / (column2 - column8));
            percentage = parseFloat(percentage) && parseFloat(percentage) != "Infinity" && parseFloat(percentage) != "-Infinity" ? percentage : 100;
            percentage = percentage.toFixed(2);
            $(api.column(15).footer()).html(
                percentage + '%'
            );
            column16 = api
                .column(16, {page: 'current'})
                .data()
                .reduce(function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0);
            column16 = column16.toFixed(2);
            $(api.column(16).footer()).html(
                '$' + column16
            );
        },
    });
    $('#form-date-stats').on('submit', function (event) {
        event.preventDefault();
        $("th:first").replaceWith("<th role='columnheader' tabindex='0'  rowspan='1' colspan='1' class='title-table'>Month</th>");
        type = 'year';
        month = null;
        $('.title-page').replaceWith('<span class="title-page">Stats - ' + $('.year-stats').val() + '</span>');
        $(".data-table-column-filter-stats").dataTable().api().ajax.reload()
    });
});

$('body').on('click', '.button-link', function () {
    $("th:first").replaceWith("<th role='columnheader' tabindex='0'  rowspan='1' colspan='1' class='title-table'>Day</th>");
    type = 'month';
    month = $(this).attr("data-month");
    $('.title-page').replaceWith('<span class="title-page">Stats - ' + $('.year-stats').val() + ' - ' + month + '</span>');
    $(".data-table-column-filter-stats").dataTable().api().ajax.reload()
});

$('body').on('change', '.user_stats', function () {
    $(".data-table-column-filter-stats").dataTable().api().ajax.reload()
});

