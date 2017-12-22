
--[[

Day 22: The Virus is coming...

]]


print("---------------- Day 22 ----------------")


--[[

-- Prints out grid, for debug purposes during development

function printgrid(grid, min, max)
  min = min or 0
  max = max or 0
  local out, tins = {}, table.insert
  for row = min, max do
    local outrow = {}
    grid[row] = grid[row] or {}
    for col = min, max do
      tins(outrow, (grid[row][col] or '.'))
    end
    tins(out, table.concat(outrow))
  end
  print(table.concat(out, '\n'))
end
]]


RIGHT =  {U = 'R', R = 'D', D = 'L', L = 'U'} -- New direction on turning Right
LEFT =   {U = 'L', R = 'U', D = 'R', L = 'D'} -- New direction on turning Left
REV =    {U = 'D', R = 'L', D = 'U', L = 'R'} -- New direction on reverse (Part B)

OFFSET = {U = {x = 0, y = -1}, R = {x = 1, y = 0}, L = {x = -1, y = 0}, D = {x = 0, y = 1}} -- x,y offsets by direction
INFECTED, NOT_INFECTED = 1, 0


function PartA(val, dir)
  if (val == '#') then
    return '.', RIGHT[dir], NOT_INFECTED
  elseif (val == '.') then
    return '#', LEFT[dir], INFECTED
  end
end


function PartB(val, dir)
  if (val == '#') then
    return 'F', RIGHT[dir], NOT_INFECTED
  elseif (val == '.') then
    return 'W', LEFT[dir], NOT_INFECTED
  elseif (val == 'W') then
    return '#', dir, INFECTED
  elseif (val == 'F') then
    return '.', REV[dir], NOT_INFECTED
  end
end


function Day22(input, eval, bursts)

  local grid = {}
  local col, row = 0, 0

  -- Read Input into grid...
  for _, line in pairs(input) do
    grid[row] = {}
    col = 0
    for c in line:gfind('(.)') do
      grid[row][col] = c
      col = col + 1
    end
    row = row + 1
  end

  -- Find starting (center) location...
  local center = math.floor(row / 2)
  local x, y = center, center
  local dir = 'U'
  local num, infection = 0

  -- Run X bursts...
  for burst = 1, bursts do
    -- Ensure value exists at x,y...
    grid[y] = grid[y] or {}
    grid[y][x] = grid[y][x] or '.'

    -- Get new value, direction, infection
    grid[y][x], dir, infection = eval(grid[y][x], dir)
    num = num + infection
    
    -- Move to new location
    x, y = x + OFFSET[dir].x, y + OFFSET[dir].y
  end

  return num
end


-- Read Inputs...
TEST = {}
table.insert(TEST, "..#")
table.insert(TEST, "#..")
table.insert(TEST, "...")

INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


-- Test PartA assertions
assert(Day22(TEST, PartA, 70) == 41)
assert(Day22(TEST, PartA, 10000) == 5587)

print("Part A Infections: " .. Day22(INPUT, PartA, 10000))

-- Test PartB assertions
assert(Day22(TEST, PartB, 100) == 26)
assert(Day22(TEST, PartB, 10000000) == 2511944)

print("Part B Infections: " .. Day22(INPUT, PartB, 10000000))

