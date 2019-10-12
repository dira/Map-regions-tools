function showMarkers(mapLayer, locations) {		// Add markers to the map
  var icon;
  var marker;
  for (var key in locations) {
    var iconName = `<div class="icon-text-county">`+locations[key]['resedinta']+`</div>`;
    icon = new L.DivIcon({
      className: 'icon-div',
      popupAnchor: [-6,-42],
      html: `
        <div class="icon-container">
      <img src="images/grey.png"/>
        `,
    });
  
    var marker = L.marker([locations[key]['lat'], locations[key]['lon']],{
      title: locations[key]['resedinta'],
      opacity: mapData.markerOpacity,
      icon: icon
    }).bindPopup(locations[key]['resedinta']).addTo(mapLayer);
  }
}

function showCenters(mapLayer, locations) {   // Add markers to the map
  var icon;
  var marker;
  for (var key in locations) {
    var iconName = `<div class="icon-text-county">`+locations[key]['judet']+`</div>`;
    icon = new L.DivIcon({
      className: 'icon-div',
      popupAnchor: [-6,-42],
      html: `
        <div class="icon-container">`+iconName+`
      <img src="images/green.png"/>
        `,
    });

    var marker = L.marker([locations[key]['lat'], locations[key]['lon']],{
      title: locations[key]['judet'],
      opacity: mapData.markerOpacity,
      icon: icon
    }).bindPopup('centrul').addTo(mapLayer);
  }
}

function getPolygonCenter(coordinates) {
  var n = coordinates.length;
  var cx = 0;
  var cy = 0;
  var a = 0;
  for (var i = 0; i < n-1; i++) {
    var t = coordinates[i][0] * coordinates[i+1][1] - coordinates[i+1][0] * coordinates[i][1];
    cx += (coordinates[i][0] + coordinates[i+1][0]) * t;
    cy += (coordinates[i][1] + coordinates[i+1][1]) * t;
    a += t;
  }
  a = a /2;

  return [cx/6/a, cy/6/a]
}