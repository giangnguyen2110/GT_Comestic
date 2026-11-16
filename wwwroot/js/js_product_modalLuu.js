<script>

    let selectedVariantUid = null;

    $(document).ready(function () {

        // =========================
        // AUTO SELECT DEFAULT
        // =========================

        var defaultVariant = null;

    for (var i = 0; i < window.productVariants.length; i++) {

            if (window.productVariants[i].isDefault === true) {

        defaultVariant = window.productVariants[i];
    break;
            }
        }

    if (defaultVariant != null) {

            // active option button
            for (var groupName in defaultVariant.options) {

                var optionValue = defaultVariant.options[groupName];

    $('.option-btn[data-group="' + groupName + '"][data-option="' + optionValue + '"]')
    .addClass('active');
            }

    // set giá
    $("#priceDisplay").text(
    Number(defaultVariant.price).toLocaleString("vi-VN")
    );

    // set ảnh
    $("#productImage").attr("src", defaultVariant.image);

    // save uid
    selectedVariantUid = defaultVariant.uid;

    $("#addToCartBtn")
    .attr("data-uid", defaultVariant.uid);
        }


    // =========================
    // CLICK OPTION
    // =========================

    $("#modalContent").on("click", ".option-btn", function () {

            var group = $(this).data("group");
    var option = $(this).data("option");

    // remove active cùng group
    $('.option-btn[data-group="' + group + '"]')
    .removeClass("active");

    // add active
    $(this).addClass("active");


    // =========================
    // LẤY OPTION ĐANG CHỌN
    // =========================

    var selectedOptions = { };

    $(".option-btn.active").each(function () {

                var g = $(this).data("group");
    var o = $(this).data("option");

    selectedOptions[g] = o;
            });


    // check đủ group chưa
    if (Object.keys(selectedOptions).length < window.totalGroups) {
                return;
            }


    // =========================
    // TÌM VARIANT MATCH
    // =========================

    var matchedVariant = null;

    for (var i = 0; i < window.productVariants.length; i++) {

                var variant = window.productVariants[i];

    var isMatch = true;

    for (var key in selectedOptions) {

                    if (variant.options[key] != selectedOptions[key]) {

        isMatch = false;
    break;
                    }
                }

    if (isMatch) {

        matchedVariant = variant;
    break;
                }
            }


    // =========================
    // UPDATE UI
    // =========================

    if (matchedVariant != null) {

        // đổi giá
        $("#priceDisplay").text(
            Number(matchedVariant.price).toLocaleString("vi-VN")
        );

    // đổi ảnh
    $("#productImage").attr("src", matchedVariant.image);

    // save uid
    selectedVariantUid = matchedVariant.uid;

    $("#addToCartBtn")
    .attr("data-uid", matchedVariant.uid);
            }

        });


    // =========================
    // ADD TO CART
    // =========================

    $("#modalContent").on("click", "#addToCartBtn", function () {

            var uid = $(this).attr("data-uid");

    if (!uid) {

        alert("Vui lòng chọn phân loại");
    return;
            }

    window.location.href =
    "/Cart/AddToCart?uid=" + uid + "&quantity=1";
        });

    });

</script>