$(document).on("click", ".btn-detail", function () {
    var id = $(this).data("id");

    $.get("/Product/DetailPopup/" + id, function (data) {
        $("#modalContent").html(data);

        $("#productModal").modal("show"); // <-- BOOTSTRAP 4
    });
});