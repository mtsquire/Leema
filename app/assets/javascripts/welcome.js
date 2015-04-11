// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function doneResizing() {

    var b = getViewport()[0], c = getViewport()[1];
    if (b != viewPortWidth && (console.log("Viewport Width: " + viewPortWidth + ", New Width: " + b), widthIsWide && 769 > b ? prlxBg = function() {
    } : !widthIsWide && b > 768 || (resizing = !1), widthIsWide = b > 768 ? !0 : !1), c != viewPortHeight && console.log("Viewport Height: " + viewPortHeight + ", New Height: " + c), c != viewPortHeight || b != viewPortWidth)
        if (widthIsWide) {
            var d = (c * .66666667) + "px", e = $(".navbar").outerHeight();
            $(".masthead").each(function() {
                $(this).css("height", d), $(this).css("visibility", "visible").css("opacity", "1");

                // Reposition search bar in center of masthead
                introMargin = $('.masthead').height() / 2;
                introHeight = $('.intro').height() / 2;
                $(".intro").css("margin-top", Math.floor(introMargin - introHeight))
            })
        } else {
            $(".masthead").css("height", "").css("margin-top", "").css("padding-top", "").css("visibility", "visible").css("opacity", "1");
            viewPortHeight = c, viewPortWidth = b;

            // Reposition search bar in center of masthead
            introMargin = $('.masthead').height() / 2;
            introHeight = $('.intro').height() / 2;
            $(".intro").css("margin-top", Math.floor(introMargin - introHeight))
        }
    }


$(document).ready(function() {
    // define viewport vairables
        viewPortWidth = getViewport()[0],
        viewPortHeight = getViewport()[1],
        widthIsWide = (viewPortWidth > 1024),
        IEVersion = getInternetExplorerVersion();

    if (viewPortWidth = getViewport()[0], viewPortHeight = getViewport()[1], widthIsWide = viewPortWidth > 1024, IEVersion = getInternetExplorerVersion(), widthIsWide) {
        var a = (viewPortHeight * .75) + "px",
            b = $(".navbar").outerHeight();
        $(".masthead").each(function() {
            $(this).css("height", a), $(this).css("visibility", "visible").css("opacity", "1");
        })
    }

    // Reposition search bar in center of masthead
    var introMargin = $('.masthead').height() / 2,
        introHeight = $('.intro').height() / 2;

    $(".intro").css("margin-top", Math.floor(introMargin - introHeight))

    var c;
    $(window).on("resize", function() {
        clearTimeout(c), c = setTimeout(doneResizing, 1e3)
    }), window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || function(a) {
        setTimeout(a, 1e3 / 60)
    };
    var d = function(a, b, c, d) {
        var e = a.offset().top, f = a.outerHeight(), g = e - viewPortHeight + c, h = e + f;
        b >= g && h >= b && d(g, h)
    };

    //parrallax covers
    // requestAnimationFrame method:
    window.requestAnimationFrame = window.requestAnimationFrame
        || window.mozRequestAnimationFrame
        || window.webkitRequestAnimationFrame
        || window.msRequestAnimationFrame
        || function(f){setTimeout(f, 1000/60)}

    var isInViewport = function(element,scrolled,offset,callback) {
        var elementTop = element.offset().top,
            elementHeight = element.outerHeight(),
            elementVisibleAt = elementTop - viewPortHeight + offset,
            elementBottom = elementTop + elementHeight;
        if ( (scrolled >= elementVisibleAt) && (scrolled <= elementBottom) ) {
            callback(elementVisibleAt,elementBottom);
        }
    }

    if (widthIsWide) {

        // define function to fire with requestAnimationFrame
        parallaxBackground = function(){
            var scrolled = window.pageYOffset;
            $('#reindeer').each(function(){
                var thisEl = $(this);
                isInViewport(thisEl,scrolled,0,function(elementVisibleAt,elementBottom){
                    thisEl.css('background-position', '50% ' + ( 100 - ( ( scrolled - elementVisibleAt ) / elementBottom * 100 ) ) + '%');
                });
            });
        }

        parallaxBackground();

        if ($('.icon-blurb').length > 0){

            // define function to fade in bio photo and blurb from left with requestAnimationFrame
            iconBlurbLeft = function(){
                var scrolled = window.pageYOffset,
                    offset = viewPortHeight / 3;
                $('.icon-blurb:even .icon, .icon-blurb:odd .blurb').each(function(){
                    var thisEl = $(this);
                    isInViewport(thisEl,scrolled,offset,function(elementVisibleAt,elementBottom){
                        thisEl.addClass('animated iconBlurbLeft');
                    });
                });
            }

            iconBlurbLeft();

            // define function to fade in bio photo and blurb from right with requestAnimationFrame
            iconBlurbRight = function(){
                var scrolled = window.pageYOffset,
                    offset = viewPortHeight / 3;
                $('.icon-blurb:odd .icon, .icon-blurb:even .blurb').each(function(){
                    var thisEl = $(this);
                    isInViewport(thisEl,scrolled,offset,function(elementVisibleAt,elementBottom){
                        thisEl.addClass('animated iconBlurbRight');
                    });
                });
            }

            iconBlurbRight();


            // define function to fade in bio photo and blurb from right with requestAnimationFrame
            pricingPercent = function(){
                var scrolled = window.pageYOffset
                $('.pricing-box .pricing-percent').each(function(){
                    var thisEl = $(this),
                        offset = viewPortHeight / 4;
                    isInViewport(thisEl,scrolled,offset,function(elementVisibleAt,elementBottom){
                        thisEl.addClass('animated fadeInUp');
                    });
                });
            }

            iconBlurbRight();

            //fade in blurb on intro panel
            setTimeout(function(){
                $(".intro").addClass("animated fadeInUp");
            }, 500);


        } else {
            iconBlurbLeft = function(){}
            iconBlurbRight = function(){}
            pricingPercent = function(){}
        }

    } else {
        parallaxBackground = function(){}
    }

    // fire parallax functions on scroll through requestAnimationFrame if not oldIE
    if ( !($('html').hasClass('lt-ie9')) && widthIsWide) {
        window.addEventListener('scroll', function(){
            if ($('#reindeer').length > 0){
                requestAnimationFrame(parallaxBackground)
            }
            if ($('.icon-blurb').length > 0){
                requestAnimationFrame(iconBlurbLeft)
                requestAnimationFrame(iconBlurbRight)
            }
            if ($('.pricing-box').length > 0){
                requestAnimationFrame(pricingPercent)
            }
        }, false)
    }

    // set up owl carousel for featured products
    if ($("#featured-products").length > 0){
     $("#featured-products").owlCarousel({
          autoPlay: 5000, //Set AutoPlay to 3 seconds
          items: 3,
          itemsDesktop: [1199,3],
          itemsDesktopSmall: [979,3],
          stopOnHover: true,
          scrollPerPage: true
      });
    }
});
