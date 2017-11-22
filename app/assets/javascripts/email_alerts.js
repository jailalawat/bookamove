$(document).ready(function () {

    $("#save_email_alert").on("click", function () {
        $('#add_email_alert_modal').modal('hide');

        $.post("/email_alerts",
            {
                "stage_num": $("#add_email_alert_stage_num").val(),
                "description": $("#add_email_alert_name").val(),
                "template": $("#email_alert_template").val(),
                "instructions": $("#add_email_alert_instructions").val()
            },
            function (data) {
                location.reload();

                // clear form
                //$("#add_email_alert_name").val("");
                //$("#email_alert_template").val("");
            }, "json");
    });

    $("#edit_email_alert").on("click", function () {
        $('#edit_email_alert_modal').modal('hide');

        $.ajax({
            url: "/email_alerts/"+ $("#edit_email_alert_id").val(),
            method: "PUT",
            data: {
                "id": $("#edit_email_alert_id").val(),
                "description": $("#edit_email_alert_name").val(),
                "template": $("#edit_email_alert_template").val(),
                "instructions": $("#edit_email_alert_instructions").val()
            },
            success: function(data) {
                location.reload();

                //$("#email_alert"+ data.id).html('<i class="activate_sub_stage_email fa fa-envelope '+ icon_is_active +' small"  data-id="'+ data.id +'"></i> <input type="checkbox" '+ is_autosend +' class="small pointer autosend_sub_stage_email" data-id="'+ data.id +'" style="height: 10px"> '+ data.description +' <div class="pull-right"><a href="javascript:void(0)" class="edit_email_alert" onclick="$(\'#edit_email_alert_modal\').modal(\'show\');$(\'#edit_email_alert_id\').val(\''+ data.id +'\');$(\'#edit_email_alert_name\').val(\''+  data.description +'\');set_editor(\''+ data.template +'\');$(\'iframe\').css(\'min-height\', \'90px\');"><i class="fa fa-pencil small" aria-hidden="true"></i></a> | <a href="/email_alerts/'+ data.id +'" data-confirm="Are you sure?" data-remote="true" data-method="delete"><i class="fa fa-trash small" aria-hidden="true"></i></a></div>');

                // clear form
                //$("#edit_email_alert_name").val("");
                //$("#edit_email_alert_template").val("");
            }
        }, "json");
    });

    // enable or disable
    $(".email-alerts").on("click", ".activate_sub_stage_email", function(){
        var enabled = $(this).hasClass("icon-green");
        var id = $(this).data("id");
        var _this = $(this);

        if (enabled) {
            $.post("/update_email_alert_enables", { "id": id, "active": 0 },
                function (data) {
                    $(_this).removeClass("fa-check-circle icon-green").addClass("fa-times icon-red");
                }, "json");
        }
        else {
            $.post("/update_email_alert_enables", { "id": id, "active": 1 },
                function (data) {
                    $(_this).removeClass("fa-times icon-red").addClass("fa-check-circle icon-green");
                }, "json");
        }
    })

    //$(".email-alerts").on("click", ".autosend_sub_stage_email", function(){
    //    var enabled = $(this).hasClass("icon-active-green-small");
    //    var id = $(this).data("id");
    //    var _this = $(this);
    //
    //    if (enabled) {
    //        $.post("/update_email_alert_autosend", { "id": id, "auto_send": 0 },
    //            function (data) {
    //                $(_this).removeClass("icon-active-green-small").addClass("icon-active-red-small");
    //            }, "json");
    //    }
    //    else {
    //        $.post("/update_email_alert_autosend", { "id": id, "auto_send": 1 },
    //            function (data) {
    //                $(_this).removeClass("icon-active-red-small").addClass("icon-active-green-small");
    //            }, "json");
    //    }
    //})

    // toggle email sections
    $(".contract-settings").on("click", ".email_alerts_toggle", function(){
        var section_id = $(this).data("section-id");
        var toggle_state = $(this).data("toggle-state");

        $("#email_alerts"+ section_id).slideToggle("fast");
        if (toggle_state == "down"){
            // $(this).html('Emails: <i class="fa fa-chevron-up small"></i>');
            // $(this).data("toggle-state", "up");
            $(this).data("toggle-state", "up").find("i").removeClass("fa-chevron-down").addClass("fa-chevron-up");
        }
        else{
            // $(this).html('Emails: <i class="fa fa-chevron-down small"></i>');
            // $(this).data("toggle-state", "down");
            $(this).data("toggle-state", "down").find("i").removeClass("fa-chevron-up").addClass("fa-chevron-down");
        }
    })

    // assign stages from check list
    $("#assign_stages_btn").on("click", function () {
        $('#assign_stages_modal').modal('hide');

        var stages = [];
        $(".stage_check").each(function() {
            if($(this).is(':checked')) {
                stages.push($(this).data("id"));
            }
        });

        $.post("/email_alerts_assign_stages",
            {
                "id": $("#email_id").val(),
                "stages": stages
            },
            function (data) {
                location.reload(true);
            }, "json");

    });

    // assign stages from edit form
    $('#btn_assign_email_stage').on('click', function (event) {
        event.preventDefault();
        var stage_id = $("#assign_stage").val();
        var email_id = $(this).data("email");
        if (stage_id) {
            $.ajax({
                url: '/email_alerts_assign_stage.json',
                type: 'POST',
                data: {
                    stage_id: stage_id,
                    email_id: email_id
                }
            }).done(function (data) {
                $("#assign_stage option[value='"+ stage_id +"']").hide(800);

                setTimeout(function() {
                    $("#no_emails").remove();

                    $("#email_stages_table").append('<tr bgcolor="white"><td class="caps">'+ data.stage +'</td><td><a href="/email_alerts_remove_stage?stage_id='+ data.stage_id +'&email_id='+ data.email_id +'">remove</a></td></tr>');
                    $("#email_stages_table tr:last").hide().slideToggle();
                }, 600);
            })
        }
    });

});

function assign_stages_popup(stages){
    $(".stage_check").prop( "checked", false );

    $.each(stages, function( index, value ) {
        $(".stage_check[data-id='"+ value +"']").prop( "checked", true );
    });

    $('#assign_stages_modal').modal('show');
}