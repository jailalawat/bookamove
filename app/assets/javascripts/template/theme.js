(function () {
    $(document).ready(function () {
        var body, click_event, content, nav, nav_toggler;
        nav_toggler = $("header .toggle-nav");
        nav = $("#main-nav");
        content = $("#content");
        body = $("body");
        click_event = (jQuery.support.touch ? "tap" : "click");
        $("#main-nav .dropdown-collapse").on(click_event, function (e) {
            var link, list;
            e.preventDefault();
            link = $(this);
            list = link.parent().find("> ul");
            if (list.is(":visible")) {
                if (body.hasClass("main-nav-closed") && link.parents("li").length === 1) {
                    false;
                } else {
                    link.removeClass("in");
                    link.find('i:last')//.addClass('icon-angle-down').removeClass('icon-remove');
                    list.slideUp(300, function () {
                        return $(this).removeClass("in");
                    });
                }
            } else {
                if (list.parents("ul.nav.nav-stacked").length === 1) {
                    $(document).trigger("nav-open");
                }
                link.addClass("in");
                link.find('i:last')//.removeClass('icon-angle-down').addClass('icon-remove');
                if (!$(arguments[0].target).is('#moveIcon') && !$(arguments[0].target).is('#mailIcon') && !$(arguments[0].target).is('#reportIcon') && !$(arguments[0].target).is('#calendarIcon')) {
                    list.slideDown(300, function () {
                        return $(this).addClass("in");
                    });
                }
            }
            return false;
        });
        if (jQuery.support.touch) {
            nav.on("swiperight", function (e) {
                return $(document).trigger("nav-open");
            });
            nav.on("swipeleft", function (e) {
                return $(document).trigger("nav-close");
            });
        }
        nav_toggler.on(click_event, function () {
            if (nav_open()) {
                $(document).trigger("nav-close");
            } else {
                $(document).trigger("nav-open");
            }
            return false;
        });
        if (jQuery().wysihtml5) {
            $('.wysihtml5').wysihtml5();
        }
        $(document).bind("nav-close", function (event, params) {
            var nav_open;
            body.removeClass("main-nav-opened").addClass("main-nav-closed");
            return nav_open = false;
        });

        /*$("body").on("click", ".has-popover", function() {
         var el;
         el = $(this);
         if (el.data("popover") === undefined) {
         el.popover({
         placement: el.data("placement") || "top",
         container: "body"
         });
         }
         return el.popover("show");
         });
         $("body").on("mouseleave", ".has-popover", function() {
         return $(this).popover("hide");
         });*/

        $(".box-collapse").live("click", function (e) {
            var box;
            box = $(this).parents(".box").first();
            box.toggleClass("box-collapsed");
            e.preventDefault();
            return false;
        });

        /*
         $(document).ajaxStart(function () {
         $("#loading").show();
         }).ajaxStop(function () {
         $("#loading").hide();
         }).ajaxError(function () {
         $("#loading").hide();
         });
         */

        //$('form').submit(function(){
        //$("#loading").show();
        //});

        $.ajaxTransport("+binary", function (options, originalOptions, jqXHR) {
            // check for conditions and support for blob / arraybuffer response type
            if (window.FormData && ((options.dataType && (options.dataType == 'binary')) || (options.data && ((window.ArrayBuffer && options.data instanceof ArrayBuffer) || (window.Blob && options.data instanceof Blob))))) {
                return {
                    // create new XMLHttpRequest
                    send: function (_, callback) {
                        // setup all variables
                        var xhr = new XMLHttpRequest(),
                            url = options.url,
                            type = options.type,
                        // blob or arraybuffer. Default is blob
                            dataType = options.responseType || "blob",
                            data = options.data || null;

                        xhr.addEventListener('load', function () {
                            var data = {};
                            data[options.dataType] = xhr.response;
                            // make callback and send data
                            callback(xhr.status, xhr.statusText, data, xhr.getAllResponseHeaders());
                        });

                        xhr.open(type, url, true);
                        xhr.responseType = dataType;
                        xhr.send(data);
                    },
                    abort: function () {
                        jqXHR.abort();
                    }
                };
            }
        });

        //remove static link menu
        $('body').on('click', '.submenu-remove-item', function (event) {
            var calendargroup = $(this).data('id');
            localStorage.removeItem(calendargroup);
            var can_reload = $(this).closest('li').hasClass('active');
            $(this).closest('li').remove();
            if (can_reload) {
                window.location.href = '/';
            }
        });

        var current_user = $('.user-name').data('user');
        $('.save-url-historical-calendar').on('click', function (e) {
            e.preventDefault();
            var calendar_type = $(this).data('calendartype');
            var id = $(this).data(calendar_type + '');
            var url = $(this).attr('href-original');
            var current_month = current_date_month();
            var full_date = current_full_date();
            var name = $(this).data(calendar_type + 'name');
            var data_link = {
                'user': current_user,
                'id': id,
                'url': url,
                'show_date': current_month,
                'name': name,
                'date': full_date,
                'type': 'month',
                'calendar_type': calendar_type
            };
            localStorage.setItem(current_user + '_' + calendar_type + '_' + id, JSON.stringify(data_link));
            $(this).addClass('submenu-activated');
            location.href = data_link.url + '&kind_calendar=' + data_link.type + '&date_calendar=' + data_link.date;
        });

        var locked = false;
        $.each(localStorage, function (index, el) {
            if (new RegExp(current_user + '_+[a-z]+calendar').test(index)) {
                data_link = JSON.parse(el);
                locked = data_link.locked === true ? '<i class="icon-lock locked-link blank"></i>' : '';
                data_link.locked = data_link.locked === true ? '&link_id=' + data_link.id + '&locked=true' : '';
                var icon_color = "";
                if(data_link.calendar_type == "truckcalendar"){
                    icon_color = "brown";
                } else if(data_link.calendar_type == "taskcalendar") {
                    icon_color = "green";
                }
                $('.' + data_link.calendar_type + '-links').after('<li class="static-link-group hhiddenIcon">' +
                    '<a href="' + data_link.url + '&kind_calendar=' + data_link.type +
                    '&date_calendar=' + data_link.date + data_link.locked + '" class="static-links" data-' + data_link.calendar_type + '="' +
                    data_link.id + '">' +
                    '<i class="icon-calendar blank '+ icon_color +'"></i><span>' + data_link.name +
                    ' - ' + data_link.show_date + '</span>' +
                    locked +
                    '</a>' +
                    '<i class="icon-remove submenu-remove-item hhidden blue-text" data-id="' + data_link.user + '_' + data_link.calendar_type + '_' + data_link.id + '"></i></li>');
                $("#calendarIcon").removeClass("icon-angle-down").addClass("icon-remove");

                // Remove all static calendar links
                $("#calendarIcon").on("click", function () {
                    var isRemovable = $(this).attr("class") == "angle-down icon-remove";

                    if (isRemovable) {
                        localStorage.removeItem(index);
                        window.location.href = '/';
                    }
                });
            }

            if (new RegExp(current_user + '_moverecord_').test(index)) {
                data_link = JSON.parse(el);
                $('.move-records-links').after('<li class="static-link-group hhiddenIcon">' +
                    '<a href="' + data_link.url + '" class="static-links">' +
                    '<i class="icon-truck blank ' + data_link.css_class + '"></i>' +
                    '<span>' + data_link.name + '</span>' +
                    '</a>' +
                    '<i class="icon-remove submenu-remove-item hhidden blue-text" data-id="' + data_link.user + '_moverecord_' + data_link.id + '"></i></li>');
            }

            // Static move links
            if (new RegExp(current_user + '_moveRecordStaticLink_').test(index)) {
                data_link = JSON.parse(el);
                $('.move-records-links').after('<li class="static-link-group hhiddenIcon">' +
                    '<a href="' + data_link.url + '" class="static-links" ">' +
                    '<i class="icon-file-text blank"></i>' +
                    '<span>' + data_link.name + '</span>' +
                    '</a>' +
                    '<i class="icon-remove submenu-remove-item hhidden blue-text" data-id="' + data_link.user + '_moveRecordStaticLink_' + data_link.id + '"></i></li>');
                $("#moveIcon").removeClass("icon-angle-down").addClass("icon-remove");

                // Remove all static move links
                $("#moveIcon").on("click", function () {
                    var isRemovable = $(this).attr("class") == "angle-down blue-text icon-remove";

                    if (isRemovable) {
                        localStorage.removeItem(index);
                        window.location.href = '/';
                    }
                });
            }

            // Static mail links
            if (new RegExp(current_user + '_mailRecordStaticLink_').test(index)) {
                data_link = JSON.parse(el);
                $('.mail-records-links').after('<li class="static-link-group hhiddenIcon">' +
                    '<a href="' + data_link.url + '" class="static-links">' +
                    '<i class="icon-envelope blank"></i>' +
                    '<span>' + data_link.name + '</span>' +
                    '</a>' +
                    '<i class="icon-remove submenu-remove-item hhidden blue-text" data-id="' + data_link.user + '_mailRecordStaticLink_' + data_link.id + '"></i></li>');

                $("#mailIcon").removeClass("icon-angle-down").addClass("icon-remove");

                // Remove all static mail links
                $("#mailIcon").on("click", function () {
                    var isRemovable = $(this).attr("class") == "angle-down icon-remove";

                    if (isRemovable) {
                        localStorage.removeItem(index);
                        window.location.href = '/';
                    }
                });
            }

            // Static report links
            if (new RegExp(current_user + '_reportRecordStaticLink_').test(index)) {
                data_link = JSON.parse(el);
                $('.report-records-links').after('<li class="static-link-group hhiddenIcon">' +
                    '<a href="' + data_link.url + '" class="static-links">' +
                    '<i class="icon-file-text blank"></i>' +
                    '<span>' + data_link.name + '</span>' +
                    '</a>' +
                    '<i class="icon-remove submenu-remove-item hhidden blue-text" data-id="' + data_link.user + '_reportRecordStaticLink_' + data_link.id + '"></i></li>');
                $("#reportIcon").removeClass("icon-angle-down").addClass("icon-remove");

                // Remove all static report links
                $("#reportIcon").on("click", function () {
                    var isRemovable = $(this).attr("class") == "angle-down icon-remove";

                    if (isRemovable) {
                        localStorage.removeItem(index);
                        window.location.href = '/';
                    }
                });
            }

            // Remove all
            $("#closeAllButton").on("click", function () {
                localStorage.removeItem(index);
                window.location.href = '/';
            });

        });

        $('body').on('click', '.lock-calendar', function (event) {
            if ($(this).data('locked') === true) {
                $('.static-link-group i.icon-remove[data-id="' + current_user + '_' + $(this).data('calendartype') + '_' + current_link_id() + '"]').trigger('click');
                $(this).find('span').text('Lock');
                $(this).data('locked', false);
                location.href = '/'
                return false;
            }
            var calendar_selectors = {
                truckcalendar: $('#calendar-move-record'), taskcalendar: $('#calendar-staff-task'),
                personalcalendar: $('#calendar-personal'), mytruckcalendar: $('#calendar-truck')
            };
            var group_id = $(this).data('id');
            var calendar_type = $(this).data('calendartype');
            var link_id = Math.random();
            var url = $('.nav-calendar [data-' + calendar_type + '="' + group_id + '"]').attr('href-original');
            var current_month = current_date(calendar_selectors[calendar_type])
            var full_date = current_full_date(calendar_selectors[calendar_type])
            var name = $('.nav-calendar [data-' + calendar_type + '="' + group_id + '"]').data(calendar_type + 'name');
            var data_link = {
                'user': current_user,
                'id': link_id,
                'url': url,
                'show_date': current_month,
                'name': name,
                'date': full_date,
                'type': current_view_calendar(calendar_selectors[calendar_type]),
                'locked': true,
                'calendar_type': calendar_type
            };
            localStorage.setItem(current_user + '_' + calendar_type + '_' + link_id, JSON.stringify(data_link));
            $('.static-link-group i.icon-remove[data-id="' + current_user + '_' + calendar_type + '_' + group_id + '"]').trigger('click');
            location.href = data_link.url + '&kind_calendar=' + data_link.type + '&date_calendar=' + data_link.date + '&link_id=' + data_link.id + '&locked=true';
        });

        var url = window.location.pathname + window.location.search;
        $('.nav a[href="' + url + '"]').closest('li').addClass('active');
        $('.nav .active').parents('li').find('a, ul').addClass('in');
        $('.nav .active').parents('li').find('a:first').find('i:last').removeClass('icon-angle-down').addClass('icon-remove');

        var message_param = new RegExp('message=([^&amp;#]*)').exec(window.location.href);
        if (message_param !== null) {
            $('div[data-message*="' + message_param[1] + '"]:first .panel-heading').trigger('click');
            $("body, html").animate({
                scrollTop: $('[data-message*="' + message_param[1] + '"]').offset().top - 250
            }, 600);
            $('div[data-message*="' + message_param[1] + '"]:last').parents('.wrap-full-message').effect("highlight", {}, 1000);
        }

        //$('.notification-latest-urgent-message').delay(30000).fadeOut();

        return $(document).bind("nav-open", function (event, params) {
            var nav_open;
            body.addClass("main-nav-opened").removeClass("main-nav-closed");
            return nav_open = true;
        });
    });

    $('body').on('click', '.change-day-calendar', function (event) {
        calendar = $('#' + $(this).data('calendar'));
        var calendar_date = calendar.fullCalendar('getDate').format('YYYY-MM');
        calendar_date = moment(calendar_date + '-' + $(this).data('day'), "YYYY-MM-DD").toDate();
        calendar.fullCalendar('gotoDate', calendar_date);
    });

    $('body').on('click', '.change-month-calendar', function (event) {
        calendar = $('#' + $(this).data('calendar'));
        calendar_date = moment($(this).data('date'), "YYYY-MM-DD").toDate();
        calendar.fullCalendar('gotoDate', calendar_date);
        calendar.fullCalendar('refetchEvents');
    });

    this.nav_open = function () {
        return $("body").hasClass("main-nav-opened") || $("#main-nav").width() > 50;
    };

}).call(this);

function error_permissions() {
    $(".msg-error-permissions").removeClass("hidden");
    $(".msg-error-permissions").fadeTo(2000, 500).slideUp(500, function () {
        $(".msg-error-permissions").addClass("hidden");
    })
};

function date_calendar(calendar) {
    var date_calendar = new RegExp('date_calendar=([^&amp;#]*)').exec(window.location.href);
    date_calendar = date_calendar === null ? [] : date_calendar;
    calendar.fullCalendar('gotoDate', date_calendar[1]);
}

function current_date(calendar) {
    if (calendar.length > 0) {
        return calendar.fullCalendar('getView').name === 'month' ? calendar.fullCalendar('getDate').format('MMM') : calendar.fullCalendar('getDate').format('MMM DD');
    }
    return moment().format('MMM');
}

function current_date_month() {
    return moment().format('MMM');
}

function current_full_date(calendar) {
    calendar = typeof calendar === 'undefined' ? '' : calendar;
    return calendar.length > 0 ? calendar.fullCalendar('getDate').format('YYYY-MM-DD') : moment().format('YYYY-MM-DD');
}

function current_view_calendar(calendar) {
    if (calendar.length > 0) {
        return calendar.fullCalendar('getView').name;
    }
    return 'month';
}
function current_link_id() {
    var link_id = new RegExp('link_id=([^&amp;#]*)').exec(window.location.href);
    link_id = link_id === null ? [] : link_id;
    return link_id[1];
}

function display_days_numbers_line(calendar) {
    var year = calendar.fullCalendar('getDate').format('YYYY');
    var month = calendar.fullCalendar('getDate').format('MM');
    var current_day = calendar.fullCalendar('getDate').format('DD');
    var names = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
    var date = new Date(year, month - 1, 1);
    var html = '<div class="btn btn-default pull-left change-month-calendar" data-calendar="' + calendar.attr('id') + '" data-date="' + moment(calendar.fullCalendar('getDate').format('YYYY/MM/DD')).subtract(1, 'month').format('YYYY/MM/DD') + '"><</div>';
    while (date.getMonth() == month - 1) {
        html += '<div class="btn  pull-left ' + (current_day == date.getDate() ? 'btn-primary' : 'btn-default') + ' change-day-calendar" data-calendar="' + calendar.attr('id') + '" data-day="' + date.getDate() + '">' +
            names[date.getDay()] + "</br>" + date.getDate() + '</div>';
        date.setDate(date.getDate() + 1);
    }
    html += '<div class="btn btn-default pull-left change-month-calendar" data-calendar="' + calendar.attr('id') + '" data-date="' + moment(calendar.fullCalendar('getDate').format('YYYY/MM/DD')).add(1, 'month').format('YYYY/MM/DD') + '">></div>';
    return $('.calendar-days-line').html(html);
}


