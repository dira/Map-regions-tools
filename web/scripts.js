function showResidences(mapLayer, locations) {		// Add markers to the map
  for (var key in locations) {
  L.circle([locations[key]['resedinta']['lat'], locations[key]['resedinta']['lon']],{
      color: "#fb0",
      fillColor: "#fb0",
      fillOpacity: 1,
      radius: 1500
    }).bindPopup('Reședința de județ: ' + locations[key]['resedinta']['nume']).addTo(mapLayer);
  }
}

function showCounties(json) {
  var fillOpacity = 0.9;
  var color_mapping = {"AB":1,"AG":1,"AR":2,"B":1,"BC":1,"BH":3,"BN":1,"BR":1,"BT":2,"BV":3,"BZ":2,"CJ":2,"CL":1,"CS":1,"CT":2,"CV":4,"DB":2,"DJ":1,"GJ":2,"GL":4,"GR":3,"HD":3,"HR":2,"IF":4,"IL":3,"IS":1,"MH":3,"MM":4,"MS":4,"NT":4,"OT":2,"PH":1,"SB":2,"SJ":1,"SM":2,"SV":3,"TL":3,"TM":4,"TR":4,"VL":4,"VN":3,"VS":2}
  //var colors = [ "#fe9929", "#fec44f", "#fee391", "#fff7bc", "#ffffe5"] // light yellows
  var colors = ["#fee090", "#e08214", "#b35806", "#fee0b6"]; fillOpacity = 0.7; // orange, contrast
  // var colors = ["#7c4937", "#b98352", "#e2be32", "#655d5b"]; // determined
  // var colors = ["#55595f", "#c5af62", "#b18322", "#49290f"]; fillOpacity = 0.4; // light scandinavian
  // var colors = [ "#d67937", "#f0bbdb", "#ffc077", "#955d51"]; fillOpacity = 0.6;  // pink cake
  // var colors = [ "#9b726e", "#e6b7c1", "#7cb2d1", "#593780"]; fillOpacity = 0.6; // fun with blue and purple

  for (var id in json) {
    var data = json[id];
    color = colors[color_mapping[data['cod']] - 1]
    L.polygon(data['contur'], {
      weight: 1,
      color: "#666",
      fillColor: color,
      opacity: 1,
      fillOpacity: fillOpacity
    }).bindPopup('Județul ' + data['nume']).addTo(map);
  }
};

function showCenters(mapLayer, info) {   // Add markers to the map
  var icon;
  var marker;
  for (var key in info) {
    var iconName = `<div class="icon-text-county">`+info[key]['nume']+`</div>`;
    icon = new L.DivIcon({
      className: 'icon-div',
      html: `
        <div class="icon-container">`+iconName+`</div>
        `,
    });

    var marker = L.marker([info[key]['centru']['lat'], info[key]['centru']['lon']],{
      title: info[key]['nume'],
      opacity: 1,
      icon: icon
    }).bindPopup('Județul ' + info[key]['nume']).addTo(mapLayer);
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
