//<![CDATA[
    (function($){
      var base_url = "<%= admin_prototypes_url %>";
      var prototype_select = $('#product_prototype_id');
      prototype_select.change(function() {
        var id = prototype_select.val();
        if (id.length) {
          var url = new Uri(base_url);
          url.setPath(url.path() + '/' + id);
          $('#product-from-prototype').load(url.toString());
        } else {
          $('#product-from-prototype').empty();
        }
      })
      if (prototype_select.html() == "") {
        prototype_select.change();
      }
    })(jQuery);
  //]]>

    $(document).ready(function(){
      (function($){
        var base_url = "<%= admin_prototypes_url %>";
        var prototype_select = $('#product_prototype_id');
        prototype_select.change(function() {
          var id = prototype_select.val();
          if (id.length) {
            var url = new Uri(base_url);
            url.setPath(url.path() + '/' + id);
            $('#product-from-prototype').load(url.toString());
          } else {
            $('#product-from-prototype').empty();
          }
        })
        if (prototype_select.html() == "") {
          prototype_select.change();
        }
      })(jQuery);
      
      $("#product_price").keyup(function() {

          var value = $( this ).val(),
              percent = (90/100),
              netPrice = (value * percent).toFixed(2);

              if (isNaN(netPrice)) {
                $( ".net-price" ).text( "Please enter a numeric value." );
              } else {
                $( ".net-price" ).text( "$"+netPrice );
              }

        }).keyup();

      var customOrderCheck = $('.custom-order-checkbox input[type="checkbox"]');
      customOrderCheck.click(function(){
        if (customOrderCheck.prop('checked') == true) {
          $('.custom-orders').slideDown('slow');
          var element = document.getElementById('product_prototype_id');
          element.value = "1";
          var id = element.value;
          var base_url = "<%= admin_prototypes_url %>";
          var url = new Uri(base_url);
          url.setPath(url.path() + '/' + id);
          $('#product-from-prototype').load(url.toString());
        } else {
          $('.custom-orders').slideUp('slow');
        };
      });
    });
