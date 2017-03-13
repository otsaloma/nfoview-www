// -*- coding: utf-8-unix -*-

$(document).on("ready", function() {
    if (platform.os.family.indexOf("Windows") === 0) {
        $(".download.source").hide();
        $(".download.windows").show();
    }
});

$(document).on("ready", function() {
    $(".image-popup").magnificPopup({
        closeOnContentClick: true,
        retina: {ratio: 2},
        showCloseBtn: false,
        type: "image",
    });
});
