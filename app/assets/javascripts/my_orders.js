$(document).ready(function() {

    //set up section cover as variable
    var $sectionCover = $('.section-cover');

    // If width is wide
    if ((widthIsWide) && ($sectionCover.length > 0)) {

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
        scrolledOffset = scrolled,
        coverTop = $sectionCover.offset().top,
        coverHeight = $sectionCover.outerHeight(),
        coverBottom = coverTop + coverHeight + navHeight;
        if ( (scrolled > 0) && (scrolled <= coverBottom) ) {
            var translateYImage = ( scrolledOffset / 2 ) + 'px',
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

});
