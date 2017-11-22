// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require ./template/jquery/jquery.min.js
//= require jquery_ujs
//= require_tree .
//= stub ./template/plugins/timelineview/fullcalendar-scheduler.min.js
//= stub ./template/plugins/timelineview/scheduler.min.js
//= stub ./home.js
//= stub ./template/plugins/avalaible_calendar/available_fullcalendar.min.js
//= stub ./truck_availables.js
//= stub ./staff_availables.js
//= stub ./public_info.js

$(function () {
    // Smooth scroll to id
    $('a[href*=#SS]:not([href=#SS])').click(function () {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {

            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top - 160
                }, 700);
                return false;
            }
        }
    });

    // Show search box
    $("#search-icn").on("click", function () {
        $("#q_header").attr("class", "form-control");
        $("#q_header").focus();
    });

    // LocalStorage for static links
    // Move links
    $("[id=moveLink]").on("click", function () {
        var user = $('.user-name').data('user');
        var linkid = $(this).attr("data-linkid");
        var name = $(this).attr("data-name");
        var url = $(this).attr("data-url");
        var data_link = {'user': user, 'id': linkid, 'url': url, 'name': name};
        localStorage.setItem(user + '_moveRecordStaticLink_' + linkid, JSON.stringify(data_link));
    });

    // Mail links
    $("[id=mailLink]").on("click", function () {
        var user = $('.user-name').data('user');
        var linkid = $(this).attr("data-linkid");
        var name = $(this).attr("data-name");
        var url = $(this).attr("data-url");
        var data_link = {'user': user, 'id': linkid, 'url': url, 'name': name};
        localStorage.setItem(user + '_mailRecordStaticLink_' + linkid, JSON.stringify(data_link));
    });

    // Report links
    $("[id=reportLink]").on("click", function () {
        var user = $('.user-name').data('user');
        var linkid = $(this).attr("data-linkid");
        var name = $(this).attr("data-name");
        var url = $(this).attr("data-url");
        var data_link = {'user': user, 'id': linkid, 'url': url, 'name': name};
        localStorage.setItem(user + '_reportRecordStaticLink_' + linkid, JSON.stringify(data_link));
    });

    // colapse move header
    $("#moveHeader").removeClass("in");
    // colapse mail header
    $("#mailHeader").removeClass("in");
    // colapse report header
    $("#reportHeader").removeClass("in");

    $(window).resize(function (event) {
        resize_menu();
    });

    resize_menu();

    //Show menu icon on hover
    $(".hhiddenIcon").live("mouseenter",
        function () {
            $(this).find("i:last").removeClass("hhidden");
        }).live("mouseleave", function () {
        $(this).find("i:last").addClass("hhidden");
    });

    // Menu slider on hover
    $("#main-nav").on("mouseenter",
        function () {
            $("#lMenu").css({"overflow-y": "auto"});
        }).on("mouseleave", function () {
        $("#lMenu").css({"overflow": "hidden"});
    });

    function resize_menu() {
        var height = $(window).height() - 220;
        $('#lMenu').css({'max-height': height});
        $('.notification-list').css({'max-height': height});
    }
});
