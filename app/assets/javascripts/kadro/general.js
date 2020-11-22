function throttle(fn, threshhold, scope) {
    threshhold || (threshhold = 250);
    var last,
        deferTimer;
    return function () {
        var context = scope || this;

        var now  = +new Date,
            args = arguments;
        if (last && now < last + threshhold) {
            // hold on to it
            clearTimeout(deferTimer);
            deferTimer = setTimeout(function () {
                last = now;
                fn.apply(context, args);
            }, threshhold);
        } else {
            last = now;
            fn.apply(context, args);
        }
    };
}

function apendInMenu(id, str) {
    return '<li class="menu-item"><a href="/#' + id + '">' + str + '</a></li>';
}
jQuery(document).ready(function ($) {
    var primaryMenu = $('#primary-menu');
    var navigation  = $('#site-navigation');
    var menuList    = primaryMenu.find('> .menu-item');

    // hamburgers effects
    var forEach    = function (t, o, r) {
        if ("[object Object]" === Object.prototype.toString.call(t))for (var c in t)Object.prototype.hasOwnProperty.call(t, c) && o.call(r, t[c], c, t); else for (var e = 0, l = t.length; l > e; e++)o.call(r, t[e], e, t)
    };
    var hamburgers = document.querySelectorAll(".hamburger");
    if (hamburgers.length > 0) {
        forEach(hamburgers, function (hamburger) {
            hamburger.addEventListener("click", function () {
                this.classList.toggle("is-active");
                navigation.toggleClass('open');
                if (navigation.hasClass('open')) {
                    $(this).removeClass('open');
                } else {
                    $(this).addClass('open');
                }
            }, false);
        });
    }

    // detect mobile
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        // nothing yet
    } else {
    }

    var wh        = $(window).height();
    var throttled = throttle(headerSticky, 100);
    $(window).scroll(throttled);
    function headerSticky() {
        var masthead = $('#masthead');
        if ($(this).scrollTop() > 200) {
            masthead.addClass('go-top');
        } else if ($(this).scrollTop() < 200) {
            masthead.removeClass('go-top');
        }

        if ($(this).scrollTop() > wh - 100) {
            masthead.addClass('scroll');
            masthead.removeClass('go-top');
        } else if ($(this).scrollTop() < wh - 300) {
            masthead.removeClass('scroll');
            $('a[href*="#"]').removeClass('active');
        } else if ($(this).scrollTop() < wh) {
            masthead.addClass('go-top');
        }
    }
    // var menuInner = apendInMenu('home-how', 'چطوری کار میکنه؟') + apendInMenu('home-expertise', 'تخصص ها') + apendInMenu('pricing', 'قیمت ها');
    // primaryMenu.prepend(menuInner);
    // Add smooth scrolling to all links
    $('a[href*="#"]').on('click', function (event) {
        $('a[href*="#"]').removeClass('active');
        $(this).addClass('active');
        hamburgers[0].click();
        // Make sure this.hash has a value before overriding default behavior
        if (this.hash !== "") {
            // Prevent default anchor click behavior
            //event.preventDefault();

            // Store hash
            var hash = this.hash;

            // Using jQuery's animate() method to add smooth page scroll
            // The optional number (800) specifies the number of milliseconds it takes to scroll to the specified area
            $('html, body').animate({
                scrollTop: $(hash).offset().top
            }, 800, function () {

                // Add hash (#) to URL when done scrolling (default click behavior)
                window.location.hash = hash;
            });
        } // End if
    });

    // handel pricing button (low & high)
    $('.pricing_button').on('click', function () {
        $('.pricing_button').toggleClass('selected');
        //var pricing = $(this).attr('data-toggle');
        $('.prices-block').toggleClass('open');
    });



});

jQuery(window).load(function () {
    jQuery('#loading').hide();
    jQuery('#page').removeClass('blur');
});
