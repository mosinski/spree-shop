var ready;
ready = function() {
  $( "#slider-range" ).slider({
    range: true,
    min: 0,
    max: 600,
    values: [ $("#price_min").val() || 75, $("#price_max").val() || 400 ],
    slide: function( event, ui ) {
      $( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
      $( "#price_min" ).val( ui.values[ 0 ] );
      $( "#price_max" ).val( ui.values[ 1 ] );
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
