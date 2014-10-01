var product_to_delete = null;

$(document).on("page:change", function() {
  if (($('form#update-cart')).is('*')) {
    ($('form#update-cart a.delete')).show().one('click', function() {
      (product_to_delete = ($(this)).parents('.line-item').first()).find('input.cart_quantity_input').val(0);
      ($(this)).parents('form').first().submit();
      return false;
    });
  }
  return ($('form#update-cart')).submit(function() {
    return ($('form#update-cart #update-button')).attr('disabled', true);
  });
});

$(document).on("ajax:success", "form#update-cart", function(e, data, status, xhr) {
  if (!data.success) {
    product_to_delete.hide();
    product_to_delete = null
  }
});
