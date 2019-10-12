require 'json'

def intersect?(c1, c2)
  (c1 & c2).length > 0
end

def coordinates(code, contours)
  contours[code]['geometry']['coordinates'][0]
end

def get_neighbours(codes, contours)
  # return the precomputed result
  return [
    ["AB", "AR"], ["AB", "BH"], ["AB", "CJ"], ["AB", "HD"], ["AB", "MS"], ["AB", "SB"], ["AB", "VL"], ["AR", "BH"], ["AR", "HD"], ["AR", "TM"], ["AG", "BV"], ["AG", "DB"], ["AG", "OT"], ["AG", "SB"], ["AG", "TR"], ["AG", "VL"], ["BC", "CV"], ["BC", "HR"], ["BC", "NT"], ["BC", "VS"], ["BC", "VN"], ["BH", "CJ"], ["BH", "SM"], ["BH", "SJ"], ["BN", "CJ"], ["BN", "MM"], ["BN", "MS"], ["BN", "SV"], ["BT", "IS"], ["BT", "SV"], ["BV", "BZ"], ["BV", "CV"], ["BV", "DB"], ["BV", "HR"], ["BV", "MS"], ["BV", "PH"], ["BV", "SB"], ["BR", "BZ"], ["BR", "CT"], ["BR", "GL"], ["BR", "IL"], ["BR", "TL"], ["BR", "VN"], ["BZ", "CV"], ["BZ", "IL"], ["BZ", "PH"], ["BZ", "VN"], ["CS", "GJ"], ["CS", "HD"], ["CS", "MH"], ["CS", "TM"], ["CL", "CT"], ["CL", "GR"], ["CL", "IL"], ["CL", "IF"], ["CJ", "MM"], ["CJ", "MS"], ["CJ", "SJ"], ["CT", "IL"], ["CT", "TL"], ["CV", "HR"], ["CV", "VN"], ["DB", "GR"], ["DB", "IF"], ["DB", "PH"], ["DB", "TR"], ["DJ", "GJ"], ["DJ", "MH"], ["DJ", "OT"], ["DJ", "VL"], ["GL", "TL"], ["GL", "VS"], ["GL", "VN"], ["GR", "IF"], ["GR", "TR"], ["GJ", "HD"], ["GJ", "MH"], ["GJ", "VL"], ["HR", "MS"], ["HR", "NT"], ["HR", "SV"], ["HD", "TM"], ["HD", "VL"], ["IL", "IF"], ["IL", "PH"], ["IS", "NT"], ["IS", "SV"], ["IS", "VS"], ["IF", "PH"], ["MM", "SM"], ["MM", "SJ"], ["MM", "SV"], ["MS", "SB"], ["MS", "SV"], ["NT", "SV"], ["NT", "VS"], ["OT", "TR"], ["OT", "VL"], ["SM", "SJ"], ["SB", "VL"], ["VS", "VN"]
  ]

  neighbours = []
  codes.each_with_index do |code1, index1|
    (index1+1..codes.length-1).each do |index2|
      code2 = codes[index2]
      neighbours << [code1, code2] if intersect?(coordinates(code1, contours), coordinates(code2, contours))
    end
  end
  neighbours
end

def consecutive?(array, replace_0_with)
  faults = []
  array.sort!
  array.each_with_index do |value, index|
    next unless index > 0 && index < array.length
    next if array[index-1] == array[index] - 1
    faults << {index-1 => array[index-1], index => array[index] }
  end

  return true if faults.length == 0
  p 'faults', faults
  return false if faults.length > 1
  if faults[0].keys.include?(0) && faults[0][0] = 0
    array[0] = replace_0_with
    consecutive?(array, -2)
  else
    false
  end
end

def check_intersection c1, c2
  values = c1 & c2
  indexes1 = values.map{|value| c1.index(value)}
  indexes2 = values.map{|value| c2.index(value)}

  return nil unless consecutive?(indexes1, c1.length-1)
  return nil unless consecutive?(indexes2, c2.length-1)

  [indexes1.first..indexes1.last, indexes2.first..indexes2.last]
end

def get_common_segments(counties, contours)
  codes = counties.keys
  neighbours = get_neighbours(codes, contours)
  to_separate = codes.map{|code| {code => []}}.reduce(&:merge)
  errors = []
  neighbours.each do |a, b|
    p "#{a} #{b}"

    if (intersection = check_intersection(coordinates(a, contours), coordinates(b, contours)))
      to_separate[a] << [intersection[0], b]
      to_separate[b] << [intersection[1], a]
    else
      errors << [a, b]
    end
  end

  {
    segments: to_separate,
    errors: errors,
  }
end

counties_info = JSON.parse(File.read(File.join('.', 'data', 'judete-info.json')))
contours_info = JSON.parse(File.read(File.join('.', 'data', 'judete.json')))

counties = counties_info.map{|d| {d['cod_judet'] => d}}.reduce(&:merge)
contours = contours_info['features'].map{|d| {d['properties']['mnemonic'] => d}}.reduce(&:merge)

p get_common_segments(counties, contours)
