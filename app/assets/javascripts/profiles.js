// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {

	// calculate height of profile container after resize of browser window
	function doneResizingProfile(){

		var newWidth = getViewport()[0],
				newHeight = getViewport()[1];

		// after resizing, does the new width match the old one?
		if (newWidth != viewPortWidth) {


				var sectionCoverHeight = newWidth / 3;

				$(".section-cover").css("height", sectionCoverHeight);

		}

		// reset globals
		viewPortHeight = newHeight;
		viewPortWidth = newWidth;

	}



	// calculate height of profile container at width/3 ratio
	if ($(".section-cover").length > 0) {

	  var viewPortWidth = getViewport()[0],
	    	viewPortHeight = getViewport()[1],
				sectionCoverHeight = viewPortWidth / 3;

			$(".section-cover").css("height", sectionCoverHeight);

			var profileResizeTimeout;
	    $(window).on('resize',function(){
	      clearTimeout(profileResizeTimeout);
	      profileResizeTimeout = setTimeout(doneResizingProfile, 1000);
	    });

	  } else {

	  }


	// set up the section-cover parallax
	if (widthIsWide) {

		var nav = $('nav'),
				navHeight = nav.outerHeight(),
				scrolled = 0;


		// set up the section-cover parallax
		if ($('.section-cover').length > 0) {

			parallaxBackground = function(){
				var scrolled = window.pageYOffset;
				$('.section-cover').each(function(){
					var $this = $(this),
						scrolledOffset = scrolled - navHeight,
						thisTop = $this.offset().top,
						thisHeight = $this.outerHeight(),
						thisBottom = thisTop + thisHeight,
						translateYImage = ( scrolledOffset / 2 ) + 'px',
						translateYTitle = ( scrolledOffset / 5 ) + 'px',
						opacity = ( 1 - (scrolledOffset / thisHeight) );
					if ( (scrolled >= navHeight ) && (scrolled <= thisBottom) ) {
						$this.find('.section-cover-image').css({
							'transform' : 'translateY(' + translateYImage + ')',
							'opacity' : opacity
						});
						$this.find('h1').css({
							'transform' : 'translateY(' + translateYTitle + ')',
							'opacity' : opacity
						});
					} else {
						$this.find('.section-cover-image').css({
							'transform' : '',
							'opacity' : ''
						});
						$this.find('h1').css({
							'transform' : '',
							'opacity' : ''
						});
					}
				});
			}

			parallaxBackground();

			// fire parallax functions on scroll through requestAnimationFrame if not oldIE
			window.addEventListener('scroll', function(){
				requestAnimationFrame(parallaxBackground)
			}, false)

		} else {
			parallaxBackground = function(){}
		}

	} else {
		parallaxBackground = function(){}
	}


});
