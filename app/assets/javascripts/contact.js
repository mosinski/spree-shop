function initialize() {
  var mapOptions = {
    zoom: 14,
    center: new google.maps.LatLng(54.3475, 18.645278)
  }
  var map = new google.maps.Map(document.getElementById('map-canvas'),
  mapOptions);

  var image = 'assets/contact/marker.png';
  var myLatLng = new google.maps.LatLng(54.3475, 18.645278);
  var beachMarker = new google.maps.Marker({
    position: myLatLng,
    map: map,
    icon: image,
    draggable:false,
    //animation: google.maps.Animation.DROP,
    animation: google.maps.Animation.BOUNCE,
    title:"We are here!"
  });
}

google.maps.event.addDomListener(window, 'page:load', initialize);
