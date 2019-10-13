require 'json'

def coordinates(code, contours)
  contours[code]['geometry']['coordinates'][0]
end

def get_neighbours(contours)
  neighbours = []
  codes = contours.keys
  codes.each_with_index do |code1, index1|
    (index1+1..codes.length-1).each do |index2|
      code2 = codes[index2]
      in_common = coordinates(code1, contours) & coordinates(code2, contours)
      neighbours << [code1, code2]  if in_common.length > 0
    end
  end
  neighbours
end

def get_faults_in_continuousness(array)
  faults = []
  array.sort!
  array.each_with_index do |value, index|
    next unless index > 0 && index < array.length
    next if array[index-1] == array[index] - 1
    faults << {index-1 => array[index-1], index => array[index] }
  end
  faults
end

def get_indexes_as_range(values, from)
  indexes = values.map{|value| from.index(value)}
  faults = get_faults_in_continuousness(indexes)
  return indexes if faults.length == 0
  return nil if faults.length > 1 # nothing we can do

  # since the first value is also the last, maybe we can shift things?
  if faults[0].keys.include?(0) && faults[0][0] = 0
    indexes[0] = from.length - 1
    faults = get_faults_in_continuousness(indexes)
    return indexes if faults.length == 0
  end
  nil
end

def get_intersection_indexes c1, c2
  values = c1 & c2
  indexes1 = get_indexes_as_range(values, c1)
  indexes2 = get_indexes_as_range(values, c2)
  return nil if indexes1 == nil || indexes2 == nil

  [indexes1.first..indexes1.last, indexes2.first..indexes2.last]
end

def get_common_segments(contours)
  codes = contours.keys
  segments = codes.map{|code| {code => []}}.reduce(&:merge)
  errors = []
  get_neighbours(contours).each do |c1, c2|
    if (indexes = get_intersection_indexes(coordinates(c1, contours), coordinates(c2, contours)))
      segments[c1] << [indexes[0], c2]
      segments[c2] << [indexes[1], c1]
    else
      errors << [c1, c2]
    end
  end
  segments.each do |code, s|
    s.sort!{|s1, s2| s1[0].first <=> s2[0].first }
  end

  {
    segments: segments,
    errors: errors,
  }
end

contours_info = JSON.parse(File.read(ARGV[0]))
contours = contours_info['features'].map{|d| {d['properties']['mnemonic'] => d}}.reduce(&:merge)
segments = get_common_segments(contours)
STDERR.puts "errors #{segments[:errors]}" if segments[:errors].length > 0
puts segments[:segments].to_json
