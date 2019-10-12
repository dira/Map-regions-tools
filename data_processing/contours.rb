require 'json'

counties_info = JSON.parse(File.read(File.join('.', 'data', 'judete-info.json')))
contours_info = JSON.parse(File.read(File.join('.', 'data', 'judete.json')))

counties = counties_info.map{|d| {d['cod_judet'] => d}}.reduce(&:merge)
contours = contours_info['features'].map{|d| {d['properties']['mnemonic'] => d}}.reduce(&:merge)


