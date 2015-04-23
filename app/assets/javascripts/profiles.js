// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready(function() {

// define viewport vairables
    viewPortWidth = getViewport()[0],
    viewPortHeight = getViewport()[1],
    widthIsWide = (viewPortWidth > 768);

    //parrallax covers
    // requestAnimationFrame method:
    window.requestAnimationFrame = window.requestAnimationFrame
        || window.mozRequestAnimationFrame
        || window.webkitRequestAnimationFrame
        || window.msRequestAnimationFrame
        || function(f){setTimeout(f, 1000/60)}


    //set up section cover as variable
    var $sectionCover = $('.section-cover');

    // If width is wide
if ((widthIsWide) && ($sectionCover.length > 0)) {

    $sectionCover = $sectionCover.first();

    // calculate height of profile container after resize of browser window
    function doneResizingProfile(){

        var newWidth = getViewport()[0],
        newHeight = getViewport()[1];

        // after resizing, does the new width match the old one?
        if (newWidth != viewPortWidth) {


            var sectionCoverHeight = newWidth / 3;

            $sectionCover.css("height", sectionCoverHeight);

        }

        // reset globals
        viewPortHeight = newHeight;
        viewPortWidth = newWidth;

    }



    // calculate height of profile container at width/3 ratio
        var viewPortWidth = getViewport()[0],
        viewPortHeight = getViewport()[1],
        sectionCoverHeight = viewPortWidth / 3;

        $sectionCover.css("height", sectionCoverHeight);

        var profileResizeTimeout;
        $(window).on('resize',function(){
            clearTimeout(profileResizeTimeout);
            profileResizeTimeout = setTimeout(doneResizingProfile, 1000);
        });



    // set up the section-cover parallax

    var $nav = $('nav'),
        navHeight = $nav.outerHeight(),
        scrolled = 0,
        $coverImage = $sectionCover.find('.section-cover-image'),
        $coverHeader = $sectionCover.find('h1');


    parallaxBackground = function(){
        var scrolled = window.pageYOffset - navHeight,
            scrolledOffset = scrolled - 10,
            coverTop = $sectionCover.offset().top,
            coverHeight = $sectionCover.outerHeight(),
            coverBottom = coverTop + coverHeight + navHeight;

        if ( (scrolled > 0) && (scrolled <= coverBottom) ) {
            var translateYImage = ( scrolledOffset / 3 ) + 'px',
                translateYTitle = ( scrolledOffset / 5 ) + 'px',
                opacity = ( 1 - (scrolledOffset / coverHeight) );
            $coverImage.css({
                'transform' : 'translateY(' + translateYImage + ')',
                'opacity' : opacity
            });
            $coverHeader.css({
                'transform' : 'translateY(' + translateYTitle + ')',
                'opacity' : opacity
            });
        } else {
            $coverImage.css({
                'transform' : '',
                'opacity' : ''
            });
            $coverHeader.css({
                'transform' : '',
                'opacity' : ''
            });
        }
    }

    parallaxBackground();

} else {
    parallaxBackground = function(){}
}

    // fire parallax functions on scroll through requestAnimationFrame if not oldIE
    if ( !(MSIE) && !(/(iPad|iPhone|iPod|Android)/g.test(navigator.userAgent)) ) {
        window.addEventListener('scroll', function(){
            requestAnimationFrame(parallaxBackground)
        }, false)
    }



    if ($('.no-bio').length > 0) {
        var selectJoke = [
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-joke-1.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-joke-2.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-joke-3.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-pun1.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-pun2.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-pun3.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-pun4.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-pun5.jpg',
            'https://d1vw1wxlid17s8.cloudfront.net/assets/food-pun6.jpg'
        ],
            joke = selectJoke[Math.floor(Math.random() * selectJoke.length)];

        $('.food-joke').attr('src', joke);
    }

});

