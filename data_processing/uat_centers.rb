require 'JSON'
require 'bigdecimal'
require 'csv'

def get_center(coordinates)
  n = coordinates.length
  cx = BigDecimal(0)
  cy = BigDecimal(0)
  a = BigDecimal(0)
  coordinates.each_with_index do |elem, i|
    next if i == n-1
    
    next_elem = coordinates[i+1]
    t = elem[0] * next_elem[1] - next_elem[0] * elem[1];
    cx += (elem[0] + next_elem[0]) * t;
    cy += (elem[1] + next_elem[1]) * t;
    a += t;
  end
  a = a / 2;

  [cx/6/a, cy/6/a]
end


by_county = {}
JSON.parse(File.read(File.join('.', ARGV[0])))['features'].each do |feature|
  properties = feature['properties']
  county = properties['countyMn']
  by_county[county] ||= []

  coordinates = feature['geometry'] ? feature['geometry']['coordinates'] : nil
  data = { 
    natcode: properties['natcode'], 
    name: properties['name'],
    center: '',
  }
  if coordinates && coordinates[0]
    coordinates = coordinates[0]
    # for some reason, many entries have the coordinates array nested one more time
    coordinates = coordinates[0] if coordinates[0][0].is_a?(Array) 
    center = get_center coordinates
    data[:center] = "#{center[1].round(4).to_f}, #{center[0].round(4).to_f}"
  else
    p "missing #{data}"
  end
  by_county[county] << data
end
CSV.open('uats.csv', 'w') do |csv|
  csv << ['county', 'natcode', 'name', 'center']
  by_county.each do |county, values|
    values.each do |v|
      csv << [county, v[:natcode], v[:name], v[:center]]
    end
  end
end