$(document).ready(function () {
    var sliderBar   = $('#shoot');
    var packageList = $('.shoot-packages-boxes').find('ul li');
    var ww = $(window).width();
    console.log(ww);

    // speciality select function
    $.fn.specialityType = function (filter) {
        $('.type-box').removeClass('selected');
        $(this).addClass('selected');
        $('.specialties .row').addClass('hidden');
        $(filter).removeClass('hidden');
    };

    // on speciality select
    var speciality = $('#specialities').find('ul li a');
    speciality.on("click", function () {
        speciality.removeClass('selected');
        $(this).addClass('selected');
    });

    // handle show more button
    $('#show-more').click(function () {
        $('.specialties .row div').removeClass('hidden');
        $(this).hide(500);
    });

    if (ww > 991){
        sliderBar.slider({tooltip: 'hide'});
        sliderBar.slider().on('change', function (event) {
            var newValue = event.value.newValue;
            $('.shoot-packages-boxes ul li').removeClass('active');
            $('.shoot-packages-boxes ul').find("li[data-index=" + newValue + "]").addClass('active');
        });
    }

    // pricing click function
    $.fn.pricing = function (selectClassName) {
        $('.pricing-section .block').removeClass('selected');
        $(this).addClass('selected');
        $('.shoot-packages-boxes').addClass('hidden');
        $('.shoot-packages-boxes.' + selectClassName).removeClass('hidden');

        $('.shoot-packages-boxes ul li').removeClass('active');
        $('.shoot-packages-boxes ul').find("li[data-index=0]").addClass('active');
    };

    // setup slider for pricing



    // change class and slider value on Click pricing
    packageList.on('click', function () {
        $('.shoot-packages-boxes').find('ul li').removeClass('active');
        $(this).addClass('active');
        var index = $(this).data('index');
        sliderBar.slider('setValue', index, true);
    });
});

$(window).on('load', function () {
    // set width for slider
    // 5 equal 6 pricing for dynamic change value
    $(".slider-horizontal").css({
        "max-width": 160 * (5)
    });
});
