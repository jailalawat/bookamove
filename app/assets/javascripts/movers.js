$(document).ready(function () {
    $('.list-move-calendar-start').datetimepicker({format: 'YYYY/MM/DD'});
    $('.list-move-calendar-end').datetimepicker({format: 'YYYY/MM/DD'});
    $(".list-move-calendar-start").on("dp.change", function (e) {
        $('.list-move-calendar-end').data("DateTimePicker").minDate(e.date);
    });
    $(".list-move-calendar-end").on("dp.change", function (e) {
        $('.list-move-calendar-start').data("DateTimePicker").maxDate(e.date);
    });

    var table = $(".data-table-column-filter-mover").DataTable({
        "serverSide": true,
        "processing": true,
        "ajax": {
            "url": 'fill_table_list_move_record_mover.json',
            "data": function (d) {
                d.list_move_calendar_start = $('[name="list_move_calendar_start"]').val();
                d.list_move_calendar_end = $('[name="list_move_calendar_end"]').val();
            }
        },
        sPaginationType: "bootstrap",
        "iDisplayLength": $(".data-table-column-filter-mover").data("pagination-records") || 10,
        oLanguage: {
            sLengthMenu: "_MENU_ records per page",
            sEmptyTable: "No records found."
        },
        "columns": [
            {"data": "name"},
            {"data": "date"},
            {"data": "start_time"},
            {"data": "movers"}
        ]
    });

    $('#form-date-list-moves').on('submit', function (event) {
        event.preventDefault();
        $(".data-table-column-filter-mover").dataTable().api().ajax.reload()
    });
});