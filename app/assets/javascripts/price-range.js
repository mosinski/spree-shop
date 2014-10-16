var ready = function() {
  $("#slider-range").slider({
    range: true,
    min: parseInt($(".price-range #price_min").attr('min'),10),
    max: parseInt($(".price-range #price_max").attr('max'),10),
    values: [$(".price-range #price_min").val(), $(".price-range #price_max").val()],
    slide: function( event, ui ) {
      $("#amount").val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
      $(".price-range #price_min").val( ui.values[ 0 ] );
      $(".price-range #price_max").val( ui.values[ 1 ] );
    }
  });
  $("#price-reset").click(function() {
    $(".price-range #price_min").val($(".price-range #price_min").attr('min'));
    $(".price-range #price_max").val($(".price-range #price_max").attr('max'));
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
