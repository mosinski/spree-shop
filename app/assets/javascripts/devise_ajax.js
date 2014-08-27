$(document).on("ajax:success", "form#sign_up_user", function(e, data, status, xhr) {
  if (!data.success) {
    $("#register_errors").hide();
    $("#register_errors").html("");
    $.each(data.errors, function( index, error ){
      $("#register_errors").append("<b>"+error+"</b><br>");
    });
    $("#register_errors").show();
  }
});
