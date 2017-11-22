'use strict';
var call_start_btn_clicked, call_save_btn_clicked;
var primary_stage_update;
var is_cancel, is_unable, is_post;

$(document).ready(function () {
    var enabled_icon = 'fa fa-check-circle icon-green disable';
    var disabled_icon = 'fa fa-check-circle icon-gray disable';
    var current_user = $('.user-name').data('user');

    addDateTimePicker();

    $(".cost_hourly_start").on("dp.change", function (e) {
        $('.cost_hourly_stop').data("DateTimePicker").minDate(e.date);
    });
    $(".cost_hourly_stop").on("dp.change", function (e) {
        $('.cost_hourly_start').data("DateTimePicker").maxDate(e.date);
    });

    $('.calcMoveHours').on("blur change keyup click keydown", function () {
        wrapCalculates();
        wrapCalculationsCost();
    });

    $('.calcPacking').on("blur change keyup click keydown", function () {
        var result = 0;
        $('.calcPacking').each(function () {
            result = calculatePacking(result, $(this).val());
        });
        $('.packing_total_packing').val(result);
        wrapCalculationsCost();
    });

    var row_selectors = {
        number_of_trucks: '.truck-row:last',
        number_of_origin: '.origin-row:last',
        number_of_destination: '.destination-row:last',
        number_of_date: '.date-row:last'
    };

    $('#new_move_record .move-add-line, .edit_move_record .move-add-line').click(function () {
        var key = $(this).attr('field');
        if (key === 'number_of_trucks') {
            $(row_selectors[key]).after('<div class="row truck-row colpd">' + $(row_selectors[key].replace(':last', ':first')).html().replace(/(\[\d*\])/g, '[new_' + ($('.truck-row').length) + ']') + '</div>');
        }
        else if (key === 'number_of_origin') {
            $(row_selectors[key]).after('<div class="row origin-row colpd">' + $(row_selectors[key].replace(':last', ':first')).html().replace(/(\[\d*\])/g, '[new_' + ($('.origin-row').length) + ']') + '</div>');
        }
        else if (key === 'number_of_destination') {
            $(row_selectors[key]).after('<div class="row destination-row colpd">' + $(row_selectors[key].replace(':last', ':first')).html().replace(/(\[\d*\])/g, '[new_' + ($('.destination-row').length) + ']') + '</div>');
        }
        else if (key === 'number_of_date') {
            $(row_selectors[key]).after('<div class="row date-row colpd">' + $(row_selectors[key].replace(':last', ':first')).html().replace(/(\[\d*\])/g, '[new_' + ($('.date-row').length) + ']') + '</div>');
            addDateTimePicker();
        }
        $(row_selectors[key]).after().find('input').val('');
        //$(row_selectors[key]).after().find('select').empty();
    });

    var selected_contact_stage = [];

    if (window.location.hash.length > 0) {
        $('html, body').animate({scrollTop: $('[href="' + window.location.hash + '"]').offset().top}, 1000);
        $('[href="' + window.location.hash + '"]').trigger('click');
    }

    // sub-stage update
    $('.select-contact-stage').on("click", function (event, calendar_disabled) {

        // disable changes if jobs finished
        if ($("#is_job_finished").val() == "true") {
            $.jGrowl("This jobs is finished. No further changes to contact stages can be done!", {
                header: 'Important',
                theme: 'error-jGrowl',
                life: 10000
            });
            jGrowl_to_stages();
            return;
        }

        var current_stage_id = $("#current_stage").val();
        var contact_stage_id = $(this).attr('contact_stage_id');
        var current_stage_num = parseInt($("#current_stage_num").val());
        var stage_num = parseInt($(this).attr('stage_num'));
        var _this = $(this);

        $(".select-contact-stage").removeClass("underline");
        $(this).removeClass("no_underline");
        $(".select-primary-stage").addClass("no_underline");

        // hide and show emails
        var email_list = $(this).parents('table').find('tr:eq(1) div');
        if (!email_list.hasClass("stage_emails")){
            email_list.hide();
        }
        $(".sub_stage_emails").hide();
        $(".cStage2").text($(".select-contact-stage[contact_stage_id='"+ contact_stage_id +"']").text());
        $(".emails_for_stage_"+ contact_stage_id).show();

        if (!$(this).hasClass('active-stage')) {

            $(".sliding_emails").css({opacity: 0}).hide();

            if ($(".sub_stage_emails.emails_for_stage_"+ contact_stage_id).length > 0) {
                $(".sliding_emails").show().animate({
                    opacity: '1'
                }, 600).fadeIn();

                $(".emails_for_stage_"+ contact_stage_id).hide().animate({width:'toggle'},350);
            }
        }

        var book_activated = $(".select-primary-stage[stage_num='1']").hasClass("green");
        var complete_activated = $(".select-primary-stage[stage_num='2']").hasClass("green");
        is_cancel = $(this).text() == "Cancel";
        is_unable = $(this).text() == "Unable";
        is_post = $(this).text() == "Post";


        if (stage_num >= current_stage_num && !is_cancel) {

            // validate if primary-stage activated
            if (stage_num == 1 && !book_activated) {

                if ($(this).hasClass('active-stage')) {
                    $.jGrowl("You need to advance Book stage first, before you can advance it's sub-stages!", {
                        header: 'Important',
                        theme: 'error-jGrowl',
                        life: 10000
                    });
                    jGrowl_to_stages();
                }
            }
            else if (stage_num == 2 && !complete_activated) {

                if ($(this).hasClass('active-stage')) {
                    $.jGrowl("You need to advance Complete stage first, before you can advance it's sub-stages!", {
                        header: 'Important',
                        theme: 'error-jGrowl',
                        life: 10000
                    });
                    jGrowl_to_stages();
                }
            }
            // enable/disable sub-stage
            else {
                // disable stage
                if ($(this).hasClass('active-stage') && $(this).hasClass('enable')) {
                    if (!calendar_disabled) {

                        // confirmation for sub-stage disable
                        bootbox.confirm("<h4 class='textOrange'>Are you sure you want to reverse sub-stage?</h4>", function (result) {
                            if (result) {
                                update_contact_stage(contact_stage_id, false, true);
                            }
                        });

                        // hide emails
                        $(".sub_stage_emails").hide();
                        $(".sliding_emails").hide();
                        $(this).addClass("no_underline");

                    }
                }
                // enable stage
                else if ($(this).hasClass('active-stage') && $(this).hasClass('disable')) {

                    if (!calendar_disabled) {
                        // cancel confirm box for cancel stage
                        update_contact_stage(contact_stage_id);

                        // hide emails
                        $(".sub_stage_emails").hide();
                        $(".sliding_emails").hide();
                        $(this).addClass("no_underline");


                        // highlight auto-send emails
                        $(".select-contact-email.autosend[contact_stage_id='" + contact_stage_id + "']").find("i").addClass("icon-green");
                        //$(".select-contact-email-preview.autosend[contact_stage_id='" + contact_stage_id + "']").addClass("green bold caps");
                    }

                }
            }

        }
        // cancel
        else if (is_cancel) {
            if ($(this).hasClass('active-stage') && $(this).hasClass('disable')) {
                bootbox.confirm("<h4 class='textOrange'>Are you sure you want to cancel?</h4>", function (result) {
                    if (result) {
                        update_contact_stage(contact_stage_id);
                        $(".truck_driver_name").attr("value", "");
                        $("#cHow_name").text("TBD");

                        // highlight auto-send emails
                        $(".select-contact-email.autosend[contact_stage_id='"+ contact_stage_id +"']").find("i").addClass("icon-green");
                        //$(".select-contact-email-preview.autosend[contact_stage_id='"+ contact_stage_id +"']").addClass("green bold caps");
                    }
                    else {
                        //$("label[contact_stage_id=11].select-contact-stage > i").removeClass("icon-green").addClass("icon-gray");
                    }
                });
                $('.bootbox').find('button[data-bb-handler="cancel"]').text("No");
                $('.bootbox').find('button[data-bb-handler="confirm"]').text("Yes");
            }

        }
        else {
            $.jGrowl("Cannot return to a previous stage. Previous stages are view only!", {
                header: 'Important',
                theme: 'error-jGrowl',
                life: 10000
            });
            jGrowl_to_stages();
        }

        //toggle states
        $('.active-stage').removeClass('active-stage');
        $(this).addClass('active-stage');
        if (!$(this).hasClass('disable')) {
            $(this).addClass('enable');
        }

        // change hover and color
        $('i.stage-icon').removeClass("green_grey");
        $(".select-contact-stage").attr("title", "Preview").attr("data-original-title", "Preview");
        if ($(this).hasClass('green') && $(this).hasClass("enable")) {
            $(this).attr("title", "Reverse").attr("data-original-title", "Reverse").tooltip("fixTitle").tooltip("show");
        }
        else {
            $(this).attr("title", "Confirm").attr("data-original-title", "Confirm").tooltip("fixTitle").tooltip("show");
            $("i[contact_stage_id='"+ contact_stage_id +"']").addClass("green_grey");
        }

    });

    //primary stage update
    $('.select-primary-stage').on("click", function (event, calendar_disabled) {

        // disable changes if jobs finished
        if ($("#is_job_finished").val() == "true") {
            $.jGrowl("This jobs is finished. No further changes to contact stages can be done!", {
                header: 'Important',
                theme: 'error-jGrowl',
                life: 10000
            });
            jGrowl_to_stages();
            return;
        }

        var current_stage_id = $("#current_stage").val();
        var contact_stage_id = $(this).attr('contact_stage_id');
        var current_stage_num = parseInt($("#current_stage_num").val());
        var stage_num = parseInt($(this).attr('stage_num'));

        $(".select-primary-stage").removeClass("no_underline");

        $(".sub_stage_emails").hide();
        $(".cStage2").text($(".select-primary-stage[contact_stage_id='"+ contact_stage_id +"']").text());
        $(".emails_for_stage_"+ contact_stage_id).hide();

        if (!$(this).hasClass('active-stage')) {

            $(".sliding_emails").css({opacity: 0}).hide();

            if ($(".sub_stage_emails.emails_for_stage_"+ contact_stage_id).length > 0) {
                $(".sliding_emails").show().animate({
                    opacity: '1'
                }, 600);

                $(".emails_for_stage_"+ contact_stage_id).delay(5).animate({width:'toggle'},450);
            }
        }

        // cannot complete before book
        if (stage_num == 2 && current_stage_num == 0) {
            $.jGrowl("Cannot advance to the Complete stage, before advancing to the Book stage!", {
                header: 'Important',
                theme: 'error-jGrowl',
                life: 10000
            });
            jGrowl_to_stages();
        }
        else {
            if ($(this).hasClass('active-stage')) {

                if (stage_num >= current_stage_num) {
                    if ($(this).hasClass('jump-truck-calendar')) {
                        var move_date = $('.date-mover:first').val();
                        var move_truck_group = $('.move-truck-calendar').val();
                        if (move_truck_group === '') {
                            expand_where("expand");
                            $.jGrowl("Select a truck group.", {header: 'Error', theme: 'error-jGrowl', life: 5000});
                            return $('html, body').animate({scrollTop: $('.move-truck-calendar').offset().top - 250}, 1000);
                        }
                        else {
                            bootbox.confirm("<h4 class='textOrange'>Are you sure?<br/><br/><h4>Once you advance primary stage, you can not return to previous stages.</h4></h4>", function (result) {
                                if (result) {
                                    location.href = "/calendar?type=trucks&group=" + move_truck_group + "&kind_calendar=resourceDay&move_referred=" + window.location.pathname.split('/')[2] + "&date_calendar=" + moment(move_date, "DD/MM/YYYY").format("YYYY-MM-DD") + "&disabled_stage_emails=" + $(".jump-truck-calendar").attr("disabled_auto_emails");
                                    primary_stage_update = true;
                                    update_contact_stage(contact_stage_id);
                                }
                            });
                        }
                    }
                    else {
                        bootbox.confirm("<h4 class='textOrange'>Are you sure?<br/><br/><h4>Once you advance primary stage, you can not return to previous stages.</h4></h4>", function (result) {
                            if (result) {
                                primary_stage_update = true;
                                update_contact_stage(contact_stage_id);
                                // hide emails
                                $(".sub_stage_emails").hide();
                                $(".sliding_emails").hide();
                                $(".select-primary-stage[contact_stage_id='" + contact_stage_id + "']").addClass("no_underline");

                                // highlight auto-send emails
                                $(".select-contact-email.autosend[contact_stage_id='" + contact_stage_id + "']").find("i").addClass("icon-green");
                                //$(".select-contact-email-preview.autosend[contact_stage_id='" + contact_stage_id + "']").addClass("green bold caps");
                            }
                        });
                    }

                }
                else {
                    $.jGrowl("Cannot return to a previous stage. Previous stages are view only!", {
                        header: 'Important',
                        theme: 'error-jGrowl',
                        life: 10000
                    });
                    jGrowl_to_stages();
                }

            }
        }

        //toggle states
        $('.active-stage').removeClass('active-stage');
        $(this).addClass('active-stage');
        $('i.stage-icon').removeClass("green_grey");
        $(".select-contact-stage").attr("title", "Preview").attr("data-original-title", "Preview");
        $(".book_tab, .complete_tab").attr("title", "Preview").attr("data-original-title", "Preview");
        if ($(this).attr("href") == "#Booked") {
            $(".book_tab").attr("title", "Confirm").attr("data-original-title", "Confirm").tooltip("fixTitle").tooltip("show");
        }
        else if ($(this).attr("href") == "#Complete") {
            $(".complete_tab").attr("title", "Confirm").attr("data-original-title", "Confirm").tooltip("fixTitle").tooltip("show");
        }

    });


    // update calendar link
    $('.move-truck-calendar').on("change", function () {
        var link = $("#cal_link");
        var link2 = $("#cal_link2");
        link.attr("href", "/calendar?group=" + $(this).val() + "&kind_calendar=resourceDay&date_calendar=" + link.attr("data-date-link"))
        link2.attr("href", "/calendar?group=" + $(this).val() + "&kind_calendar=resourceDay&date_calendar=" + link2.attr("data-date-link"))
    });

    $('.select-contact-email-preview').on("click", function (event, calendar_disabled) {
        var contact_stage = $(this).attr('contact_stage_id');
        var contact_email = $(this).attr('contact_email_id');
        var icon_email = $(this).prev().find(' > i');
        var _this = $(this);
        var move_id = number_move_record();

        if (!calendar_disabled) {
            $.ajax({
                    url: '/template_email.json',
                    data: {contact_email: contact_email, move_id: move_id}
                })
                .done(function (data_template) {
                    update_contact_stage(contact_stage, contact_email, false, data_template.template);

                    $(".select-contact-email[contact_email_id='"+ contact_email +"']").find("i").addClass("icon-green");
                    //$(".select-contact-email-preview[contact_email_id='"+ contact_email +"']").addClass("green bold caps");

                    $.jGrowl("Email has been sent.", {header: 'Success', theme: 'success-jGrowl'});
                });

        }
    });

    $('.sub_stage_emails, .sub_stage_emails2').on("mouseover", function (event) {
        $(this).find('.select-contact-email-preview2').removeClass("hidden");
    });

    $('.sub_stage_emails, .sub_stage_emails2').on("mouseout", function (event) {
        $(this).find('.select-contact-email-preview2').addClass("hidden");
    });

    $('.sub_stage_emails2_manual').on("mouseover", function (event) {
        $(this).find('.select-contact-email-preview2-manual').removeClass("hidden");
    });

    $('.sub_stage_emails2_manual').on("mouseout", function (event) {
        $(this).find('.select-contact-email-preview2-manual').addClass("hidden");
    });

    $('.select-contact-email-preview2').on("click", function (event, calendar_disabled) {
        var contact_stage = $(this).attr('contact_stage_id');
        var contact_email = $(this).attr('contact_email_id');
        var stage_name = $(this).attr('stage_name');
        var email_description = $(this).attr('email_description');
        var move_id = number_move_record();

        if(!calendar_disabled){
            $.ajax({
                    url: '/template_email.json',
                    data: {contact_email: contact_email, move_id: move_id}
                })
                .done(function(data_template) {
                    var html_template_email = '<textarea class="form-control wysihtml5" required="required" readonly rows="20" style="height: auto;">' + data_template.template + '</textarea>';
                    var html_email_preview = "<div>"+ data_template.template +"</div>";
                    var info = "<div class='mtop5 p10 text_white_on_grey font_small'>This email is associated to the contact stage <b class='textOrange bold'>"+ stage_name +"</b>";
                    if (email_description != "") {
                        info += "<div class='mtop10'><i class='fa fa-info-circle small_icon' aria-hidden='true' data-toggle='tooltip' data-placement='bottom' title='Info and Instructions'></i> " + email_description + "</div>";
                    }
                    info += "</div>";
                    bootbox.dialog({
                        className: "modal-custom-lg",
                        message: html_email_preview,
                        title: "Email Preview<br>" + info,
                        closeButton: true,
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function() {
                                    $(this).modal('hide');
                                }
                            },
                            primary: {
                                label: "Send",
                                className: "btn-primary",
                                callback: function() {
                                    $(this).modal('hide');
                                    $(".sub_stage_emails").find(".select-contact-email-preview[contact_email_id='"+ contact_email +"']").trigger( "click" );

                                }
                            }
                        }
                    });
                    $('.wysihtml5').wysihtml5({
                        "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
                        "emphasis": true, //Italics, bold, etc. Default true
                        "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
                        "false": true, //Button which allows you to edit the generated HTML. Default false
                        "link": true, //Button to insert a link. Default true
                        "image": true, //Button to insert an image. Default true,
                        "color": true //Button to change color of font
                    });
                });
        }
    });

    $('.select-contact-email-preview2-manual').on("click", function (event, calendar_disabled) {
        var type = $(this).attr('type');
        var stage_name = $(this).attr('stage_name');
        var email_description = $(this).attr('email_description');
        var move_id = number_move_record();

        if(!calendar_disabled){
            $.ajax({
                    url: '/template_email.json',
                    data: {manual: 'true', move_id: move_id, type: type}
                })
                .done(function(data_template) {
                    var html_email_preview = "<div>"+ data_template.template +"</div>";
                    var info = "<div class='mtop5 p10 text_white_on_grey font_small'>This email is associated to the contact stage <b class='textOrange bold'>"+ stage_name +"</b>";
                    if (email_description != "") {
                        info += "<div class='mtop10'><i class='fa fa-info-circle small_icon' aria-hidden='true' data-toggle='tooltip' data-placement='bottom' title='Info and Instructions'></i> " + email_description + "</div>";
                    }
                    info += "</div>";
                    bootbox.dialog({
                        className: "modal-custom-lg",
                        message: html_email_preview,
                        title: "Email Preview<br>" + info,
                        closeButton: true,
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function() {
                                    $(this).modal('hide');
                                }
                            },
                            primary: {
                                label: "Send",
                                className: "btn-primary",
                                callback: function() {
                                    $(this).modal('hide');
                                    $(".sub_stage_emails2_manual").find("#"+ type +"_mail").trigger( "click" );

                                }
                            }
                        }
                    });
                    $('.wysihtml5').wysihtml5({
                        "font-styles": true, //Font styling, e.g. h1, h2, etc. Default true
                        "emphasis": true, //Italics, bold, etc. Default true
                        "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
                        "false": true, //Button which allows you to edit the generated HTML. Default false
                        "link": true, //Button to insert a link. Default true
                        "image": true, //Button to insert an image. Default true,
                        "color": true //Button to change color of font
                    });
                });
        }
    });

    $('body').on("dblclick", ".select-contact-email", function (event, calendar_disabled) {
        var contact_stage = $(this).attr('contact_stage_id');
        var contact_email = $(this).attr('contact_email_id');
        if (!calendar_disabled) {
            update_contact_stage(contact_stage, contact_email, false, null);
            $(this).find('i').addClass('icon-green');
        }
    });

    $('.calculateDiscount').on("change keyup keydown click", function () {
        if ($('.discount_percentage').val() != "") {
            $('.discount_hourly').attr('readonly', true);
            $('.discount_hourly').val('');
            calculatePercentDiscount();
        } else if ($('.discount_hourly').val() != "") {
            $('.discount_percentage').attr('readonly', true);
            $('.discount_percentage').val('');
            calculateHourlyDiscount();
        } else {
            $('.discount_percentage').attr('readonly', false);
            $('.discount_hourly').attr('readonly', false);
            calculatePercentDiscount();
        }
        calcInsurance();
        calculateSubTotalMove();
        calcTotalMove();
        calcBalance();
    });

    $('.calculateFuel').on("change keyup keydown click", function () {
        if ($('.fuel_cost_percentage_mc').val() != "") {
            $('.fuel_cost_fixed').attr('readonly', true);
            $('.fuel_cost_fixed').val('');
            calculatePercentFuel();
        } else if ($('.fuel_cost_fixed').val() != "") {
            $('.fuel_cost_percentage_mc').attr('readonly', true);
            $('.fuel_cost_percentage_mc').val('');
            calculateFixedFuel();
        } else {
            $('.fuel_cost_percentage_mc').attr('readonly', false);
            $('.fuel_cost_fixed').attr('readonly', false);
            calculatePercentFuel();
        }
        calcInsurance();
        calculateSubTotalMove();
        calcTotalMove();
        calcBalance();
    });

    $('.calculateInsurance, .calculateBalance, .calculateTax, .calculateTotal').on("change keyup keydown click", function () {
        wrapCalculationsCost();
    });

    $('.options').on("click", function () {
        $(".dropdown-options").stop().slideToggle();
    });

    $('.dropdown-options li').on('click', function (e) {
        e.preventDefault();
        var field = $(this).attr('field');
        if ($('.' + field).hasClass('hide') || $('.' + field).is(":hidden")) {
            $('.' + field).removeClass('hide').show().find('input, select').removeAttr('disabled');
            $(this).find('i').addClass('fa-minus icon-red').removeClass('fa-plus icon-green');
            $('.' + field).append('<input type="hidden" name="move_record[' + field + '_selected]" value=true>');
            return;
        }
        $('.' + field).removeClass('show').hide().find('input, select').attr('disabled', true);
        $(this).find('i').removeClass('fa-minus icon-red').addClass('fa-plus icon-green');
        $('.' + field).append('<input type="hidden" name="move_record[' + field + '_selected]" value=false>');
    });

    $('.toggle-div').on('click', function (event) {
        $(this).next().stop().slideToggle();
    });

    $('.check-option-disabled.hide').each(function () {
        $(this).find('input, select').attr('disabled', 'disabled')
    });

    // stages loop
    var edit_move_record = $('.edit-move-record');

    edit_move_record.each(function () {
        var contact_stages = eval($(this).val());

        //console.log("stages: "+ JSON.stringify(contact_stages));
        var sub_stage, sub_stage_icon;

        for (var stage in contact_stages) {
            if (selected_contact_stage[contact_stages[stage].id] === undefined) {
                sub_stage = $('.stages label[contact_stage_id="' + contact_stages[stage].id + '"]');
                //sub_stage_icon = $('.stages i[contact_stage_id="' + contact_stages[stage].id + '"]');

                if (sub_stage.text() == "Unable" || sub_stage.text() == "Cancel" || sub_stage.text() == "Post") {
                    sub_stage.addClass('bright_red bold caps underline').removeClass('green disable active-stage');
                    $("#is_job_finished").val("true");
                    $("#job_status").html("(Job Finished)");
                }
                else {
                    sub_stage.addClass("green bold caps").removeClass("disable active-stage").attr("data-toggle", "");
                    //sub_stage_icon.addClass("icon-green").removeClass("icon-red")
                }
            }
            var contact_email = contact_stages[stage].email[function () {
                for (var k in contact_stages[stage].email) return k
            }()];
            if (contact_email.id != null) {
                $(".select-contact-email[contact_email_id='"+ contact_email.id +"']").find("i").addClass("icon-green");
                //$(".select-contact-email-preview[contact_email_id='"+ contact_email.id +"']").addClass("green bold caps");
            }
        }

        // show active stage emails
        //$('.edit_move_record [contact_stage_id="' + $("#current_stage").val() + '"]').trigger('click', [true]);
        //$('.edit_move_record [contact_stage_id="' + $("#current_stage").val() + '"]:not(.select-contact-email):not(.select-contact-email-preview)').addClass("underline");
        $(".sub_stage_emails").hide();
        $(".sliding_emails").show();
        $(".sub_stage_emails.emails_for_stage_" + $("#current_stage").val()).show();


        // pdf emails highlight
        if ($(".full-wrap-messages-move-record:contains('Follow Up Email')").length > 0){
            //$("#move_followup_mail").addClass("green bold caps");
            $("#move_followup_mail_icon").removeClass("icon-red").addClass("icon-green");
        }

        if ($(".full-wrap-messages-move-record:contains('Move Proposal Email')").length > 0){
            //$("#move_proposal_mail").addClass("green bold caps");
            $("#move_proposal_mail_icon").removeClass("icon-red").addClass("icon-green");
        }

        if ($(".full-wrap-messages-move-record:contains('CC Consent Email')").length > 0){
            //$("#cc_consent_mail").addClass("green bold caps");
            $("#cc_consent_mail_icon").removeClass("icon-red").addClass("icon-green");
        }

        if ($(".full-wrap-messages-move-record:contains('Non Disclosure Email')").length > 0){
            //$("#non_disclosure_mail").addClass("green bold caps");
            $("#non_disclosure_mail_icon").removeClass("icon-red").addClass("icon-green");
        }

        if ($(".full-wrap-messages-move-record:contains('Move Invoice Email')").length > 0){
            //$("#invoice_mail").addClass("green bold caps");
            $("#move_invoice_mail_icon").removeClass("icon-red").addClass("icon-green");
        }

        if ($(".full-wrap-messages-move-record:contains('Move Receipt Email')").length > 0){
            //$("#receipt_mail").addClass("green bold caps");
            $("#move_receipt_mail_icon").removeClass("icon-red").addClass("icon-green");
        }
    });

    $('.move-record-toggle-share').on('click', function () {
        var is_visible = $(".cost-move-record").is(":visible");
        $('.commision-move-record, .cost-move-record').toggle('slow');
        $(this).text(is_visible ? 'Cost' : 'Shares');
    });

    $('.move-record-toggle-submit').on('click', function () {
        $('.wrap-cost-move-record, .cost-move-record-submit').toggle('slow');
    });

    $('.change-commission-user').on('change', function () {
        var commission_selected = $(this);
        var staff_id = commission_selected.val();
        var commission_key = commission_selected.data('commission');
        var key_dinamic_commission = [];
        var name_commission = '';
        var move_type = $(".move_type_id").val();
        $.ajax({
                url: '/commission_staff.json',
                data: {
                    commission_key: commission_key,
                    staff_id: staff_id
                }
            })
            .done(function (data) {
                if (data != null) {
                    key_dinamic_commission = $.makeArray(data);
                    if (move_type == 2) {
                        commission_selected.parents('.calculate-commission').find('input').each(function () {
                            name_commission = $(this).attr('id').split("_");
                            $(this).val(key_dinamic_commission[0]['ld_' + name_commission[1]]);
                        });
                    } else {
                        commission_selected.parents('.calculate-commission').find('input').each(function () {
                            name_commission = $(this).attr('id').split("_");
                            $(this).val(key_dinamic_commission[0][name_commission[1]]);
                        });
                    }

                } else {
                    commission_selected.parents('.calculate-commission').find('input').val('0.0');
                }
                calculateCommission();
            })
            .fail(function () {
                alert('Error');
            });

    });

    $('.client-name').autocomplete({
        source: "client_information.json",
        minLength: 0,
        select: function (event, ui) {
            var row_client = $(this).closest('.client-row');
            row_client.find('.client-title').val(ui.item.extra_data.title);
            row_client.find('.client-home-phone').val(ui.item.extra_data.home_phone);
            row_client.find('.client-cell-phone').val(ui.item.extra_data.cell_phone);
            row_client.find('.client-work-phone').val(ui.item.extra_data.work_phone);
            row_client.find('.client-email').val(ui.item.extra_data.email);
            submit_new_move_record();
        },
        change: function () {
            var row_client = $(this).closest('.client-row');
            if (row_client.find('.' + $(this).attr('id')).val() === '') {
                row_client.find('.client-title').val('');
                row_client.find('.client-home-phone').val('');
                row_client.find('.client-cell-phone').val('');
                row_client.find('.client-work-phone').val('');
                row_client.find('.client-email').val('');
            }
        },
        response: function (event, ui) {
            var row_client = $(this).closest('.client-row');
            row_client.find('.client-title').val('');
            row_client.find('.client-home-phone').val('');
            row_client.find('.client-cell-phone').val('');
            row_client.find('.client-work-phone').val('');
            row_client.find('.client-email').val('');
        }
    });

    $('.province-tax:first').on('change', function () {
        var gst_tax = $(this).find(":selected").data('tax-gst');
        var pst_tax = $(this).find(":selected").data('tax-pst');
        $('[name="other_cost[percentage_gst]"], [name="surcharge[percentage_gst]"]').val(gst_tax);
        $('[name="other_cost[percentage_pst]"], [name="surcharge[percentage_pst]"]').val(pst_tax);
        wrapCalculationsCost();
    });

    if (edit_move_record.length === 0) {
        $('.province-tax:first').trigger('change');
    } else {
        calc_cargo();
    }

    $('.move-map').on('click', function () {
        var url_map = "https://www.google.ca/maps/dir/";
        var origin = $('.origin-row:first');
        var destination = $('.destination-row:first');
        var origin_no = origin.find('.data-no').val() ? origin.find('.data-no').val() + " " : "";
        var origin_street = origin.find('.data-street').val() ? origin.find('.data-street').val() + " " : "";
        var origin_city = origin.find('.data-city').val() ? origin.find('.data-city').val() + " " : "";
        var origin_province = origin.find('.data-province :selected').val() ? origin.find('.data-province :selected').val() + " " : "";
        var origin_postal_code = origin.find('.data-postal-code').val() ? origin.find('.data-postal-code').val() + " " : "";
        var destination_no = destination.find('.data-no').val() ? destination.find('.data-no').val() + " " : "";
        var destination_street = destination.find('.data-street').val() ? destination.find('.data-street').val() + " " : "";
        var destination_city = destination.find('.data-city').val() ? destination.find('.data-city').val() + " " : "";
        var destination_province = destination.find('.data-province :selected').val() ? destination.find('.data-province :selected').val() + " " : "";
        var destination_postal_code = destination.find('.data-postal-code').val() ? destination.find('.data-postal-code').val() + " " : "";
        var params_origin = origin_no + origin_street + origin_city + origin_province + origin_postal_code;
        var params_destination = destination_no + destination_street + destination_city + destination_province + destination_postal_code;

        $(this).attr('href', url_map + params_origin + "/" + params_destination);
    });

    $('.room-cargo').on('change', function () {
        var room_selected = $(this).val();
        $.ajax({
                url: '/furnishings_information.json',
                data: {room: room_selected},
            })
            .done(function (data) {
                var html_table = '';
                $.each(data, function (index, value) {
                    html_table += '<tr data-furnishing="' + value.id + '" class="pointer"><td>' + value.name + '</td></tr>'
                });
                $('.furnishings-table tbody').html(html_table);
            })
            .fail(function () {
                alert('error')
            });

    });

    $('body').on('click', '.furnishings-table tbody tr', function () {
        $('.furnishings-table tbody tr').removeClass('active');
        cargo_template($(this).data('furnishing'));
        $(this).addClass('active');
    });

    $('.add-new-cargo-template').on('click', function () {
        var html_cargo_template = $('.cargo-template-table tbody tr:first').clone();
        $('.cargo-template-table tbody').append('<tr class="cargo_template">' +
            html_cargo_template.html().replace(/(\[\d*\])/g, '[new_' + ($('.cargo-template-table tbody tr').length + 1) + ']')
                .replace(/(\[new_\d*\])/g, '[new_' + ($('.cargo-template-table tbody tr').length + 1) + ']') +
            '</tr>');
        html_cargo_template = $('.cargo-template-table tbody tr:last');
        html_cargo_template.find('input').val('');
        html_cargo_template.find('input[type="number"]').val('0');
        html_cargo_template.find('i').removeAttr('data-cargo');
        cargo_template($('.furnishings-table tbody tr.active').data('furnishing'));
    });

    $('body').on('click', '.remove-cargo-template', function () {
        if ($(this).data('cargo')) {
            $('.cargo-template-table').append('<input name="calc_cargo[delete_' + ($('.cargo-template-table tbody tr').length + 1) + '][delete]" type="hidden" value="' + $(this).data('cargo') + '">');
        }
        if ($('.cargo-template-table tbody tr').length == 1) {
            $('.add-new-cargo-template').trigger('click');
        }
        $(this).closest('tr').remove();
        calc_cargo();
        $('.edit_move_record textarea').trigger('change');
    });

    $('body').on('blur focus change keyup keydown', '.cargo-template-table tbody tr input', function () {
        calc_cargo();
    });

    $('.save-cargo').on('click', function () {
        var weight = $('.calc-weight').text();
        $("#move_record_cargo_weight").val(weight);
        var volume = $('.calc-volume').text();
        $("#move_record_cargo_cubic").val(volume);
    });

    $('li.printers-item').on('click', function (event) {
        var url = $(this).attr('href');
        $.jGrowl('<div class="loading_circle"><i class="icon-3x fa-cog icon-spin"></i> Generating pdf</div>', {theme: 'info-jGrowl'});
        $.ajax({
                url: url,
                dataType: 'binary'
            })
            .done(function (data, textStatus, request) {
                var attachment_header = request.getResponseHeader('Content-Disposition');
                var match = /filename=\"(\w+.\w+)\"/.exec(attachment_header);
                var name = match[1];
                url = URL.createObjectURL(data);
                $('<a />', {
                    'href': url,
                    'download': name,
                    'text': "click"
                }).hide().appendTo("body")[0].click();
                $.jGrowl("File was downloaded successfully.", {header: 'Success', theme: 'success-jGrowl'});
                $('.printer-icon').trigger('click');
            })
            .fail(function (data) {
                $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
            });

    });

    $('label.mail-item').on('click', function (event) {
        var url = $(this).attr('href');
        var _this = $(this);

        $.jGrowl('<div class="loading_circle"><i class="icon-3x fa-cog icon-spin"></i> Generating pdf</div>', {theme: 'info-jGrowl'});
        $.ajax({
                url: url
            })
            .done(function (data, textStatus, request) {
                if (data != false) {
                    $.jGrowl("Message was sent successfully.", {header: 'Success', theme: 'success-jGrowl'});

                    // Append messages log
                    if (data.message != null) {

                        var created_date = new Date(data.message.created_at.replace("T", " ").replace("Z", ""));
                        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                        var log_date = created_date.toLocaleTimeString().replace(/:\d+ /, ' ').toLowerCase() + ' ' + monthNames[created_date.getMonth()] + ' ' + created_date.getDate();
                        var email_icon = '<i class="fa fa-envelope" aria-hidden="true"></i>';

                        $(".full-wrap-messages-move-record").hide().prepend('' +
                            '<div class="panel panel-default wrap-full-message no-m-bottom" data-message="' + data.message.id + '">' +
                            '<div class="panel-heading accordion-toggle collapsed" data-parent="#accordion0" data-toggle="collapse" href="#collapse-0-0" title="Click to expand">' +
                            '<div class="row">' +
                            '<div class="col-md-1">' + email_icon +'</div>' +
                            '<div class="col-md-1">' +
                            '<span>' + data.name + '</span>' +
                            '</div>' +
                            '<div class="row col-md-8">' +
                            '<div class="col-md-4">' +
                            '<span></span>' +
                            '</div>' +
                            '<div class="col-md-7">' +
                            '<span class="subject">' + data.message.subject + '</span>' +
                            '<span class="text-gray"> - ' + data.message.body.substring(0, 40) + '</span>' +
                            '</div>' +
                            '</div>' +
                            '<div class="col-md-2">' +
                            '<i class="icon-"></i>' +
                            '<span>' + log_date + '</span>' +
                            '</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="panel-collapse collapse" id="collapse-0-0">' +
                            '<div class="panel-body body-warp-message">' +
                            '<div class="body-message col-md-8 col-md-offset-2 p13">' + data.message.body + '</div>' +
                            '</div>' +
                            '</div>' +
                            '</div>' +
                            '').fadeIn();
                        $('[data-message="' + data.message.id + '"]').hide().fadeIn("slow");

                        //_this.addClass("green bold caps");
                        _this.prev().find("i").removeClass("icon-red").addClass("icon-green");

                    }


                } else {
                    $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
                }
                $('.mail-icon').trigger('click');
            })
            .fail(function (data) {
                $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
            });
    });

    $(".client-name, .client-email").on('change', function (event) {
        if ($.trim($('.client-name:first').val()) !== "" && $.trim($('.client-email:first').val()) !== "") {
            submit_new_move_record();
        }
    });

    var timeoutId;
    $('body').on('input propertychange change', '.edit_move_record input, .edit_move_record textarea, .edit_move_record select', function () {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(function () {
            update_move_record_form();
        }, 2000);
    });

    $('body').on('click', '.nav li a', function (event) {
        if (is_move_record()) {
            update_move_record_form();
        }
    });

    //$('body').on('click', '.remove-move-record', function(event) {
    //  var move_record_id = $(this).data('move-id');
    //  localStorage.removeItem( current_user + '_moverecord_' + move_record_id);
    //  update_move_record_form();
    //});

    $('body').on('click', '.minus-move-record', function (event) {
        active_move_record(current_user);
        update_move_record_form();
    });

    active_move_record(current_user);

    $(".panel-heading").on("click", function () {
        //console.log();
        if ($(this).attr("class") == "panel-heading accordion-toggle collapsed") {
            $(this).attr("style", "background-color: white");
        }
        else {
            $(this).attr("style", "background-color: whitesmoke");
        }
    });

    //.form-control:focus
    $(".form-control").on("focus", function () {
        $(this).addClass("form-control2").removeClass("text-grey");
    });

    // load locales on city change
    //$(".data-city").on("change", function () {
    //    var truck_group_id = $(".move-truck-calendar option:selected").val();
    //    var city_id = $("#" + $(this).attr("id") + " option:selected").attr("data-id");
    //    var locale_elem = $(this).attr("id").replace("city", "locale");
    //    $("#" + locale_elem).empty();
    //    $("#" + locale_elem).append("<option></option>");
    //
    //    $.get("/get_locale_by_city_and_truck_group",
    //        {
    //            "city_id": city_id,
    //            "calendar_truck_group_id": truck_group_id
    //        },
    //        function (data) {
    //            if (data) {
    //                $.each(data.locales, function (i, item) {
    //                    var html = '<option value="' + item.locale_name + '" ';
    //                    if (data.locale_id == item.id) {
    //                        html += 'selected';
    //                    }
    //                    html += '>' + item.locale_name + '</option>';
    //
    //                    $("#" + locale_elem).append(html);
    //
    //                });
    //            }
    //        }, "json");
    //});

    // load cities and locales on province change
    $(".data-province").on("change", function () {
        var province_id = $("#" + $(this).attr("id") + " option:selected").attr("data-id");
        var city_elem = $(this).attr("id").replace("province", "city");
        var locale_elem = $(this).attr("id").replace("province", "locale");
        $("#" + city_elem).empty();
        $("#" + locale_elem).empty();
        $("#" + city_elem).append("<option></option>");
        $("#" + locale_elem).append("<option></option>");

        var truck_group_id = $(".move-truck-calendar option:selected").val();
        var group_id = $(this).attr("id").replace("province", "");
        var group_index = $("#" + group_id + "calendar_truck_group_id option:selected").attr("data_origin_index");

        get_city_by_truck_group(province_id, 0, false, group_id, group_index);
    });

    // Move date only editable before Book stage
    $(".book_date").on("click", function () {
        if ($('.jump-truck-calendar').hasClass("green") || $('label[for="contact_stage_Unable"]').hasClass("bright_red")) {
            $.jGrowl("You can edit move date only before BOOK stage and not Unabled! Once BOOK stage has been reached, move date cannot be modified.", {
                header: 'Important',
                theme: 'error-jGrowl',
                life: 15000
            });
            $(".book_date").prop("disabled", true);
        }
    });

    static_link_css_class($("#current_stage").val(), $("#cStage").text());

    // enable tooltips
    $('[data-toggle="tooltip"]').tooltip();

    // expand all referral emails
    $(".expand-all-referral-emails").on("click", function(){
        var is_state_down = ($(this).data("state") == "down");

        if (is_state_down){
            $(this).hide().html('<img src="/assets/arrow_up.png" width="12">').fadeIn();
            $(this).data("state", "up");
            $(this).attr("data-original-title", "Collapse All");
            $(".referral-emails").slideDown("fast");
        }
        else {
            $(this).hide().html('<img src="/assets/arrow_down.png" width="12">').fadeIn();
            $(this).data("state", "down");
            $(this).attr("data-original-title", "Expand All");
            $(".referral-emails").slideUp("fast");
        }
    })

    // expand all review emails
    $(".expand-all-review-emails").on("click", function(){
        var is_state_down = ($(this).data("state") == "down");

        if (is_state_down){
            $(this).hide().html('<img src="/assets/arrow_up.png" width="12">').fadeIn();
            $(this).data("state", "up");
            $(this).attr("data-original-title", "Collapse All");
            $(".review-emails").slideDown("fast");
        }
        else {
            $(this).hide().html('<img src="/assets/arrow_down.png" width="12">').fadeIn();
            $(this).data("state", "down");
            $(this).attr("data-original-title", "Expand All");
            $(".review-emails").slideUp("fast");
        }
    });

    // pull sub-source on source change
    $('#move_record_move_source_id').on('input', function() {
        get_subsources($('#move_record_move_source_id').val(), true);
    });

    // auto-mail disable/enable
    $('.auto-send-icon').on('click', function() {
        var contact_stage_id = $(this).attr("contact_stage_id");
        var contact_email_id = $(this).attr("contact_email_id");
        var disabled_stage_emails = $('.select-contact-stage[contact_stage_id="'+ contact_stage_id +'"], .select-primary-stage[contact_stage_id="'+ contact_stage_id +'"]').attr("disabled_auto_emails");

        if($(this).attr("state") == "enabled") {
            // disable
            $('.auto-send-icon[contact_email_id="'+ contact_email_id +'"]').find(" > img").attr("src", "/assets/auto-send-disable.png");
            $('.auto-send-icon[contact_email_id="'+ contact_email_id +'"]').attr("state", "disbaled");
            $('.auto-send-icon[contact_email_id="'+ contact_email_id +'"]').attr("data-original-title", "Enable auto-send");
            $('.select-contact-email[contact_email_id="'+ contact_email_id +'"]').removeClass("autosend");
            $('.select-contact-email-preview[contact_email_id="'+ contact_email_id +'"]').removeClass("autosend");
            disabled_stage_emails == "" ? $('.select-contact-stage[contact_stage_id="'+ contact_stage_id +'"], .select-primary-stage[contact_stage_id="'+ contact_stage_id +'"]').attr("disabled_auto_emails", contact_email_id) : $('.select-contact-stage[contact_stage_id="'+ contact_stage_id +'"], .select-primary-stage[contact_stage_id="'+ contact_stage_id +'"]').attr("disabled_auto_emails", disabled_stage_emails +","+ contact_email_id);
        }
        else{
            // enable
            $('.auto-send-icon[contact_email_id="'+ contact_email_id +'"]').find(" > img").attr("src", "/assets/auto-send.png");
            $('.auto-send-icon[contact_email_id="'+ contact_email_id +'"]').attr("state", "enabled");
            $('.auto-send-icon[contact_email_id="'+ contact_email_id +'"]').attr("data-original-title", "Disable auto-send");
            $('.select-contact-email[contact_email_id="'+ contact_email_id +'"]').addClass("autosend");
            $('.select-contact-email-preview[contact_email_id="'+ contact_email_id +'"]').addClass("autosend");
            var updated_disabled_stage_emails = disabled_stage_emails.replace(","+ contact_email_id, "").replace(contact_email_id +",", "").replace(contact_email_id, "");
            $('.select-contact-stage[contact_stage_id="'+ contact_stage_id +'"], .select-primary-stage[contact_stage_id="'+ contact_stage_id +'"]').attr("disabled_auto_emails", updated_disabled_stage_emails);
        }
    });

});

function get_subsources(ctext, clean_up){
    $("#move_source_id").find("option").each(function() {
        if ($(this).val() == ctext) {
            if(clean_up == true){ $("#move_record_move_subsource_id").val(""); }
            $.ajax({
                url: '/get_subsource_by_source.json',
                type: 'GET',
                data: {source: ctext}
            }).done(function (data) {
                var subsources = "";

                for (var i in data) {
                    subsources += "<option value='"+ data[i].description +"'>"+ data[i].description +"</option>";
                    if (data[i].default == true && $("#move_record_move_subsource_id").val() == ""){
                        $("#move_record_move_subsource_id").val(data[i].description).addClass("form-control2").removeClass("text-grey")
                    }
                }

                $('#move_subsource_id').html(subsources);
            })
        }
    })
}

function jGrowl_to_stages() {
    //$("#jGrowl").attr("style", "right: 33%; top: 54px");
}

// sections expand functions
function expand_who(mode) {
    var state_down = $(".expand-who").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-who").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".who_info").addClass("hide");
        }
        else {
            $(".expand-who").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".who_info").removeClass("hide").hide().fadeIn();
        }
        $(".who-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-who").html("<i class='fa fa-chevron-up'></i>");
        $(".who-section").slideDown();
        $(".who_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-who").html("<i class='fa fa-chevron-down'></i>");
        $(".who-section").slideUp();
        $(".who_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_what(mode) {
    var state_down = $(".expand-what").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-what").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".what_links").removeClass("hide").hide().fadeIn();
            $(".what_info").addClass("hide");
        }
        else {
            $(".expand-what").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".what_links").addClass("hide");
            $(".what_info").removeClass("hide").hide().fadeIn();
        }
        $(".what-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-what").html("<i class='fa fa-chevron-up'></i>");
        $(".what_links").removeClass("hide");
        $(".what-section").slideDown();
        $(".what_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-what").html("<i class='fa fa-chevron-down'></i>");
        $(".what_links").addClass("hide");
        $(".what-section").slideUp();
        $(".what_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_where(mode) {
    var state_down = $(".expand-where").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-where").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".where_links").removeClass("hide").hide().fadeIn();
            $(".where_info").addClass("hide");
        }
        else {
            $(".expand-where").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".where_links").addClass("hide");
            $(".where_info").removeClass("hide").hide().fadeIn();
        }
        $(".where-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-where").html("<i class='fa fa-chevron-up'></i>");
        $(".where_links").removeClass("hide");
        $(".where-section").slideDown();
        $(".where_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-where").html("<i class='fa fa-chevron-down'></i>");
        $(".where_links").addClass("hide");
        $(".where-section").slideUp();
        $(".where_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_when(mode) {
    var state_down = $(".expand-when").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-when").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".when_links").removeClass("hide").hide().fadeIn();
            $(".when_info").addClass("hide");
        }
        else {
            $(".expand-when").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".when_links").addClass("hide");
            $(".when_info").removeClass("hide").hide().fadeIn();
        }
        $(".when-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-when").html("<i class='fa fa-chevron-up'></i>");
        $(".when_links").removeClass("hide");
        $(".when-section").slideDown();
        $(".when_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-when").html("<i class='fa fa-chevron-down'></i>");
        $(".when_links").addClass("hide");
        $(".when-section").slideUp();
        $(".when_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_how(mode) {
    var state_down = $(".expand-how").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-how").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".how_info").addClass("hide");
        }
        else {
            $(".expand-how").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".how_info").removeClass("hide").hide().fadeIn();
        }
        $(".how-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-how").html("<i class='fa fa-chevron-up'></i>");
        $(".how-section").slideDown();
        $(".how_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-how").html("<i class='fa fa-chevron-down'></i>");
        $(".how-section").slideUp();
        $(".how_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_how_much(mode) {
    var state_down = $(".expand-how-much").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-how-much").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".how_much_links").removeClass("hide").hide().fadeIn();
            $(".how_much_info").addClass("hide");
        }
        else {
            $(".expand-how-much").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".how_much_links").addClass("hide");
            $(".how_much_info").removeClass("hide").hide().fadeIn();
        }
        $(".how-much-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-how-much").html("<i class='fa fa-chevron-up'></i>");
        $(".how_much_links").removeClass("hide");
        $(".how-much-section").slideDown();
        $(".how_much_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-how-much").html("<i class='fa fa-chevron-down'></i>");
        $(".how_much_links").addClass("hide");
        $(".how-much-section").slideUp();
        $(".how_much_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_note(mode) {
    var state_down = $(".expand-note").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-note").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".note_info").addClass("hide");
        }
        else {
            $(".expand-note").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".note_info").removeClass("hide").hide().fadeIn();
        }
        $(".note-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-note").html("<i class='fa fa-chevron-up'></i>");
        $(".note-section").slideDown();
        $(".note_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-note").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
        $(".note-section").slideUp();
        $(".note_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_contact_stage(mode) {
    var state_down = $(".expand-contact-stage").find("i").hasClass("fa-chevron-down");

    if(!mode) {
        if (state_down) {
            $(".expand-contact-stage").hide().html("<i class='fa fa-chevron-up'></i>").fadeIn();
            $(".contact_stage_links").removeClass("hide").hide().fadeIn();
            $(".contact_stage_info").addClass("hide");
        }
        else {
            $(".expand-contact-stage").hide().html("<i class='fa fa-chevron-down'></i>").fadeIn();
            $(".contact_stage_links").addClass("hide");
            $(".contact_stage_info").removeClass("hide").hide().fadeIn();
        }
        $(".contact-stage-section").slideToggle();
    }
    else if(mode == "expand") {
        $(".expand-contact-stage").html("<i class='fa fa-chevron-up'></i>");
        $(".contact_stage_links").removeClass("hide");
        $(".contact-stage-section").slideDown();
        $(".contact_stage_info").addClass("hide");
    }
    else if(mode == "colapse") {
        $(".expand-contact-stage").html("<i class='fa fa-chevron-down'></i>");
        $(".contact_stage_links").addClass("hide");
        $(".contact-stage-section").slideUp();
        $(".contact_stage_info").removeClass("hide").hide().fadeIn();
    }
}

function expand_sections(){
    expand_who("expand");
    expand_what("expand");
    expand_where("expand");
    expand_when("expand");
    expand_how("expand");
    expand_how_much("expand");
    expand_note("expand");
    expand_contact_stage("expand");

    $("#top-move").hide().html('<a class="btn btn-xs btn-link white no_underline" href="#" onclick="colapse_sections()">Colapse All <i class="fa fa-chevron-circle-up"></i></a>').fadeIn();
}

function colapse_sections(){
    expand_who("colapse");
    expand_what("colapse");
    expand_where("colapse");
    expand_when("colapse");
    expand_how("colapse");
    expand_how_much("colapse");
    expand_note("colapse");
    expand_contact_stage("colapse");

    $("#top-move").hide().html('<a class="btn btn-xs btn-link white no_underline" href="#" onclick="expand_sections()">Expand All <i class="fa fa-chevron-circle-down"></i></a>').fadeIn();
}

// end sections expand

function update_contact_stage(contact_stage_id, contact_email_id, delete_contact_stage, template_email, show_growl, earlier_stage) {
    var data_contact_stage = {
        move_id: number_move_record(),
        contact_stage_id: contact_stage_id
    }
    if (contact_email_id !== undefined && contact_email_id !== false) {
        data_contact_stage.email_alert_id = contact_email_id;
        data_contact_stage.template_email = template_email;
    }

    if (delete_contact_stage === true) {
        data_contact_stage.delete_contact_stage = delete_contact_stage;
    }

    if (earlier_stage === true) {
        data_contact_stage.earlier_stage = true;
    }

    if ($('.select-contact-stage[contact_stage_id="'+ contact_stage_id +'"], .select-primary-stage[contact_stage_id="'+ contact_stage_id +'"]').attr("disabled_auto_emails") != ""){
        data_contact_stage.disabled_stage_emails = $('.select-contact-stage[contact_stage_id="'+ contact_stage_id +'"], .select-primary-stage[contact_stage_id="'+ contact_stage_id +'"]').attr("disabled_auto_emails");
    }

    $.ajax({
            url: '/update_contact_stages',
            type: 'PUT',
            data: data_contact_stage
        })
        .done(function (data) {
            if (show_growl != false) {
                // Append messages log
                if (data.log_messages != null) {

                    $.each(data.log_messages, function (index, message) {
                        var created_date = new Date(message.created_at.replace("T", " ").replace("Z", ""));
                        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                        var log_date = created_date.toLocaleTimeString().replace(/:\d+ /, ' ').toLowerCase() + ' ' + monthNames[created_date.getMonth()] + ' ' + created_date.getDate();
                        var email_icon = "";

                        if (message.message_type != "email") {
                            $.jGrowl("Contact Stage updated.", {header: 'Success', theme: 'success-jGrowl'});
                        } else {
                            email_icon = '<i class="fa fa-envelope" aria-hidden="true"></i>';
                        }

                        $(".full-wrap-messages-move-record").hide().prepend('' +
                            '<div class="panel panel-default wrap-full-message no-m-bottom" data-message="' + message.id + '">' +
                            '<div class="panel-heading accordion-toggle collapsed" data-parent="#accordion0" data-toggle="collapse" href="#collapse-0-0" title="Click to expand">' +
                            '<div class="row">' +
                            '<div class="col-md-1">' + email_icon + '</div>' +
                            '<div class="col-md-1">' +
                            '<span>' + data.name + '</span>' +
                            '</div>' +
                            '<div class="row col-md-8">' +
                            '<div class="col-md-4">' +
                            '<span></span>' +
                            '</div>' +
                            '<div class="col-md-7">' +
                            '<span class="subject">' + message.subject + '</span>' +
                            '<span class="text-gray"> - ' + message.body.substring(0, 40) + '</span>' +
                            '</div>' +
                            '</div>' +
                            '<div class="col-md-2">' +
                            '<i class="icon-"></i>' +
                            '<span>' + log_date + '</span>' +
                            '</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="panel-collapse collapse" id="collapse-0-0">' +
                            '<div class="panel-body body-warp-message">' +
                            '<div class="body-message col-md-8 col-md-offset-2 p13">'+ message.body +'</div>' +
                            '</div>' +
                            '</div>' +
                            '</div>' +
                            '').fadeIn();
                        $('[data-message="' + message.id + '"]').hide().fadeIn("slow");

                    });

                    // update current_stage
                    $("#current_stage").val(data.current_stage);

                    // update stage text
                    var stage_name = data.current_stage_name;
                    $("#cStage").hide().text(stage_name).fadeIn("slow");
                    $(".cStage2").text(stage_name);
                    if (stage_name != "Lead" && stage_name != "Book" && stage_name != "Complete") {
                        if (data.current_stage_num == 0) {
                            $("#cStage0").text("Lead  - ");
                        } else if (data.current_stage_num == 1) {
                            $("#cStage0").text("Book  - ");
                        } else if (data.current_stage_num == 2) {
                            $("#cStage0").text("Complete - ");
                        }
                    }

                    $(".select-contact-stage").removeClass("underline");
                    $(".select-primary-stage").removeClass("underline");


                    // make stage green bold
                    if ($("#is_job_finished").val() != "true") {
                        $(".select-contact-stage[contact_stage_id='" + data.current_stage + "']").addClass("green bold caps").removeClass("disable").addClass("enable");
                        $('.stage-icon[contact_stage_id="' + data.current_stage + '"]').addClass("icon-green").removeClass("icon-red");
                        if (primary_stage_update) {
                            $(".select-primary-stage[contact_stage_id='" + data.current_stage + "']").addClass("green bold caps").attr("style", "color: green !important");
                            $("#current_stage_num").val(data.current_stage_num);
                        }
                    }

                    if (delete_contact_stage === true) {
                        $('.select-contact-stage[contact_stage_id="' + data.current_stage + '"]').trigger('click', [true]).addClass("no_underline").tooltip('hide');
                        $('.select-contact-stage[contact_stage_id="' + contact_stage_id + '"]').removeClass('green bold caps active-stage enable').addClass('disable').attr("title", "Preview").attr("data-original-title", "Preview");
                        $('.stage-icon[contact_stage_id="' + contact_stage_id + '"]').addClass("icon-red").removeClass("icon-green");
                        // hide emails
                        //$(".sub_stage_emails").hide();
                        //$(".sliding_emails").hide();
                    }

                    if (data.current_stage_name == "Unable" || data.current_stage_name == "Cancel" || data.current_stage_name == "Post") {
                        if ($("#is_job_finished").val() != "true") {
                            $('.select-contact-stage[contact_stage_id="' + contact_stage_id + '"]').removeClass('green').addClass('bright_red underline');
                            $("#is_job_finished").val("true");
                            $("#job_status").html("(Job Finished)");
                        }
                    }

                    // update truck icon color
                    static_link_css_class(data.current_stage, data.current_stage_name);

                }
            }
        })
        .fail(function (data) {
            $.jGrowl(data.responseJSON.status || "A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl', life: 3000});
        })
}

function active_move_record(current_user) {
    var move_record = new RegExp('move_records/([^d]*)/').exec(window.location.href);
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

function static_link_css_class(contact_stage_id, stage_name) {
    if (/move_records\/([^d]*)\/edit/.test(self.location.href)) {
        var css_class;

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
        //if not recieved, not confirmed, not dispatched: pink
    else if (!$('label[for="contact_stage_Receive"]').hasClass('green') && !$('label[for="contact_stage_Confirm"]').hasClass('green') && !$('label[for="contact_stage_Dispatch"]').hasClass('green')) {
            css_class = "contact_stage_special"
        }
        // booked, recieved, confirmed, dispatched: green
        else if ($('.jump-truck-calendar').hasClass("green") && $('label[for="contact_stage_Receive"]').hasClass('green') && $('label[for="contact_stage_Confirm"]').hasClass('green') && $('label[for="contact_stage_Dispatch"]').hasClass('green')) {
            css_class = "contact_stage_green"
        }
        else {
            css_class = "contact_stage_white"
        }

        var current_user = $('.user-name').data('user');
        var move_record = new RegExp('move_records/([^d]*)/').exec(window.location.href);
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
}

function number_move_record() {
    var move_record = new RegExp('move_records/([^d]*)/').exec(window.location.href);
    return move_record[1];
}

function is_move_record() {
    var move_record = new RegExp('move_records/([^d]*)/').exec(window.location.href);
    return move_record !== null ? true : false;
}

function update_move_record_form() {
    var new_move_record_form = $('.edit_move_record');
    $.ajax({
        url: new_move_record_form.attr('action'),
        type: 'PUT',
        data: new_move_record_form.serialize()
    }).done(function (data) {
        /*var d = new Date();
         $('.last-saved').html('<small class="pull-right">Last Saved: ' + d.toLocaleTimeString() + '</small>');*/
        //update menu, title record name and truck group
        $("a[href='" + window.location.pathname + "']").find("span").text(data.move_contract_name);
        $("#pTitle_text").text(data.move_contract_name);
        $(".who_text").text($(".rname").val());
        if (data.home_phone != "") {
            $("#client_home_phone").removeClass("hidden");
            $('#client_home_phone').attr('onclick', 'do_call(' + data.home_phone + ')');
        } else {
            $("#client_home_phone").addClass("hidden");
        }
        if (data.cell_phone != "") {
            $("#client_cell_phone").removeClass("hidden");
            $('#client_cell_phone').attr('onclick', 'do_call(' + data.cell_phone + ')');
        } else {
            $("#client_cell_phone").addClass("hidden");
        }
        if (data.work_phone != "") {
            $("#client_work_phone").removeClass("hidden");
            $('#client_work_phone').attr('onclick', 'do_call(' + data.work_phone + ')');
        } else {
            $("#client_work_phone").addClass("hidden");
        }

    }).fail(function (data) {
        $.jGrowl(data.responseJSON.status || "A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
    });
}

function submit_new_move_record() {
    var new_move_record_form = $('.new_move_record');
}

function cargo_template(furnishing) {
    $('.cargo-description').autocomplete({
        source: "/cargo_template_information.json?furnishing=" + furnishing,
        minLength: 0,
        select: function (event, ui) {
            var row_cargo_template = $(this).closest('.cargo_template');
            row_cargo_template.find('.volume').val(ui.item.extra_data.unit_volume);
            row_cargo_template.find('.weight').val(ui.item.extra_data.unit_weight);
            calc_cargo();
        }
    });
}

function calc_cargo() {
    var total_volume = 0, total_weight = 0, temp_quantity = 0, temp_volume = 0, temp_weight = 0;

    $('.cargo-template-table tbody tr').each(function () {
        temp_quantity = parseFloat($(this).find('.quantity').val()) ? parseFloat($(this).find('.quantity').val()) : 0;
        temp_volume = parseFloat($(this).find('.volume').val()) ? parseFloat($(this).find('.volume').val()) : 0;
        temp_weight = parseFloat($(this).find('.weight').val()) ? parseFloat($(this).find('.weight').val()) : 0;
        total_volume += (temp_quantity * temp_volume);
        total_weight += (temp_quantity * temp_weight);
    });
    $('.calc-volume').text(total_volume);
    $('.calc-volume-weight').text(total_volume * 7);
    $('.calc-weight').text(total_weight);

}

function calculateCommission() {
    var commission_percentage = 0,
        total_cost_move_commission = 0,
        calculation_commission = 0,
        calculation_percentage = 0,
        total_company_commission_percentage = 0;
    $('.calculate-commission').each(function () {
        var subtotal_calculate_commission = 0;
        $(this).find('div').each(function () {
            var input_percentage = $(this).find('input:first');
            commission_percentage = input_percentage.val();
            total_cost_move_commission = $('.' + input_percentage.data('cost')).val();
            calculation_commission = calculatePercent(parseFloat(commission_percentage), parseFloat(total_cost_move_commission));
            calculation_commission = Math.round(parseFloat(calculation_commission), 2);
            $(this).find('.subtotal-comission label').text(calculation_commission);
            $(this).find('input:last').val(calculation_commission);
        });
        $(this).find('.subtotal-comission label').each(function () {
            subtotal_calculate_commission += parseFloat($(this).text()) ? parseFloat($(this).text()) : 0;
        });
        $(this).find('.total-commission').html('$<label>' + Math.round(subtotal_calculate_commission, 2) + '</label>');
        $(this).find('input:last').val(Math.round(subtotal_calculate_commission, 2));
    });
    var total_percentage_company = 0,
        total_commission_money = 0;
    $(".company-commission div.calc-company-commission").each(function () {
        calculation_commission = 0;
        calculation_percentage = 0;
        total_cost_move_commission = 0;

        $("[data-cost='" + $(this).data('percentage-commission') + "']").each(function () {
            calculation_percentage += parseFloat($(this).val()) ? parseFloat($(this).val()) : 0;
        });
        total_company_commission_percentage = 100 - (parseFloat(calculation_percentage) ? parseFloat(calculation_percentage) : 0 );
        $(this).find('label:first').text(total_company_commission_percentage + '%');
        $(this).find('input:first').val(total_company_commission_percentage);

        total_cost_move_commission = parseFloat($('.' + $(this).data('percentage-commission')).val()) ? parseFloat($('.' + $(this).data('percentage-commission')).val()) : 0;
        calculation_commission = calculatePercent(total_company_commission_percentage, total_cost_move_commission);
        $(this).find('label:last').text('$' + calculation_commission);
        $(this).find('input:last').val(calculation_commission);
        total_percentage_company += total_company_commission_percentage;
        total_commission_money += calculation_commission;
    });
    total_percentage_company = Math.round((total_percentage_company / 6), 2);
    $(".total_company_percentage").val(total_percentage_company);
    $(".company-commission div:last label:first").text(total_percentage_company + '%');
    $(".total_company").val(Math.round(total_commission_money, 2));
    $(".company-commission div:last label:last").text('$' + Math.round(total_commission_money, 2));
}

function addDateTimePicker() {
    $('.date-mover').datetimepicker({format: 'DD/MM/YYYY'});
    $('.time-mover').datetimepicker({format: 'hh:mm A'});
    $('.datetime-mover').datetimepicker({format: 'DD/MM/YYYY hh:mm A'});
    $('.date-pick').datetimepicker({format: 'YYYY/MM/DD'});
}

function wrapCalculates() {
    var diff = calcDiffHour($('.cost_hourly_start').val(), $('.cost_hourly_stop').val());
    $('.cost_hourly_hours').val(diff);
    var diff = calcCostHourly($('.cost_hourly_hours').val(), $('.cost_hourly_breaks').val(), $('.cost_hourly_travel').val());
    $('.cost_hourly_estimate_time').val(diff);
    $('.est_time').val(diff);
    //var flat_rate_hourly_rate = (parseFloat($('.flat_rate').val()) || 0) + (parseFloat($('.cost_hourly_hourly_rate').val()) || 0);
    var diff = calcActualMoveHours($('.cost_hourly_estimate_time').val(), $('.cost_hourly_hourly_rate').val());
    $('.cost_hourly_move_cost').val(diff + (parseFloat($('.flat_rate').val()) || 0));
}

function calcDiffHour(time_start, time_stop) {
    var a = new Date("February 01, 2015 " + time_start);
    var b = new Date("February 01, 2015 " + time_stop);
    var result = ((b - a) / (1000 * 60));
    if (!result || result < 0) {
        return "0";
    }
    if (result >= 60) {
        if (Math.floor((((result / 60) - Math.floor(result / 60)) * 60 )) > 10) {
            return Math.floor(result / 60) + '.' + Math.floor((((result / 60) - Math.floor(result / 60)) * 60 ));
        }
        return Math.floor(result / 60) + '.' + '0' + Math.floor((((result / 60) - Math.floor(result / 60)) * 60 ));
    } else {
        if (Math.floor(result) >= 10) {
            return '0.' + Math.floor(result);
        }
        return '0.0' + Math.floor(result);
    }
    return 0;
}

function calcCostHourly(totalHours, breaks, travel) {
    var result = parseFloat(totalHours) - parseFloat(breaks) + parseFloat(travel);
    if (!result) {
        return "0";
    }
    return result;
}

function calcActualMoveHours(actual, rate) {
    var result = parseFloat(actual) * parseFloat(rate);
    if (!result) {
        return "0";
    }
    return result;
}

function calculatePacking(total, inputPacking) {
    var result = parseFloat(total) + ( parseFloat(inputPacking) ? parseFloat(inputPacking) : 0 );
    if (!result) {
        return "0";
    }
    return result;
}

var round = Math.round;
Math.round = function (value, decimals) {
    decimals = decimals || 0;
    return Number(round(value + 'e' + decimals) + 'e-' + decimals);
}

function calcInsurance() {
    var declared_value = parseFloat($('.insurance_declared_value').val()) ? parseFloat($('.insurance_declared_value').val()) : 0;
    var k = parseFloat($('.insurance_dolar_k').val()) ? parseFloat($('.insurance_dolar_k').val()) : 0;
    var result = (declared_value / (k * 1000) );
    $('.insurance_insurance_cost').val(Math.round(result, 2) ? Math.round(result, 2) : 0);
}

function calculateTaxCost(subtotal, gst_tax_amount, pst_tax_amount) {
    var calculate_percent_gst_other_cost = $('.other_cost_gst').is(':checked') ? calculatePercent($('#other_cost_percentage_gst').val(), $('.other_cost_other_cost').val()) : 0;
    var calculate_percent_gst_surchage = $('.surcharge_gst').is(':checked') ? calculatePercent($('#surcharge_percentage_gst').val(), $('.surcharge_surcharge').val()) : 0;
    var total_gst_amount = (gst_tax_amount + calculate_percent_gst_other_cost + calculate_percent_gst_surchage)
    $('.move_record_gst_hst').val(Math.round(( total_gst_amount ), 2));

    var calculate_percent_pst_other_cost = $('.other_cost_pst').is(':checked') && ($('.province-tax:first').find(":selected").data('charge-province-vendor') === true) ? calculatePercent($('#other_cost_percentage_pst').val(), $('.other_cost_other_cost').val()) : 0;
    var calculate_percent_pst_surchage = $('.surcharge_pst').is(':checked') && ($('.province-tax:first').find(":selected").data('charge-province-vendor') === true) ? calculatePercent($('#surcharge_percentage_pst').val(), $('.surcharge_surcharge').val()) : 0;
    var total_pst_amount = (pst_tax_amount + calculate_percent_pst_other_cost + calculate_percent_pst_surchage)
    $('.move_record_pst').val(Math.round((total_pst_amount), 2));

    var other_cost = parseFloat($('.other_cost_other_cost').val()) ? parseFloat($('.other_cost_other_cost').val()) : 0;
    var surcharge_cost = parseFloat($('.surcharge_surcharge').val()) ? parseFloat($('.surcharge_surcharge').val()) : 0;

    $('#move_record_subtotal').val(Math.round(subtotal + other_cost + surcharge_cost, 2));
}

function calculatePercent(percentage, amount) {
    var parse_amount = parseFloat(amount) ? parseFloat(amount) : 0;
    var parse_percentage = parseFloat(percentage) ? parseFloat(percentage) : 0;
    return ((parse_amount * parse_percentage) / 100 );
}

function calculateHourlyDiscount() {
    var hourly = parseFloat($('.discount_hourly').val()) ? parseFloat($('.discount_hourly').val()) : 0;
    var actual = parseFloat($('.cost_hourly_actual').val()) ? parseFloat($('.cost_hourly_actual').val()) : 0;
    var discount_hourly = hourly * actual;
    $('.discount_discount').val(Math.round(discount_hourly, 2));
}

function calculatePercentDiscount() {
    var discount_percentage = calculatePercent($('.discount_percentage').val(), calcOperationSubTotal());
    $('.discount_discount').val(Math.round(discount_percentage, 2));
}

function calculateFixedFuel() {
    var fixed_fuel_cost = $('.fuel_cost_fixed').val() ? $('.fuel_cost_fixed').val() : 0;
    $('.fuel_cost_fuel_cost').val(Math.round(fixed_fuel_cost, 2));
}

function calculatePercentFuel() {
    var actual_fuel_cost = $('.fuel_cost_fuel_cost').val() ? $('.fuel_cost_fuel_cost').val() : 0;
    var fuel_percentage = calculatePercent($('.fuel_cost_percentage_mc').val(), (calcOperationSubTotal() - actual_fuel_cost));
    $('.fuel_cost_fuel_cost').val(Math.round(fuel_percentage, 2));
}

function calculateSubTotalMove() {
    var result = calcOperationSubTotal();
    var discount = parseFloat($('.discount_discount').val()) ? parseFloat($('.discount_discount').val()) : 0;
    var subtotal = (result - discount);

    var province_tax = $('.province-tax:first').find(":selected").data('tax-gst');
    var gst_tax = parseFloat(province_tax) ? parseFloat(province_tax) : 0;
    var gst_tax_amount = ((subtotal * gst_tax) / 100);

    var province_pst_tax = $('.province-tax:first').find(":selected").data('charge-province-vendor') === true ? $('.province-tax:first').find(":selected").data('tax-pst') : 0;
    var pst_tax_amount = ((subtotal * province_pst_tax) / 100);

    $('.move_record_gst_hst').val(Math.round(gst_tax_amount, 2));
    $('.move_record_pst').val(Math.round(pst_tax_amount, 2))
    $('#move_record_subtotal').val(Math.round((subtotal), 2));
    calculateTaxCost(subtotal, gst_tax_amount, pst_tax_amount, pst_tax_amount);
}

function calcOperationSubTotal() {
    var result = 0;
    $('.calculateTotal').not('.discount, .other_cost_other_cost,.surcharge_surcharge ').each(function () {
        result += parseFloat($(this).val()) ? parseFloat($(this).val()) : 0;
    });
    return result;
}

function calcTotalMove() {
    var result = 0;
    $('.calcTotalMove').each(function () {
        result += parseFloat($(this).val()) ? parseFloat($(this).val()) : 0;
    });
    result += parseFloat($('#move_record_subtotal').val()) ? parseFloat($('#move_record_subtotal').val()) : 0;
    $('#move_record_total_cost').val(Math.round(result, 2));
}

function calcBalance() {
    var total_cost_move = parseFloat($('#move_record_total_cost').val()) ? parseFloat($('#move_record_total_cost').val()) : 0;
    var deposit = parseFloat($('#move_record_deposit').val()) ? parseFloat($('#move_record_deposit').val()) : 0;
    var payment = parseFloat($('#move_record_payment').val()) ? parseFloat($('#move_record_payment').val()) : 0;
    $('#move_record_balance_due').val(Math.round((total_cost_move - ( deposit + payment ) ), 2));
}

function wrapCalculationsCost(trigged) {
    calcInsurance();
    $('.calculateFuel').trigger('click');
    $('.calculateDiscount').trigger('click');
    calculateSubTotalMove();
    calcTotalMove();
    calcBalance();
    calculateCommission();
}

function showLabel(elem) {
    var el = document.getElementById(elem);
    if(el) {
        el.style.visibility = 'visible';
    }
}

function updateAlerts(src, target) {
    $("#" + target).text($("#" + src).val());
}

// add-up truck group cities, locale
function append_city_locale_by_truck_group() {

    $(".move-truck-calendar").each(function (i, obj) {
        $(obj).addClass("form-control2").removeClass("text-grey");
        var truck_group_id = $(obj).val();
        var group_index = $(obj).attr("data_origin_index");
        var group_id = $(obj).attr("id").replace("calendar_truck_group_id", "");
        var curr_province = $("#" + group_id + "province option:selected");
        var curr_province_destination = $("[data_destination_province_index=" + group_index + "] option:selected");

        // Province
        if (truck_group_id != "") {
            $.get("/get_province_by_truck_group",
                {
                    "calendar_truck_group_id": truck_group_id
                },
                function (data) {
                    if (data) {
                        // City
                        get_city_by_truck_group(data.truck_province_id, truck_group_id, true, group_id, group_index);
                        $("#" + group_id + "province").addClass("form-control2").removeClass("text-grey");
                        $("[data_destination_province_index=" + group_index + "]").addClass("form-control2").removeClass("text-grey");

                        // Province
                        $.each(data.provinces, function (i, item) {
                            var html = '<option data-id="' + item.id + '" value="' + item.description + '" ';
                            html += '>' + item.description + '</option>';

                            if (curr_province.val() != item.description) {
                                $("#" + group_id + "province").append(html);
                            }
                            else {
                                curr_province.attr("data-id", item.id);
                            }

                            if (curr_province_destination.val() != item.description) {
                                $("[data_destination_province_index=" + group_index + "]").append(html);
                            }
                            else {
                                curr_province_destination.attr("data-id", item.id);
                            }

                            $("#" + group_id + "province").addClass("form-control2").removeClass("text-grey");
                            $("[data_destination_province_index=" + group_index + "]").addClass("form-control2").removeClass("text-grey");
                        });
                    }
                }, "json");
        }
    });
}

// update truck group province, city, locale
function update_prov_city_locale_by_truck_group(event) {
    event = event || window.event;
    var elem = event.target || event.srcElement;
    var group_id = $(elem).attr("id").replace("calendar_truck_group_id", "");
    var group_index = $(elem).attr("data_origin_index");
    var truck_group_id = $("#" + group_id + "calendar_truck_group_id option:selected").val();
    var curr_province = $("#" + group_id + "province option:selected");
    var curr_province_destination = $("[data_destination_province_index=" + group_index + "] option:selected");

    $("#" + group_id + "calendar_truck_group_id").addClass("form-control2").removeClass("text-grey");

    // Province
    if (truck_group_id != "") {
        $.get("/get_province_by_truck_group",
            {
                "calendar_truck_group_id": truck_group_id
            },
            function (data) {
                $("#" + group_id + "province").empty();
                $("#" + group_id + "province").append("<option></option>");
                $("[data_destination_province_index=" + group_index + "]").empty();
                $("[data_destination_province_index=" + group_index + "]").append("<option></option>");
                $("#" + group_id + "city").empty();
                $("#" + group_id + "city").append("<option></option>");
                $("[data_destination_city_index=" + group_index + "]").empty();
                $("[data_destination_city_index=" + group_index + "]").append("<option></option>");
                $("#" + group_id + "locale").empty();
                $("#" + group_id + "locale").append("<option></option>");
                $("[data_destination_locale_index=" + group_index + "]").empty();
                $("[data_destination_locale_index=" + group_index + "]").append("<option></option>");
                if (data) {
                    $.each(data.provinces, function (i, item) {
                        var html = '<option data-id="' + item.id + '" value="' + item.description + '" ';
                        if (data.truck_province_id == item.id) {
                            html += 'selected';
                            // City
                            get_city_by_truck_group(data.truck_province_id, truck_group_id, false, group_id, group_index);
                        }
                        html += '>' + item.description + '</option>';

                        //if (curr_province.val() != item.description) {
                        $("#" + group_id + "province").append(html);
                        //}
                        //else {
                        //    curr_province.attr("data-id", item.id);
                        //}

                        //if (curr_province_destination.val() != item.description) {
                        $("[data_destination_province_index=" + group_index + "]").append(html);
                        //}
                        //else {
                        //    curr_province_destination.attr("data-id", item.id);
                        //}

                        $("#" + group_id + "province").addClass("form-control2").removeClass("text-grey");
                        $("[data_destination_province_index=" + group_index + "]").addClass("form-control2").removeClass("text-grey");
                    });
                }
            }, "json");
    }
}

function get_city_by_truck_group(province_id, truck_group_id, no_select, group_id, group_index) {
    var curr_city = $("#" + group_id + "city option:selected");
    var curr_city_destination = $("[data_destination_city_index=" + group_index + "] option:selected");

    $.get("/get_city_by_province_and_truck_group",
        {
            "province_id": province_id,
            "calendar_truck_group_id": truck_group_id
        },
        function (data) {
            if (data) {
                $.each(data.cities, function (i, item) {
                    var html = '<option data-id="' + item.id + '" value="' + item.description + '" ';
                    if (data.truck_city_id == item.id) {
                        if (!no_select) html += 'selected';
                        // Locale
                        get_locale_by_truck_group(item.id, truck_group_id, no_select, group_id, group_index)
                    }
                    html += '>' + item.description + '</option>';

                    if (curr_city.val() != item.description) {
                        $("#" + group_id + "city").append(html);
                    }
                    else {
                        curr_city.attr("data-id", item.id);
                    }

                    if (curr_city_destination.val() != item.description) {
                        $("[data_destination_city_index=" + group_index + "]").append(html);
                    }
                    else {
                        curr_city_destination.attr("data-id", item.id);
                    }

                    $("#" + group_id + "city").addClass("form-control2").removeClass("text-grey");
                    $("[data_destination_city_index=" + group_index + "]").addClass("form-control2").removeClass("text-grey");
                });
            }
        }, "json");
}

function get_locale_by_truck_group(city_id, truck_group_id, no_select, group_id, group_index) {
    var curr_locale = $("#" + group_id + "locale option:selected").val();
    var curr_locale_destination = $("[data_destination_locale_index=" + group_index + "] option:selected").val();

    $.get("/get_locale_by_city_and_truck_group",
        {
            "city_id": city_id,
            "calendar_truck_group_id": truck_group_id
        },
        function (data) {
            if (data) {
                $.each(data.locales, function (i, item) {
                    var html = '<option value="' + item.locale_name + '" ';
                    if (data.locale_id == item.id) {
                        if (!no_select) html += 'selected';
                    }
                    html += '>' + item.locale_name + '</option>';

                    if (curr_locale != item.locale_name) {
                        $("#" + group_id + "locale").append(html);
                    }

                    if (curr_locale_destination != item.locale_name) {
                        $("[data_destination_locale_index=" + group_index + "]").append(html);
                    }

                    $("#" + group_id + "locale").addClass("form-control2").removeClass("text-grey");
                    $("[data_destination_locale_index=" + group_index + "]").addClass("form-control2").removeClass("text-grey");
                });
            }
        }, "json");
}

function val2key(val, array) {
    for (var key in array) {
        var this_val = array[key];
        if (this_val == val) {
            return key;
            break;
        }
    }
}

function do_email() {
    $("#msg_form").fadeIn("slow");
    $("#call_form").hide();
    //$("#icon_phone").removeClass("textOrange");
    //$("#icon_email_client").addClass("textOrange");
    $("#email_users").val($("#email_users option:first").val());
    $("#email_users").trigger("chosen:updated");
}

function do_call(custom_phone) {
    $("#msg_form").hide();
    $("#call_form").fadeIn("slow");
    $("#call_btn").show();
    //$("#icon_phone").addClass("textOrange");
    //$("#icon_email_client").removeClass("textOrange");
    if (custom_phone) {
        setTimeout(function () {
            start_call(custom_phone);
        }, 1000);
    }
}

function get_first_phone() {
    var phone;
    if ($(".work_phone").val() != "") {
        phone = $(".work_phone").val();
    }
    if ($(".cell_phone").val() != "") {
        phone = $(".cell_phone").val();
    }
    if ($(".home_phone").val() != "") {
        phone = $(".home_phone").val();
    }
    return phone;
}

function start_call(custom_phone) {
    if (custom_phone != undefined || get_first_phone() != undefined) {
        $("#call_btn").hide();
        $("#call_started").val("1");
        call_start_btn_clicked = true;

        if (custom_phone) {
            location.href = "tel:" + custom_phone;
        }
        else {
            location.href = "tel:" + get_first_phone();
        }
    }
    else {
        $.jGrowl("There is no phone specified. Enter a phone first and try again.", {
            header: 'Required',
            theme: 'error-jGrowl'
        });
    }
}

function append_messages_log(data) {
    // Append messages log
    if (data.message != null) {

        var created_date = new Date(data.message.created_at.replace("T", " ").replace("Z", ""));
        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var log_date = created_date.toLocaleTimeString().replace(/:\d+ /, ' ').toLowerCase() + ' ' + monthNames[created_date.getMonth()] + ' ' + created_date.getDate();
        var email_icon = '<i class="fa fa-envelope" aria-hidden="true"></i>';

        $(".full-wrap-messages-move-record").hide().prepend('' +
            '<div class="panel panel-default wrap-full-message no-m-bottom" data-message="' + data.message.id + '">' +
            '<div class="panel-heading accordion-toggle collapsed" data-parent="#accordion0" data-toggle="collapse" href="#collapse-0-0" title="Click to expand">' +
            '<div class="row">' +
            '<div class="col-md-1">' + email_icon +'</div>' +
            '<div class="col-md-1">' +
            '<span>' + data.name + '</span>' +
            '</div>' +
            '<div class="row col-md-8">' +
            '<div class="col-md-4">' +
            '<span></span>' +
            '</div>' +
            '<div class="col-md-7">' +
            '<span class="subject">' + data.message.subject + '</span>' +
            '<span class="text-gray"> - ' + data.message.body.substring(0, 40) + '</span>' +
            '</div>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<i class="icon-"></i>' +
            '<span>' + log_date + '</span>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="panel-collapse collapse" id="collapse-0-0">' +
            '<div class="panel-body body-warp-message">' +
            '<div class="body-message col-md-8 col-md-offset-2 p13">' + data.message.body + '</div>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '').fadeIn();
        $('[data-message="' + data.message.id + '"]').hide().fadeIn("slow");

    }
}

function scroll_to_contact(){
    $("html,body").scrollTop(475);
    $("html,body").scrollTop($("[id='SScontact']").offset().top - 134);
}

function activate_active_fields(){
    // activate fields with values
    $($('form.edit_move_record').prop('elements')).each(function(){
        if($(this).val() != "" && $(this).attr("onfocus") && !$(this).hasClass("form-control2")) {
            $(this).addClass("form-control2").removeClass("text-grey");
            if ($(this).attr("onfocus") != "") {
                eval($(this).attr("onfocus"));
            }
        }
    });
}