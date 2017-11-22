$(document).ready(function () {
    if (/customer_move_records\/([^d]*)/.test(self.location.href)) {
        var css_class;
        var stage_name = $("#stage_name").text();

        if (stage_name == "Quote") {
            css_class = "contact_stage_quote"
        }
        else if (stage_name == "Dispatch") {
            css_class = "contact_stage_dispatch"
        }
        else if (stage_name == "Active") {
            css_class = "contact_stage_active"
        }
        else if (stage_name == "Post") {
            css_class = "contact_stage_post"
        }
        else if (stage_name == "Complete") {
            css_class = "contact_stage_complete"
        }
        else if (stage_name == "Cancel") {
            css_class = "contact_stage_cancel"
        }
        // booked, recieved, confirmed, dispatched: green
        else if (stage_name == "Book" || stage_name == "Receive" || stage_name == "Receive 2" || stage_name == "Confirm" || stage_name == "Confirm 2" || stage_name == "Confirm 7" || stage_name == "Dispatch") {
            css_class = "contact_stage_green"
        }
        else {
            css_class = "contact_stage_special"
        }

        var current_user = $('.user-name').data('user');
        var move_record = new RegExp('customer_move_records/([^d]*)').exec(window.location.href);
        var name = $('#pTitle_text').text(); //$('#move_record_move_contract_name').val();
        var current_css_class = JSON.parse(localStorage.getItem(current_user + '_moverecord_' + move_record[1]));

        var data_link = {
            'user': current_user,
            'id': move_record[1],
            'url': window.location.pathname,
            'name': name,
            'css_class': css_class
        };
        localStorage.setItem(current_user + '_moverecord_' + move_record[1], JSON.stringify(data_link));
        $("a[href='" + window.location.pathname + "']").find("i").removeClass(current_css_class.css_class).addClass(css_class);
        $("#pTitle .icon-truck").removeClass("blue-text").removeClass(current_css_class.css_class).addClass(css_class);

    }


    $('body').on('click', function () {
        var menu = $("ul[role='menu']");
        if(menu.attr("style") == "display: block;"){
            menu.hide();
        }
    });
});

function customer_active_move_record() {
    var current_user = $('.user-name').data('user');

    var move_record = new RegExp('customer_move_records/([^d]*)').exec(window.location.href);
    if (move_record !== null) {
        if (localStorage[current_user + '_moverecord_' + move_record[1]]) {
            if (!JSON.parse(localStorage.getItem(current_user + '_moverecord_' + move_record[1])).hasOwnProperty('css_class')) {
                var name = $('#pTitle_text').text(); //$('#move_record_move_contract_name').val();
                var data_link = {
                    'user': current_user,
                    'id': move_record[1],
                    'url': window.location.pathname,
                    'name': name
                };
                localStorage.setItem(current_user + '_moverecord_' + move_record[1], JSON.stringify(data_link));
            }
        }
        else {
            var name = $('#pTitle_text').text(); //$('#move_record_move_contract_name').val();
            var data_link = {
                'user': current_user,
                'id': move_record[1],
                'url': window.location.pathname,
                'name': name
            };
            localStorage.setItem(current_user + '_moverecord_' + move_record[1], JSON.stringify(data_link));
        }
    }
}