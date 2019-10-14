# Map-regions-tools

## Goal

This project was caused by the need to draw the edges of the counties of Romania on a web map (Leaflet on OpenStreetMap / Mapbox). For that the only open data source I found is the [poligon county limits](http://www.geo-spatial.org/download/romania-seturi-vectoriale), which is extremely detailed, including about 25K points per county. 
Which is great, but quite heavy to load through the internet (11MB) and to render on a dynamic map.

So here comes the first need: create sets of data that allow rendering Romania's counties with less precision, but a lot greater flexibility. Ideal: about 30 points per county.

Another need was to find the place were it would be optimal, from the user's point of view, to place a label on a county. For this, one solution would be to compute the geometrical center of the polygon. (Later I found out that, 
having the polygon shape, you can use Leaflet for this, so no need for math :/)

## View samples

See simplified GeoJSON in the [data_processing/results](https://github.com/dira/Map-regions-tools/tree/master/data_processing/results) folder.

## View the rendered map (with colors <3)

You need a local web server to run the project. I already had PHP on my machine, so I ran
    Map-regions-tools$ cd web
    Map-regions-tools$ php -S localhost:8080
in the `web` subfolder, and saw the results in the browser at [localhost:8080](http://localhost:8080/)

## Simplify contours

    $ cd data_processing

Step 1: from full contours, get information about which contour parts overlap between counties. On my machine, it took around 30 minutes:

    $ ruby find_common_contours.rb data/contours-full.geojson  > data/common-contours.json

The resulting information is a JSON serialized hash (keys: county codes, values: arrays(first position: an index range, second position: the neighbour county code))

 Step2: from full contours, and the information about borders between counties, generate a GeoJSON with simplifed contours:

    $ ruby simplify_contours.rb data/contours-full.geojson data/common-contours.json > data/contours-simplified.geojson

You can play with the parameters (tolerance, border_tolerance, high_quality, precision) to tweak the result to lower or higher fidelity.

Optional: Step3: from the simplified GeoJSON, generate a basic JSON (that is a lot smaller, and is used in the web app):

    $ ruby geojson_to_minified_json.rb data/contours-simplified.geojson > data/contours-simplified.json

### Screenshots

Simplified contours, raw JSON (31K):

![simplified, raw json (31K)](https://dira-web-resources.s3.eu-central-1.amazonaws.com/github-dira/map-regions-tools/2019-10-13T22.11.52-romania-counties.jpg)

Simplified contours GeoJSON (112K):

![simplified GeoJSON (112K)](https://dira-web-resources.s3.eu-central-1.amazonaws.com/github-dira/map-regions-tools/2019-10-13T19.48.25-romania-counties.jpg)

Original GeoJSON (11MB):

![original GeoJSON (11MB)](https://dira-web-resources.s3.eu-central-1.amazonaws.com/github-dira/map-regions-tools/2019-10-12T19.26.11-romania-counties.jpg)

## Status

Simplify counties - done
- and saved data for a conveninent simplification tolerance and floating point precision

Determine county center - done (and removed; it's implemented in Leaflet.js)

Other features
* geometrical center shown as a county name label
* county capital shown as a less visually appealing circle, on click you see the city name
* country regions are assigned a color (in such a way as all neighbouring regions have different color)
* counties colored in different shades of region's color

# Credits

Contour segment simplification: [SimplifyRb](https://github.com/odlp/simplify_rb), a Ruby port of [simplify.js](https://github.com/mourner/simplify-js) by Vladimir Agafonkin

Overall data processing: thanks to [Rodica Pintea](https://www.linkedin.com/in/rodica-pintea-20333b53), my highschool computer science teacher, that ispired me to love algorithms and programming

Thanks to DigitalOcean, for organizing [HacktoberFEST](https://hacktoberfest.digitalocean.com/profile), which gave me the extra push to do science for good.