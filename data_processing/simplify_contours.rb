require 'json'
require 'simplify_rb'
def simplify(points, tolerance, high_quality, precision)
  data = points.map{|x, y| {x: x, y: y}}  
  simplified = SimplifyRb::Simplifier.new.process(data, tolerance, high_quality)
  simplified.map{|h| [h[:x].round(precision), h[:y].round(precision)]}
end

contours_info = JSON.parse(File.read(ARGV[0]))
contours = contours_info['features'].map{|d| {d['properties']['mnemonic'] => d}}.reduce(&:merge)

common_contours = JSON.parse(File.read(ARGV[1]))
common_contours.each do |code, contours| 
  contours.each_with_index do |c, i| 
    # transform the Range stringified by the JSON export, into a proper ruby range.
    # i.e. from "22999..23612" to (22999,23612)
    contours[i][0] = Range.new(* c[0].split('..').map(&:to_i))
  end
end

tolerance = 0.025
# be more precise around the borders, as they are displayed
# by the map as well, and it looks disturbing to have
# a visually diferent region border
border_tolerance = tolerance * 0.3
high_quality = false
precision = 3 # decimals after the dot, for lat and lng

cache = {}
simplified_coordinates = {}
contours.each do |code, value|
  polygon = contours[code]['geometry']['coordinates'][0]; polygon.length

  pointer = 0
  simplified_contours = []
  common_contours[code].each do |range, neighbour_code|
    if pointer != range.first
      simplified_contours << simplify(polygon[(pointer..range.first)], border_tolerance, high_quality, precision)
    end
    cache_key = "#{neighbour_code}_#{code}"
    if cache[cache_key]
      simplification = cache[cache_key]
      neighbour_polygon = contours[neighbour_code]['geometry']['coordinates'][0]
      neighbour_range = common_contours[neighbour_code].detect{|v| v[1] == code}[0]
      if polygon[range] == neighbour_polygon[neighbour_range]
        simplified_contours << simplification
      else
        simplified_contours << simplification.reverse
      end
    else
      simplification = simplify(polygon[range], tolerance, high_quality, precision)
      cache["#{code}_#{neighbour_code}"] = simplification
      simplified_contours << simplification
    end
    pointer = range.last
  end
  if pointer != polygon.length - 1
    simplified_contours << simplify(polygon[(pointer..polygon.length)], border_tolerance, high_quality, precision)
  end

  unified_contours = []
  simplified_contours.each do |contour|
    unified_contours += contour[(contour[0] == unified_contours.last ? 1 : 0)..-1]
  end

  simplified_coordinates[code] = unified_contours
end

contours_info['features'].each do |data|
  code = data['properties']['mnemonic']
  s = if simplified_coordinates[code].length == 0
    # Hello Bucharest. Simplify the whole polygon
    simplify(data['geometry']['coordinates'][0], tolerance, high_quality, precision)
  else
    simplified_coordinates[code]
  end
  data['geometry']['coordinates'][0] = s
end

puts contours_info.to_json