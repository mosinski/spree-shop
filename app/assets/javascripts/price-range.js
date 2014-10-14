var ready = function() {
  $("#slider-range").slider({
    range: true,
    min: 0,
    max: 600,
    values: [ $(".price-range #price_min").val() || 75, $(".price-range #price_max").val() || 400 ],
    slide: function( event, ui ) {
      $("#amount").val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
      $(".price-range #price_min").val( ui.values[ 0 ] );
      $(".price-range #price_max").val( ui.values[ 1 ] );
    }
  });
  $("#price-reset").click(function() {
    $(".price-range #price_min, .price-range #price_max").val('');
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
