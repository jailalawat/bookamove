$(document).ready(function () {

    $(".review_icn").on("click", function(){

        $.ajax({
                url: '/click_review_positive',
                data: {
                    move_id: $(this).data("move-id"),
                    account_id: $(this).data("account-id"),
                    user_id: $(this).data("user-id"),
                    site: $(this).data("site")
                }
        })

    })

});