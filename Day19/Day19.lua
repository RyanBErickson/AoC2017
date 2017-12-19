
--[[

Day 19: Maze.  Simple Part2...  Hardest part of this might have been capturing the input...

That, and missing the 'elseif' on the direction change, which threw me for 10+ minutes... Duh!

]]


print("Day 19")


function Day19(input)
  local tins = table.insert
  maze = {}

  -- Generate maze array...
  for _, line in pairs(input) do
    local mazeline = {}
    for c in line:gfind('(.)') do
      tins(mazeline, c)
    end
    tins(maze, mazeline)
  end

  -- Find start position...
  local y = 1
  for x = 1, #maze[y] do
    if (maze[y][x] == '|') then
      startx, starty = x, y
      break
    end
  end

  -- Go in same direction until you hit a '+'...
  local x, y, cur = startx, starty
  local dx, dy = 0, 1 -- down

  local out = {}
  local steps = 1
  while (not done) do
    x, y = x+dx, y+dy
    cur = maze[y][x]
    steps = steps + 1

    --print("x: " .. x .. " y: " .. y .. " cur: " .. cur)

    -- Not path...
    if ((cur ~= '|') and (cur ~= '-') and (cur ~= '+')) then

      -- Done if you go 'off' (hit a space)
      if (cur == ' ') then
        print("Answer: " .. table.concat(out, ''))
        print("#Steps: " .. steps-1) -- Don't count the space...
        return
      end

      -- Not a |,-,+,' ', so must be a letter, add to output...
      tins(out, cur)
    end

    -- Change directions on '+', can only switch from horizontal to vertical and vice-versa...
    if (cur == '+') then
      if (dx ~= 0) then
        if (maze[y+1] and ((maze[y+1][x] or ' ') ~= ' ')) then
          dx, dy = 0, 1
        else
          dx, dy = 0, -1
        end
      elseif (dy ~= 0) then
        if (maze[y][x+1] and ((maze[y][x+1] or ' ') ~= ' ')) then
          dx, dy = 1, 0
        else
          dx, dy = -1, 0
        end
      end
    end
  end
end


print('--------------TEST--------------')
TESTDATA = {}
for line in io.lines("testdata") do
  table.insert(TESTDATA, line)
end
Day19(TESTDATA)

print('--------------INPUT--------------')
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
Day19(INPUT)

