# Map-regions-tools

## Goal

This project was caused by the need to draw the edges of the counties of Romania on a web map (Leaflet on OpenStreetMap / Mapbox). For that the only open data source I found is the [poligon county limits](http://www.geo-spatial.org/download/romania-seturi-vectoriale), which is extremely detailed, including about 25K points per county. 
Which is great, but quite heavy to load through the internet (11MB) and to render on a dynamic map.

So here comes the first need: create sets of data that allow rendering Romania's counties with less precision, but a lot greater flexibility. Ideal: about 30 points per county.


Another need was to find the place were it would be optimal, from the user's point of view, to place a label on a county. For this, one solution would be to compute the geometrical center of the polygon.

## Run the project

You need a local web server to run the project. I already had PHP on my machine, so I ran
    > php -S localhost:8080
in the project folder, and saw the results in the browser at [localhost:8080](http://localhost:8080/)


## Status

Simplify counties - WIP

Determine county center - done
* wrote the `getPolygonCenter` function
* saved the results in the `judete-info.json` file

Other features
* geometrical center shown as a marker, labeled with the city name
* county capital shown as a less visually appealing circle, on click you see the city name
* counties colored the region they belong to