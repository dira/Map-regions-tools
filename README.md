# Map-regions-tools

## Goal

This project was caused by the need to draw the edges of the counties of Romania on a web map (Leaflet on OpenStreetMap / Mapbox). For that the only open data source I found is the [poligon county limits](http://www.geo-spatial.org/download/romania-seturi-vectoriale), which is extremely detailed, including about 25K points per county. 
Which is great, but quite heavy to load through the internet (11MB) and to render on a dynamic map.

So here comes the first need: create sets of data that allow rendering Romania's counties with less precision, but a lot greater flexibility. Ideal: about 30 points per county.


Another need was to find the place were it would be optimal, from the user's point of view, to place a label on a county. For this, one solution would be to compute the geometrical center of the polygon.

## Run the project

You need a local web server to run the project. I already had PHP on my machine, so I ran
    Map-regions-tools$ cd web
    Map-regions-tools$ php -S localhost:8080
in the `web` subfolder, and saw the results in the browser at [localhost:8080](http://localhost:8080/)


### Screenshots

Simplified (112K):

![simplified (112K)](https://dira-web-resources.s3.eu-central-1.amazonaws.com/github-dira/map-regions-tools/2019-10-13T19.48.25-romania-counties.jpg)

Full data (11MB):

![full data (11MB)](https://dira-web-resources.s3.eu-central-1.amazonaws.com/github-dira/map-regions-tools/2019-10-12T19.26.11-romania-counties.jpg)

## Status

Simplify counties - done

Determine county center - done
* wrote the `getPolygonCenter` function
* saved the results in the `judete-info.json` file

Other features
* geometrical center shown as a county name label
* county capital shown as a less visually appealing circle, on click you see the city name
* country regions are assigned a color (in such a way as all neighbouring regions have different color)
* counties colored in different shades of region's color

# Credits

Contour segment simplification: [SimplifyRb](https://github.com/odlp/simplify_rb), a Ruby port of [simplify.js](https://github.com/mourner/simplify-js) by Vladimir Agafonkin

Overall data processing: thanks to [Rodica Pintea](https://www.linkedin.com/in/rodica-pintea-20333b53), my highschool computer science teacher, that ispired me to love algorithms and programming

Thanks to DigitalOcean, for organizing [HacktoberFEST](https://hacktoberfest.digitalocean.com/profile), which gave me the extra push to do science for good.