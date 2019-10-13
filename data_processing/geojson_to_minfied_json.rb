require 'json'

geojson = JSON.parse(File.read(File.join('.', ARGV[0])))

data = geojson['features'].map do |feature|
  {
    feature['properties']['mnemonic'] => [
      [feature['properties']['name'], feature['properties']['regionId']],
      feature['geometry']['coordinates'][0].map(&:reverse)
    ]
  }
end
data = data.reduce &:merge
puts data.to_json