$(document).ready(function(){
    $('#reff_btn').on('click', function(){
            if($('#name').val() == "") {
                $('#name_error').fadeIn().removeClass('hidden');
                return false;
            }
            else if(($('#phone_number').val() == "" && $('#email').val() == "")){
                $('#phone_email_error').fadeIn().removeClass('hidden');
                return false;
            }
            else if(!validateEmail($('#referral_agent_email1').val()) || $('#referral_agent_email1').val() == $('#email').val()){
                $('#referral_agent_email_error').fadeIn().removeClass('hidden');
                return false;
            }
            else {
                //return true;
                $('#ref_quote').submit();
            }
    });
});

function copy_link(elementId, ra){
    if (ra == "") {
        alert("Enter Your email in Referral Agent Email First!");
        $("#referral_agent_email1").focus();
        $("#referral_agent_email2").focus();
    }
    else {
        var aux = document.createElement("input");

        aux.setAttribute("value", document.getElementById(elementId).innerHTML + ra);
        document.body.appendChild(aux);
        aux.select();
        document.execCommand("copy");
        document.body.removeChild(aux);

        alert("Link has been copied!");
    }
}

function get_ra(ra){
    if (ra == "") {
        alert("Enter Your email in Referral Agent Email First!");
        $("#referral_agent_email1").focus();
        $("#referral_agent_email2").focus();
    }
    else {
        $("input[name='ra_email']").val(ra);
    }
    return false;
}

function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}