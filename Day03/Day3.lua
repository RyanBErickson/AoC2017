
print("Day 3")

-- Solved two different ways.  For part A, solved by filling the array with manhattan distance of next square.
-- It's a repeating pattern.  The code is *really* sloppy.
--
-- For Part B, I filled the array by using Turtle Graphic logic.  I created a blank matrix (mt and mtsum), 
-- filled the first two spots, pointed the turtle East, and used the following turtle logic:
-- If the turtle can go 'left' to it's next move, go 'left'.  If not, go current direction.
-- Fill in the spot with the sum of adjacent 8 squares, tracking the adjacent sums until > puzzle input.
--

PUZZLE_INPUT = 325489

MATRIX_SIZE = 2000

-- Pattern of Manhattan Distance of each 'side' of each concentric box is the same.
--[[
3,2,3,4, 3,2,3,4, 3,2,3,4, 3,2,3,4, (5*5) - (3*3) (16)
5,4,3,4,5,6 5,4,3,4,5,6 5,4,3,4,5,6 5,4,3,4,5,6 (7*7) - (5*5)
7,6,5,4,5,6,7,8, 7,6,5,4,5,6,7,8, 7,6,5,4,5,6,7,8, 7,6,5,4,5,6,7,8, (9*9) - (7*7)
]]

local dist = {}
local tins = table.insert

-- First two loops (single '1', and 3x3 cube) don't follow the pattern...
dist[1] = 0
dist[2] = 1
dist[3] = 2
dist[4] = 1
dist[5] = 2
dist[6] = 1
dist[7] = 2
dist[8] = 1
dist[9] = 2

local index = 10

for level = 3, 1000, 2 do
  local prevsquaresize = (level - 2) * (level - 2)
  local num = level*level - prevsquaresize
  local iternum = num / 8

  local start = level
  local j, arr = 1, {}

  for i = 1, iternum+1 do
    arr[j] = start
    j = j + 1
    start = start - 1
  end
  start = start + 2
  for i = iternum+2, (iternum+1)*2 do
    arr[j] = start
    j = j + 1
    start = start + 1
  end
  for k = 1, 4 do
    for j = 1, #arr do
      dist[index] = arr[j]
      index = index + 1
    end
  end
  
  if (index > PUZZLE_INPUT) then
    break -- short-circuit if we've got the solution...
  end

  -- Debug print Manhattan Distance for current 'side'...
  --[[
  local out = {}
  for j = 1, #arr do
    tins(out, arr[j])
  end
  print(table.concat(out, ","))
  ]]
end

-- Check against examples...
print("1: " .. dist[1])
print("12: " .. dist[12])
print("23: " .. dist[23])
print("81: " .. dist[81])
print("1024: " .. dist[1024])

print("3A Solution: " .. dist[PUZZLE_INPUT])



-- Create empty X/Y matrix to traverse (mt for testing turtle logic, msum to compute sums)...
mt, msum = {}, {}
for i = 1, MATRIX_SIZE do
  mt[i] = {}
  msum[i] = {}
  for j=1, MATRIX_SIZE do
    mt[i][j] = 0
    msum[i][j] = 0
  end
end


function adjacentSum(x, y)
  -- Return anything found in 8 adjacent boxes to msum[x][y]
  local sum = 0
  sum = sum + msum[x-1][y-1]
  sum = sum + msum[x][y-1]
  sum = sum + msum[x+1][y-1]

  sum = sum + msum[x-1][y]
  -- Don't add msum[x][y], even though it's 0...
  sum = sum + msum[x+1][y]

  sum = sum + msum[x-1][y+1]
  sum = sum + msum[x][y+1]
  sum = sum + msum[x+1][y+1]
  return sum
end


-- up = cury-1, down = cury+1, left = curx-1, right = curx+1

-- Defines the Turtle movement, if initial direction, x, y
function Movement(direction, curx, cury)
  if (direction == 'E') then -- Look up
    if (mt[curx][cury-1] == 0) then
      return 'N', curx, cury-1
    end
    return 'E', curx+1, cury
  end
  if (direction == 'N') then -- Look left
    if (mt[curx-1][cury] == 0) then
      return 'W', curx-1, cury
    end
    return 'N', curx, cury-1
  end
  if (direction == 'W') then -- Look down
    if (mt[curx][cury+1] == 0) then
      return 'S', curx, cury+1
    end
    return 'W', curx-1, cury
  end
  if (direction == 'S') then -- Look right
    if (mt[curx+1][cury] == 0) then
      return 'E', curx+1, cury
    end
    return 'S', curx, cury+1
  end
end


-- Set initial 'center' value of 1
local curx, cury = MATRIX_SIZE / 2, MATRIX_SIZE / 2
mt[curx][cury] = 1
msum[curx][cury] = 1

-- Make one East movement (otherwise turtle will go up, since 'left' from inital position is empty)...
direction = "E"
curx = curx + 1
mt[curx][cury] = 2
msum[curx][cury] = 1

-- Spiral turtle to fill two-dimensional array
i = 3
local done = false
while (i < 100 and not done) do
  direction, curx, cury = Movement(direction, curx, cury)
  mt[curx][cury] = i
  local adjSum = adjacentSum(curx, cury)
  msum[curx][cury] = adjSum
  if (adjSum > PUZZLE_INPUT) then
    print("3B Solution: " .. adjSum)
    done = true
  end
  i = i + 1
end

--debug show 993-1007, where solution was found...
--[[
for y = 993, 1007 do
  local out = {}
  for x = 993, 1007 do
    tins(out, msum[x][y] .. string.rep(' ', 7-string.len(tostring(mt[x][y]))) )
  end
  print(table.concat(out, " "))
end
]]

