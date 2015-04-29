$(document).ready(function() {
  $('.flexslider').flexslider({
    animation: 'slide',
    controlNav: 'thumbnails',
    smoothHeight: true
  });

	if ($('.spree #products').length > 0) {
	    $('.spree #products .product-list-item').shuffle();
	}

	if ($('.lazy').length > 0) {
		$("div.lazy").lazyload({
	      effect : "fadeIn"
	  });
	};
});

