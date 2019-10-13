require 'json'

def intersect?(c1, c2)
  (c1 & c2).length > 0
end

def coordinates(code, contours)
  contours[code]['geometry']['coordinates'][0]
end

def get_neighbours(codes, contours)
  # temporarily return the precomputed result, so I can move forward with the algorythm
  # TODO: remove
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
  # temporarily return the precomputed result, so I can move forward with the algorythm
  # TODO: remove
  return {:segments=>{"AB"=>[[27402..27551, "AR"], [27551..27924, "BH"], [0..9231, "CJ"], [23612..27402, "HD"], [9231..10721, "MS"], [10721..22999, "SB"], [22999..23612, "VL"]], "AR"=>[[0..149, "AB"], [6874..9367, "BH"], [149..1074, "HD"], [1074..5829, "TM"]], "AG"=>[[26454..28807, "BV"], [0..7151, "DB"], [8469..16700, "OT"], [25467..26454, "SB"], [7151..8469, "TR"], [16700..25467, "VL"]], "BC"=>[[7116..8767, "CV"], [8767..12117, "HR"], [12117..18429, "NT"], [0..3841, "VS"], [3841..7116, "VN"]], "BH"=>[[3699..4072, "AB"], [4072..6565, "AR"], [1440..3699, "CJ"], [8427..9351, "SM"], [0..1440, "SJ"]], "BN"=>[[6774..12815, "CJ"], [12815..18335, "MM"], [2473..6774, "MS"], [0..2473, "SV"]], "BT"=>[[0..4370, "IS"], [4370..9199, "SV"]], "BV"=>[[8586..10939, "AG"], [5661..5731, "BZ"], [0..5661, "CV"], [7906..8586, "DB"], [18430..19764, "HR"], [16973..18430, "MS"], [5731..7906, "PH"], [10939..16973, "SB"]], "BR"=>[[1317..2354, "BZ"], [449..615, "CT"], [2427..2874, "GL"], [615..1317, "IL"], [0..449, "TL"], [2354..2427, "VN"]], "B"=>[], "BZ"=>[[9167..9237, "BV"], [0..1037, "BR"], [9237..10682, "CV"], [1037..1736, "IL"], [1736..9167, "PH"], [10682..16592, "VN"]], "CS"=>[[3026..4704, "GJ"], [0..3026, "HD"], [4704..9710, "MH"], [11650..15869, "TM"]], "CL"=>[[0..268, "CT"], [522..1030, "GR"], [2334..4411, "IL"], [1030..2334, "IF"]], "CJ"=>[[8706..17937, "AB"], [17937..20196, "BH"], [0..6041, "BN"], [35783..37205, "MM"], [6041..8706, "MS"], [20196..35783, "SJ"]], "CT"=>[[7403..7569, "BR"], [6862..7130, "CL"], [7130..7403, "IL"], [7569..9353, "TL"]], "CV"=>[[0..1651, "BC"], [4318..9979, "BV"], [2873..4318, "BZ"], [9979..13748, "HR"], [1651..2873, "VN"]], "DB"=>[[9252..16403, "AG"], [16403..17083, "BV"], [6859..8126, "GR"], [6376..6859, "IF"], [0..6376, "PH"], [8126..9252, "TR"]], "DJ"=>[[9579..12965, "GJ"], [6269..9579, "MH"], [3450..5914, "OT"], [0..3450, "VL"]], "GL"=>[[2472..2919, "BR"], [2329..2472, "TL"], [4994..9235, "VS"], [2919..4994, "VN"]], "GR"=>[[1583..2091, "CL"], [6031..7298, "DB"], [0..1583, "IF"], [2298..6031, "TR"]], "GJ"=>[[18435..20113, "CS"], [7566..10952, "DJ"], [20113..25094, "HD"], [10952..18435, "MH"], [0..7566, "VL"]], "HR"=>[[2627..5977, "BC"], [9746..11080, "BV"], [5977..9746, "CV"], [11080..19929, "MS"], [0..2627, "NT"], [19929..22106, "SV"]], "HD"=>[[11609..15399, "AB"], [10684..11609, "AR"], [5564..8590, "CS"], [583..5564, "GJ"], [8590..10684, "TM"], [0..583, "VL"]], "IL"=>[[699..1401, "BR"], [0..699, "BZ"], [1674..3751, "CL"], [1401..1674, "CT"], [3751..4292, "IF"], [4292..4812, "PH"]], "IS"=>[[11773..16143, "BT"], [6343..10471, "NT"], [10471..11773, "SV"], [0..6343, "VS"]], "IF"=>[[541..1845, "CL"], [3428..3911, "DB"], [1845..3428, "GR"], [0..541, "IL"], [3911..5055, "PH"]], "MM"=>[[1136..6656, "BN"], [6656..8078, "CJ"], [11447..22510, "SM"], [8078..11447, "SJ"], [0..1136, "SV"]], "MH"=>[[4056..9062, "CS"], [0..3310, "DJ"], [9062..16545, "GJ"]], "MS"=>[[15916..17406, "AB"], [20071..24372, "BN"], [8849..10306, "BV"], [17406..20071, "CJ"], [0..8849, "HR"], [10306..15916, "SB"], [24372..24947, "SV"]], "NT"=>[[5383..11695, "BC"], [11695..14322, "HR"], [0..4128, "IS"], [14322..17509, "SV"], [4128..5383, "VS"]], "OT"=>[[0..8231, "AG"], [10319..12783, "DJ"], [8231..10077, "TR"], [12783..18894, "VL"]], "PH"=>[[15471..17646, "BV"], [0..7431, "BZ"], [9095..15471, "DB"], [7431..7951, "IL"], [7951..9095, "IF"]], "SM"=>[[15329..16253, "BH"], [0..11063, "MM"], [11063..15329, "SJ"]], "SJ"=>[[15587..17027, "BH"], [0..15587, "CJ"], [21293..24662, "MM"], [17027..21293, "SM"]], "SB"=>[[11412..23690, "AB"], [6034..7021, "AG"], [0..6034, "BV"], [23690..29300, "MS"], [7021..11412, "VL"]], "SV"=>[[12070..14543, "BN"], [0..4829, "BT"], [9318..11495, "HR"], [4829..6131, "IS"], [14543..15679, "MM"], [11495..12070, "MS"], [6131..9318, "NT"]], "TR"=>[[5836..7154, "AG"], [7154..8280, "DB"], [0..3733, "GR"], [3990..5836, "OT"]], "TM"=>[[0..4755, "AR"], [6849..11068, "CS"], [4755..6849, "HD"]], "TL"=>[[1784..2233, "BR"], [0..1784, "CT"], [2233..2376, "GL"]], "VS"=>[[7673..11514, "BC"], [3263..7504, "GL"], [12769..19112, "IS"], [11514..12769, "NT"], [7504..7673, "VN"]], "VL"=>[[26477..27090, "AB"], [0..8767, "AG"], [14878..18328, "DJ"], [18328..25894, "GJ"], [25894..26477, "HD"], [8767..14878, "OT"], [27090..31481, "SB"]], "VN"=>[[9449..12724, "BC"], [2244..2317, "BR"], [2317..8227, "BZ"], [8227..9449, "CV"], [169..2244, "GL"], [0..169, "VS"]]}, :errors=>[]}
  codes = counties.keys
  neighbours = get_neighbours(codes, contours)
  to_separate = codes.map{|code| {code => []}}.reduce(&:merge)
  errors = []
  neighbours.each do |a, b|
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
