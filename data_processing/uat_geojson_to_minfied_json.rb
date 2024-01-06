require 'json'

geojson = JSON.parse(File.read(File.join('.', ARGV[0])))

def map_polygon(coordinates)
  coordinates.map do |shape|
    shape.map do |a|
      a.reverse
    end
  end 
end

def map_coordinates(geometry)
  unless geometry
    return
  end
  if geometry['type'] == 'Polygon' 
    map_polygon geometry['coordinates']
  elsif geometry['type'] == 'MultiPolygon'
    geometry['coordinates'].map{|c| map_polygon c }
  else
    
  end
end

data = geojson['features'].map do |feature|
    properties = feature['properties']
    coordinates = map_coordinates(feature['geometry'])
    { properties['natcode'] =>
      [	
	[properties['natLevName'], properties['name'], properties['county']],
	coordinates
      ]
    }
end
data = data.reduce &:merge
puts data.to_json
