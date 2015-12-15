$(document).ready(function() {
  $('.flexslider').flexslider({
    animation: 'slide',
    controlNav: 'thumbnails',
    smoothHeight: true
  });

	if ($('.lazy').length > 0) {
		$("div.lazy").lazyload({
	      effect : "fadeIn",
          threshold : 200
	  });
	};
});

