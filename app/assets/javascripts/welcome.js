// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
    // define viewport vairables
        viewPortWidth = getViewport()[0],
        viewPortHeight = getViewport()[1],
        widthIsWide = (viewPortWidth > 1024),
        IEVersion = getInternetExplorerVersion();

    if ($('.masthead')) {
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

        $(".intro").css("margin-top", Math.floor(introMargin - introHeight));
    }


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

    $(".owl-carousel").owlCarousel({
        slideSpeed : 300,
        paginationSpeed : 400,
        singleItem: true,
        autoPlay: 6000
    });

    if (widthIsWide) {

        if ($('.icon-blurb').length > 0){


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

            //fade in blurb on intro panel
            setTimeout(function(){
                $(".intro").addClass("animated fadeInUp");
            }, 500);


        } else {

            pricingPercent = function(){}
        }
    }

    // fire parallax functions on scroll through requestAnimationFrame if not oldIE
    if ( !($('html').hasClass('lt-ie9')) && widthIsWide) {
        window.addEventListener('scroll', function(){
            if ($('.pricing-box').length > 0){
                requestAnimationFrame(pricingPercent)
            }
        }, false)
    }

   function loadInstagrams() {
        $.ajax({
          url: 'https://api.instagram.com/v1/users/1586239279/media/recent?client_id=34060d525c58405088094409b600da10',
          dataType: 'jsonp',
          cache: true,
          success:function(data){

            for (var i = 0; i < 10; i++) {
                var instagram = data.data[i];
                if (widthIsWide) {
                    var imageUrl = instagram.images.standard_resolution.url;
                } else {
                    imageUrl = instagram.images.low_resolution.url;
                }


                $('#instagram-feed').append('<img class="img-responsive" src="'+imageUrl+'">')
            }
          }
        });
    }

    loadInstagrams();


    //resize height of welcome section at top of page
    var welcomeSection = $('#welcome');
    var headerHeight = $('nav.navbar-default').outerHeight();

    if (getViewport()[0] >= 767) {
        welcomeSection.css('height', ((getViewport()[1] - headerHeight) * .75));
    } else if ((getViewport()[0] < 767) && (getViewport()[0] > 480)) {
        welcomeSection.css('height', ((getViewport()[1] - headerHeight) * .666667));
    } else {
        welcomeSection.css('height', '250');
    }

    $(window).on('resize',function(){
        if($('.masthead')) {
            $('.masthead').css('height', (getViewport()[1] * .6666667));
            var introMargin = $('.masthead').height() / 2,
                introHeight = $('.intro').height() / 2;

            $(".intro").css("margin-top", Math.floor(introMargin - introHeight));
        }

        if (getViewport()[0] >= 767) {
            console.log('>= 767');
            welcomeSection.css('height', ((getViewport()[1] - headerHeight) * .75));
        } else if ((getViewport()[0] < 767) && (getViewport()[0] > 480)) {
            console.log('< 767 and > 480');
            welcomeSection.css('height', ((getViewport()[1] - headerHeight) * .666667));
        } else {
            console.log('350');
            welcomeSection.css('height', '250');
        }
    });

    var newsletterCookie = Cookies.get('leemanewsletter');

    if (newsletterCookie == 'donotshow') {
        $('.newsletter-alert').remove();
    } else {
        var newsletterAlertHeight = $('.newsletter-alert').outerHeight();
        var linesButtonTop = $('.lines-button').css('top');
        var moveLinesButton = newsletterAlertHeight + parseInt(linesButtonTop, 10);

        $('.newsletter-alert').slideDown('slow');
        $('.lines-button').css('top', moveLinesButton);
        $('.newsletter-alert .close').click(function(){

            linesButtonTop = $('.lines-button').css('top');

            moveLinesButton = parseInt(linesButtonTop, 10) - newsletterAlertHeight;

            Cookies.set('leemanewsletter', 'donotshow',{ expires: 5 }, { secure:true });

            $('.lines-button').css('top', moveLinesButton);
        });
        $('#mc-embedded-subscribe').click(function(){

            linesButtonTop = $('.lines-button').css('top');
            moveLinesButton = parseInt(linesButtonTop, 10) - newsletterAlertHeight;

            Cookies.set('leemanewsletter', 'donotshow',{ expires: 1095 }, { secure:true });
            $('.newsletter-alert').remove();
            $('.lines-button').css('top', moveLinesButton);
        });
    };
});
