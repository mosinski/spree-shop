$(document).on("ajax:success", "form#sign_up_user, form#sign_in_user", function(e, data, status, xhr) {
  if (!data.success) {
    $("#devise_errors").hide();
    $("#devise_errors").html("");
    $.each(data.errors, function( index, error ){
      $("#devise_errors").append("<b>"+error+"</b><br>");
    });
    $("#devise_errors").show();
  }
});
