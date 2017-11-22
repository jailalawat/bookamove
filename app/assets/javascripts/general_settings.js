$(document).ready(function () {
    $(".settings_change").on("input", function (e) {

        if ($(this).attr("data-type") == "calendar_range" && $(this).val() != "" && !isNormalInteger($(this).val())) {
            $.jGrowl("Number is required for value. Try again.", {header: 'Error', theme: 'error-jGrowl'});
            return false;
        }

        if ($(this).val() != "") {
            $.ajax({
                url: '/general_settings',
                type: 'patch',
                data: {
                    id: $(this).attr("data-id"),
                    value: $(this).val()
                }
            }).done(function (data) {
                $.jGrowl("Updated successfully.", {header: 'Success', theme: 'success-jGrowl'});
            }).fail(function (data) {
                $.jGrowl("A problem has occurred. Try again.", {header: 'Error', theme: 'error-jGrowl'});
            });
        }

    });

    function isNormalInteger(str) {
        return /^\+?(0|[1-9]\d*)$/.test(str);
    }
});