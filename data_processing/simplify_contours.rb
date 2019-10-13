require 'json'
require 'simplify_rb'
def simplify(points, tolerance, high_quality)
  data = points.map{|x, y| {x: x, y: y}}  
  simplified = SimplifyRb::Simplifier.new.process(data, tolerance, high_quality)
  simplified.map{|h| [h[:x], h[:y]]}
end

common_contours = JSON.parse(File.read(File.join('.', 'data', 'common-contours.json')))
common_contours.each do |code, contours| 
  contours.each_with_index do |c, i| 
    # transform the Range stringified by the JSON export, into a proper ruby range.
    # i.e. from "22999..23612" to (22999,23612)
    contours[i][0] = Range.new(* c[0].split('..').map(&:to_i))
  end
end

contours_info = JSON.parse(File.read(File.join('.', 'data', 'judete.json')))
contours = contours_info['features'].map{|d| {d['properties']['mnemonic'] => d}}.reduce(&:merge)

tolerance = 0.5
high_quality = false

simplified_coordinates = {}
contours.each do |code, value|
  polygon = contours[code]['geometry']['coordinates'][0]; polygon.length
  simplified_contours = common_contours[code].map do |range, neighbour_code|
    simplify(polygon[range], tolerance, high_quality)
  end

  simplified_coordinates[code] = simplified_contours.reduce([]){|acc, v| acc += v[0..-2]}
end

contours_info['features'].each do |data|
  code = data['properties']['mnemonic']
  s = if simplified_coordinates[code].length == 0
    # Hello Bucharest. Simplify the whole polygon
    simplify(data['geometry']['coordinates'][0], tolerance, high_quality)
  else
    simplified_coordinates[code]
  end
  data['geometry']['coordinates'][0] = s
end

puts contours_info.to_json