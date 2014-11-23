$(document).on('ready page:load', function () {
  $('#nav').affix({
    offset: { top: $('#nav').offset().top }
  });
});
