function showResidences(mapLayer, locations) {		// Add markers to the map
  for (var key in locations) {
  L.circle([locations[key]['resedinta']['lat'], locations[key]['resedinta']['lon']],{
      color: "#fb0",
      fillColor: "#fb0",
      fillOpacity: 0.3,
      radius: 1500
    }).bindPopup('Reședința de județ: ' + locations[key]['resedinta']['nume']).addTo(mapLayer);
  }
}

function showCounties(json) {
  function onEachFeature(feature, layer) {
    var popupContent = feature.properties.name;
    layer.bindPopup(popupContent);
  }
  var colors = ['#8c510a','#bf812d','#dfc27d','#f6e8c3','#c7eae5','#80cdc1','#35978f','#01665e']
  for (var id in json.features) {
    var county = json.features[id];
    L.geoJSON([county], {
      style: function (feature) {
        return {
          weight: 1,
          color: "#666",
          fillColor: colors[county.properties.regionId - 1],
          opacity: 1,
          fillOpacity: 0.8
        }
      },
      onEachFeature: onEachFeature,
    }).addTo(map);
  }
};

function showCenters(mapLayer, locations) {   // Add markers to the map
  var icon;
  var marker;
  for (var key in locations) {
    var iconName = `<div class="icon-text-county">`+locations[key]['name']+`</div>`;
    icon = new L.DivIcon({
      className: 'icon-div',
      popupAnchor: [-6,-42],
      html: `
        <div class="icon-container">`+iconName+`
      <img src="images/green.png"/>
        `,
    });

    var marker = L.marker([locations[key]['lat'], locations[key]['lon']],{
      title: locations[key]['name'],
      opacity: mapData.markerOpacity,
      icon: icon
    }).bindPopup('centrul').addTo(mapLayer);
  }
}

function getCenters(countours) {
  var county_centers = []
  for (var id in countours.features) {
    var county = countours.features[id];

    var center = getPolygonCenter(county.geometry.coordinates[0]);
    county_centers.push({lon: center[0], lat: center[1], name: county.properties.name, code: county.properties.mnemonic});
  }
  return county_centers;
};

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

function getPolygonBoundaries(coordinates) {
  n = coordinates.length;
  min0 = coordinates[0][0]; max0 = min0;
  min1 = coordinates[0][1]; max1 = min1;
  for (var i = 1; i < n; i++) {
    if (min0 > coordinates[i][0]) {
      min0 = coordinates[i][0]
    }
    if (min1 > coordinates[i][1]) {
      min1 = coordinates[i][1]
    }
    if (max0 < coordinates[i][0]) {
      max0 = coordinates[i][0]
    }
    if (max1 < coordinates[i][1]) {
      max1 = coordinates[i][1]
    }
  }

  return [[min0, min1], [max0, max1]]
}
