require 'JSON'

# common contours file
data = JSON.parse(File.read(File.join('.', ARGV[0])))
counties = data.keys.sort
puts counties.to_json

counties.each do |county|
  values = counties.map{ |county2| data[county].map(&:last).include?(county2) ? 1 : 0 }
  puts "{#{values.join ','}},"
end

# Process the output with the algorithm: https://repl.it/repls/ShorttermSimultaneousCgi
# Got the result:
colors = [1, 1, 2, 1, 1, 3, 1, 1, 2, 3, 2, 2, 1, 1, 2, 4, 2, 1, 2, 4, 3, 3, 2, 4, 3, 1, 3, 4, 4, 4, 2, 1, 2, 1, 2, 3, 3, 4, 4, 4, 3, 2]

puts Hash[counties.zip(colors)].to_json

# Got the result
coloring = {"AB":1,"AG":1,"AR":2,"B":1,"BC":1,"BH":3,"BN":1,"BR":1,"BT":2,"BV":3,"BZ":2,"CJ":2,"CL":1,"CS":1,"CT":2,"CV":4,"DB":2,"DJ":1,"GJ":2,"GL":4,"GR":3,"HD":3,"HR":2,"IF":4,"IL":3,"IS":1,"MH":3,"MM":4,"MS":4,"NT":4,"OT":2,"PH":1,"SB":2,"SJ":1,"SM":2,"SV":3,"TL":3,"TM":4,"TR":4,"VL":4,"VN":3,"VS":2}