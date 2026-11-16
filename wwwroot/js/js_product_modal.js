let selectedVariantUid = null;
let selectedOptions = {};


// ========================================
// MỞ MODAL DETAIL
// ========================================

$(document).on("click", ".btn-detail", function () {

    var id = $(this).data("id");

    $.get("/Product/DetailPopup/" + id, function (data) {

        // reset state
        selectedVariantUid = null;
        selectedOptions = {};

        // render modal
        $("#modalContent").html(data);

        // show modal
        $("#productModal").modal("show");
    });

});


// ========================================
// CHỌN OPTION
// ========================================

$("#modalContent").on("click", ".option-btn", function () {

    // lấy group + option
    let group = $(this).data("group");
    let option = $(this).data("option");


    // ========================================
    // ACTIVE BUTTON TRONG CÙNG GROUP
    // ========================================

    $('.option-btn[data-group="' + group + '"]')
        .removeClass("active");

    $(this).addClass("active");


    // ========================================
    // LƯU OPTION ĐÃ CHỌN
    // ========================================

    selectedOptions[group] = option;


    // ========================================
    // CHECK ĐỦ GROUP CHƯA
    // ========================================

    let totalGroups =
        (typeof window.totalGroups !== "undefined")
            ? window.totalGroups
            : 1;

    if (Object.keys(selectedOptions).length < totalGroups) {
        return;
    }


    // ========================================
    // TÌM VARIANT MATCH
    // ========================================

    let matchedVariant = window.productVariants.find(function (v) {

        let variantOptions = v.options;

        return Object.keys(selectedOptions).every(function (key) {

            return variantOptions[key] === selectedOptions[key];

        });

    });


    // ========================================
    // KHÔNG TÌM THẤY
    // ========================================

    if (!matchedVariant) {

        console.log("Không tìm thấy variant phù hợp");
        return;
    }


    // ========================================
    // SAVE UID
    // ========================================

    selectedVariantUid = matchedVariant.uid;


    // ========================================
    // UPDATE GIÁ
    // ========================================

    $("#priceDisplay").text(
        Number(matchedVariant.price)
            .toLocaleString("vi-VN")
    );


    // ========================================
    // UPDATE ẢNH
    // ========================================

    $("#productImage").attr(
        "src",
        matchedVariant.image
    );


    // ========================================
    // GÁN UID CHO CART
    // ========================================

    $("#addToCartBtn")
        .attr("data-uid", matchedVariant.uid);

});


// ========================================
// ADD TO CART
// ========================================

$("#modalContent").on("click", "#addToCartBtn", function () {

    let uid = $(this).attr("data-uid");

    if (!uid) {

        alert("Vui lòng chọn phân loại");
        return;
    }

    window.location.href =
        "/Cart/AddToCart?variantUid="
        + uid
        + "&quantity=1";
});


// ========================================
// RESET MODAL
// ========================================

$('#productModal').on('hidden.bs.modal', function () {

    selectedVariantUid = null;
    selectedOptions = {};

    $("#modalContent").html("");

});


// ========================================
// AUTO SELECT DEFAULT VARIANT
// ========================================

$('#productModal').on('shown.bs.modal', function () {

    if (!window.productVariants)
        return;

    let defaultVariant = null;


    // tìm default
    for (let i = 0; i < window.productVariants.length; i++) {

        if (window.productVariants[i].isDefault === true) {

            defaultVariant = window.productVariants[i];
            break;
        }
    }


    // không có default
    if (!defaultVariant)
        return;


    // auto click option
    for (let group in defaultVariant.options) {

        let value = defaultVariant.options[group];

        let btn = $(
            '.option-btn[data-group="' + group + '"][data-option="' + value + '"]'
        );

        if (btn.length > 0) {

            btn.trigger("click");
        }
    }

});