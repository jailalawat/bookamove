$(document).ready(function () {

    $("#save_sub_stage").on("click", function () {
        $('#add_sub_stage_modal').modal('hide');

        $.post("/contact_stages",
            {
                "stage_num": $("#add_stage_num").val(),
                "sub_stage_name": $("#add_sub_stage_name").val()
            },
            function (data) {
                //var stage_name = "";
                //if (parseInt(data.stage_num) == 0) { stage_name = "Lead"; }
                //else if (parseInt(data.stage_num) == 1) { stage_name = "Book"; }
                //else { stage_name = "Complete"; }

                //$(".stage"+ data.stage_num +"_substages").append('<div class="mbottom15 mtop15 border_bottom subs'+ data.stage_num +'" id="sub_stage'+ data.id +'" data-id="'+ data.id +'"><i class="activate_sub_stage mright1 fa  fa-check-circle icon-green" data-id="'+ data.id +'"></i> <span class="sub_stage_name caps">'+ data.sub_stage +'</span><div class="pull-right"><a href="javascript:void(0)" style="cursor: move"><i class="fa fa-bars small" aria-hidden="true"></i></a> | <a href="javascript:void(0)" onclick="$(\'#update_sub_stage_modal\').modal(\'show\');$(\'#edit_sub_stage_name\').val(\''+ data.sub_stage +'\');$(\'#edit_id\').val(\''+ data.id +'\');$(\'#edit_stage_num\').val('+ data.stage_num +')"><i class="fa fa-pencil small" aria-hidden="true"></i></a> | <a href="/contact_stages/'+ data.id +'" data-confirm="Are you sure?" data-remote="true" data-method="delete"><i class="fa fa-trash small" aria-hidden="true"></i></a> | <span class="small"><a href="javascript:void(0)" onclick="assign_emails_to_stages('+ data.stage_num +',[]);$(\'#attach_stage_id\').val(\''+ data.id +'\');$(\'#attach_stage_name\').html(\''+ stage_name +'\')"><i class="icon-edit-sign big font_grey"></i></a></span></div><div class="mtop10"><div id="email_alerts'+ data.id +'" class="email_alerts_section"><div class="mtop10 mbottom15 pleft20"></div></div></div> <div class="clearfix"></div></div>');

                //clear form
                //$("#add_sub_stage_name").val("");
                location.reload();
            }, "json");
    });

    $("#update_sub_stage").on("click", function () {
        $('#update_sub_stage_modal').modal('hide');

        $.ajax({
            url: "/contact_stages/"+ $("#edit_id").val(),
            method: "PUT",
            data: {
                "stage_num": $("#edit_stage_num").val(),
                "sub_stage_name": $("#edit_sub_stage_name").val()
            },
            success: function(data) {

                //$("#sub_stage"+ data[0].id).find(".sub_stage_name").html(data[0].sub_stage);

                //clear form
                //$("#edit_sub_stage_name").val("");
                location.reload();
            }
        }, "json");
    });


    // rearrange sortable
    $(".stage0_substages").sortable({
        cancel: ".rearange-disabled",
        update: function(event, ui) { update_positions(0); }
    });
    $(".stage0_substages, .subs0").disableSelection();


    $(".stage1_substages").sortable({
        cancel: ".rearange-disabled",
        update: function(event, ui) { update_positions(1); }
    });
    $(".stage1_substages, .subs1").disableSelection();


    $(".stage2_substages").sortable({
        cancel: ".rearange-disabled",
        update: function(event, ui) { update_positions(2); }
    });
    $(".stage2_substages, .subs2").disableSelection();


    // enable or disable sub_stage
    $(".contract-settings").on("click", ".activate_sub_stage", function(){
        var enabled = $(this).hasClass("icon-green");
        var id = $(this).data("id");
        var _this = $(this);

        if (enabled) {
            // enable
            $.post("/update_substage_enables", { "id": id, "active": 0 },
                function (data) {
                    $(_this).removeClass("fa-check-circle").removeClass("icon-green");
                    $(_this).addClass("fa-times").addClass("icon-red");
                    if (data.sub_stage == "Dispatch"){ location.reload(); }
                }, "json");
        }
        else {
            // disable
            $.post("/update_substage_enables", { "id": id, "active": 1 },
                function (data) {
                    $(_this).removeClass("fa-times").removeClass("icon-red");
                    $(_this).addClass("fa-check-circle").addClass("icon-green");
                    if (data.sub_stage == "Dispatch"){ location.reload(); }
                }, "json");
        }
    });

    //update stage email
    $("#attach_stage_emails").on("click", function () {
        $('#attach_emails_modal').modal('hide');
        id = $("#attach_stage_id").val();

        var emails = [];
        $(".stage_emails_check2").each(function() {
            if($(this).is(':checked')) {
                emails.push($(this).data("id"));
            }
        });

        $.post("/stages_attach_emails",
            {
                "id": id,
                "emails": emails
            },
            function (data) {
                //if (location.href.replace(location.origin, "") == "/contract_settings?stage_id="+ $("#attach_stage_id").val() +"#stages"){
                    location.reload();
                //}
                //else {
                //    location.href = "/contract_settings?stage_id="+ id +"#stages";
                //}
            }, "json");

    });

    // expand all emails
    $(".expand-all-email-alerts").on("click", function(){
        var is_state_down = ($(this).data("state") == "down");

        if (is_state_down){
            $(this).hide().html('<img src="/assets/arrow_up.png" width="12">').fadeIn();
            $(this).data("state", "up");
            $(this).attr("data-original-title", "Collapse All Emails");
            $(".email_alerts_section").slideDown("fast");
        }
        else {
            $(this).hide().html('<img src="/assets/arrow_down.png" width="12">').fadeIn();
            $(this).data("state", "down");
            $(this).attr("data-original-title", "Expand All Emails");
            $(".email_alerts_section").slideUp("fast");
        }
    })

    // autosend email
    $(".contract-settings").on("click", ".autosend_sub_stage_email", function(){
        var enabled = ($(this).data("state") == "auto_send");
        var id = $(this).data("id");
        var _this = $(this);

        if (enabled) {
            $.post("/update_email_alert_autosend", { "id": id, "auto_send": 0 },
                function (data) {
                    $(_this).attr("src","/assets/auto-send-empty.png");
                    $(_this).data("state", "empty");
                }, "json");
        }
        else {
            $.post("/update_email_alert_autosend", { "id": id, "auto_send": 1 },
                function (data) {
                    $(_this).attr("src","/assets/auto-send-with-box.png");
                    $(_this).data("state", "auto_send");
                }, "json");
        }
    })

    // enable/disable email
    $(".contract-settings").on("click", ".stage_emails_check1", function(){
        var enabled = $(this).hasClass("icon-green");
        var id = $(this).data("id");

        if (enabled){
            $(".stage_emails_check1[data-id='"+ id +"']").removeClass("fa-check-circle icon-green").addClass("fa-times icon-red");
            $(".stage_emails_check2[data-id='"+ id +"']").prop( "checked", false );
        }
        else {
            $(".stage_emails_check1[data-id='"+ id +"']").removeClass("fa-times icon-red").addClass("fa-check-circle icon-green");
            $(".stage_emails_check2[data-id='"+ id +"']").prop( "checked", true );
        }
    })

});

function update_positions(sub_num){
    var subs = [];

    $(".subs"+ sub_num).each(function(){
        var id = $(this).data("id");
        subs.push(id);
    });

    $.post("/update_substage_positions",
        {
            "subs": subs
        },
        function (data) {
            console.log(subs);
        }, "json");
}

function assign_emails_to_stages(stage_num, emails){
    $(".email_alert_row").hide();
    $(".email_alert_stage_num_"+ stage_num).show();
    $(".stage_emails_check1").removeClass("fa-check-circle icon-green").addClass("fa-times icon-red");
    $(".stage_emails_check2").prop( "checked", false );
    $(".autosend_sub_stage_email").attr("src", "/assets/auto-send-empty.png");
    $(".autosend_sub_stage_email").data("state", "empty");

    $.each(emails, function( index, value ) {
        $(".stage_emails_check1[data-id='"+ value[0] +"']").removeClass("fa-times icon-red").addClass("fa-check-circle icon-green");
        $(".stage_emails_check2[data-id='"+ value[0] +"']").prop( "checked", true );
        if (value[1] == true) {
            $(".autosend_sub_stage_email[data-id='" + value[0] + "']").attr("src", "/assets/auto-send-with-box.png");
            $(".autosend_sub_stage_email[data-id='" + value[0] + "']").data("state", "auto_send");
        }
    });

    $('#attach_emails_modal').modal('show');
}

function edit_email(editable, id, stage_num, description, instructions, template) {
    $("#edit_email_alert_name").val(description);
    $("#edit_email_alert_id").val(id);
    $("#edit_email_alert_instructions").val(instructions);
    $('#edit_email_alert_template').data("wysihtml5").editor.setValue(template);

    if (editable) {
        $("#email_edit_mode").html("");
        $("#edit_email_alert_stage_num").attr("disabled", false);
        $("#edit_email_alert_name").attr("disabled", false);
        $("#edit_email_alert_instructions").attr("disabled", false);
        $('#edit_email_alert_template').attr("disabled", false);
        $('#edit_email_alert_template').data("wysihtml5").editor.enable();
        $('#edit_email_footer').show();
        $('#edit_email_delete_link').show();
        $('#edit_email_delete_link').attr("href", "/email_alerts/"+ id);
    }
    else {
        $("#email_edit_mode").html("(view only)");
        $("#edit_email_alert_stage_num").attr("disabled", true);
        $("#edit_email_alert_name").attr("disabled", true);
        $("#edit_email_alert_instructions").attr("disabled", true);
        $('#edit_email_alert_template').attr("disabled", true);
        $('#edit_email_alert_template').data("wysihtml5").editor.disable();
        $('#edit_email_footer').hide();
        $('#edit_email_delete_link').hide();
    }

    $('#edit_email_alert_modal').modal('show');
}