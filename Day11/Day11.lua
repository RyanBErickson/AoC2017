
--[[

Day 11: Hex it!  This was hard, until I found the cubical hex grid layout.  Once you have that, it's pretty trivial...

]]

print("Day 11")

-- Read Input...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

-- 'cubical' hex grid layout
CUBE_MAP = {}
CUBE_MAP.n  = { 0,  1, -1}
CUBE_MAP.ne = { 1,  0, -1}
CUBE_MAP.se = { 1, -1,  0}
CUBE_MAP.s  = { 0, -1,  1}
CUBE_MAP.sw = {-1,  0,  1}
CUBE_MAP.nw = {-1,  1,  0}


function Day11a(input)
  print(input)
  input = input .. ","

  local x, y, z = 0, 0, 0
  local maxdist = 0

  for direction in input:gmatch("(.-),") do

    local map = CUBE_MAP[direction]

    --print("dir: " .. direction .. " dx: " .. map[1] .. " dy: " .. map[2] .. " dz: " .. map[3])

    x = x + map[1]
    y = y + map[2]
    z = z + map[3]

    local dist = (math.abs(x) + math.abs(y) + math.abs(z))/2
    if (dist > maxdist) then maxdist = dist end
  end

  print("x: " .. x .. " y: " .. y .. " z: " .. z)
  print("distance: " .. (math.abs(x) + math.abs(y) + math.abs(z))/2)
  print("max distance: " .. maxdist)
end


TESTDATA = {}
table.insert(TESTDATA, {["ne,ne,ne"] = 3})
table.insert(TESTDATA, {["ne,ne,sw,sw"] = 0})
table.insert(TESTDATA, {["ne,ne,s,s"] = 2})
table.insert(TESTDATA, {["se,sw,se,sw,sw"] = 3})

--Day11a(next(TESTDATA[4]))
Day11a(INPUT[1])

