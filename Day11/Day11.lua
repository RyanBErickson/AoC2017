
--[[

Day 11: Hex it!  This was hard, until I found the cubical hex grid layout.  Once you have that, it's pretty trivial...

]]

print("Day 11")

-- Read Input...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

-- 'Cube coordinates' for hex grid (https://www.redblobgames.com/grids/hexagons/#distances-cube)
CUBE_MAP = {}
CUBE_MAP.n  = { 0,  1, -1}
CUBE_MAP.ne = { 1,  0, -1}
CUBE_MAP.se = { 1, -1,  0}
CUBE_MAP.s  = { 0, -1,  1}
CUBE_MAP.sw = {-1,  0,  1}
CUBE_MAP.nw = {-1,  1,  0}


function getdist(x,y,z)
  local abs = math.abs
  return (abs(x) + abs(y) + abs(z))/2
end


function Day11(input)
  input = input .. ","

  local x, y, z = 0, 0, 0
  local dist, maxdist = 0, 0

  for direction in input:gmatch("(.-),") do

    local dx, dy, dz = unpack(CUBE_MAP[direction])
    --print("dir: " .. direction .. " dx: " .. dx .. " dy: " .. dy .. " dz: " .. dz)
    x, y, z = x + dx, y + dy, z + dz

    dist = getdist(x,y,z)
    if (dist > maxdist) then maxdist = dist end
  end

  return dist, maxdist
end


assert(Day11("ne,ne,ne") == 3)
assert(Day11("ne,ne,sw,sw") == 0)
assert(Day11("ne,ne,s,s") == 2)
assert(Day11("se,sw,se,sw,sw") == 3)

local dist, max = Day11(INPUT[1])
print("Distance: " .. dist .. " Max Distance: " .. max)

