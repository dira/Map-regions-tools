function showMarkers(mapLayer, locations) {		// Add markers to the map
  var icon;
  var marker;
  for (var key in locations) {
    var iconName = `<div class="icon-text-county">`+locations[key]['judet']+`</div>`;   
    icon = new L.DivIcon({
      className: 'icon-div',
      popupAnchor: [-6,-42],
      html: `
        <div class="icon-container">`+iconName+`
      <img src="images/grey.png"/>
        `,
    });
  
    var marker = L.marker([locations[key]['lat'], locations[key]['lon']],{
      title: locations[key]['judet'],
      opacity: mapData.markerOpacity,
      icon: icon
    }).bindPopup(locations[key]['details']).addTo(mapLayer);
  }
}