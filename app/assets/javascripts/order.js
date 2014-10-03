$(document).on("page:change", function() {
  $("form.edit_order").on('change', 'input', function() {
    $("div#notice").html("<div class='alert alert-warning'><strong>Attention!</strong> Unsaved changes. Please click the update button.</div>");
  });
  $("a.cart_quantity_up").click(function() {
    $(this).next("input.cart_quantity_input").trigger('change').get(0).value++;
  });
  $("a.cart_quantity_down").click(function() {
    if($(this).prev("input.cart_quantity_input").val() > 1) {
      $(this).prev("input.cart_quantity_input").trigger('change').get(0).value--;
    }
  });
});
