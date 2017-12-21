
--[[

Day 21: It's a grind...  At least Part 2 is easy...

]]


print("Day 21")


-- expand 'short notation' form into a row/col table...
function expand(s)
  local out, tins = {}, table.insert
  for row in (s .. '/'):gfind('(.-)/') do
    local rowdata = {}
    for c in row:gfind('(.)') do
      tins(rowdata, c)
    end
    tins(out, rowdata)
  end
  return out
end


-- compress row/col table into 'short notation' form...
function compress(t)
  local out, tins = {}, table.insert
  local count = 0
  for _, row in pairs(t) do
    local rowout = {}
    for _, c in pairs(row) do
      tins(rowout, c)
    end
    tins(out, table.concat(rowout))
    count = count + 1
  end
  return table.concat(out, '/')
end


-- Rotate Lua table
local rotateTable = function(tb)
  local rotatedTable = {}
  for i=1,#tb[1] do
    rotatedTable[i] = {}
    local cellNo = 0;
    for j=#tb,1,-1 do
      cellNo = cellNo + 1;
      rotatedTable[i][cellNo] = tb[j][i]
    end
  end
  return rotatedTable
end


-- Rotate pattern count times...
function rotate(s, count)
  local t = expand(s)
  for i = 1, count do
    t = rotateTable(t)
  end
  return compress(t)
end


-- Flip pattern vertically (left-right)...
function flipvert(s)
  local _, _, one, two, three = s:find('(.+)/(.+)/(.+)')
  if (one == nil) then
    local _, _, one, two = s:find('(.+)/(.+)')
    return string.reverse(one) .. '/' ..  string.reverse(two)
  else
    return string.reverse(one) .. '/' ..  string.reverse(two) .. '/' ..  string.reverse(three)
  end
end


-- Flip pattern horizontally (top-bottom)...
function fliphoriz(s)
  local _, _, one, two, three = s:find('(.+)/(.+)/(.+)')
  if (one == nil) then
    local _, _, one, two = s:find('(.+)/(.+)')
    return two .. '/' .. one
  else
    return three .. '/' .. two .. '/' .. one
  end
end


function Day21(input, iterations)

  -- Read rules input...  Rotate and flip each pattern for all possibilities...
  -- Transformation rules are indexed by the original 'short-form' pattern...
  local rules = {}
  for _, line in pairs(input) do
    local _, _, pat, repl = line:find('(.-) => (.+)')
    for i = 0, 3 do
      local rot = rotate(pat, i)
      rules[rot] = repl
      rules[flipvert(rot)] = repl
      rules[fliphoriz(rot)] = repl
    end
  end

  local art = expand(".#./..#/###")

  for i = 1, iterations do
    print("iteration: " .. i .. " of " .. iterations)

    local size = #art[1]
    local out = {}
    if (size % 2 == 0) then
      -- Divide into 3-sized sides...
      for row = 0, (size/2 - 1) do
        for col = 0, (size/2 - 1) do

          -- Get 'short-form' pattern version of array slice to search for rule...
          local slice = compress({
            {art[row*2+1][col*2+1], art[row*2+1][col*2+2]},
            {art[row*2+2][col*2+1], art[row*2+2][col*2+2]}})

          -- Look for transform rule...
          local rule = rules[slice]
          if (rule) then
            local tab = expand(rule)
            for r = 1, 3 do
              local rw = row*3+r
              out[rw] = out[rw] or {}
              for c = 1, 3 do
                out[rw][col*3+c] = tab[r][c]
              end
            end
          else
            print("----------No Rule Found------------")
          end
        end
      end
    elseif (size % 3 == 0) then
      -- Divide into 3-sized sides...
      for row = 0, (size/3 - 1) do
        for col = 0, (size/3 - 1) do

          -- Get 'short-form' pattern version of array slice to search for rule...
          local slice = compress({
            {art[row*3+1][col*3+1], art[row*3+1][col*3+2], art[row*3+1][col*3+3]},
            {art[row*3+2][col*3+1], art[row*3+2][col*3+2], art[row*3+2][col*3+3]},
            {art[row*3+3][col*3+1], art[row*3+3][col*3+2], art[row*3+3][col*3+3]}})

          -- Look for transform rule...
          local rule = rules[slice]
          if (rule) then
            local tab = expand(rule)
            for r = 1, 4 do
              local rw = row*4+r
              out[rw] = out[rw] or {}
              for c = 1, 4 do
                out[rw][col*4+c] = tab[r][c]
              end
            end
          else
            print("----------No Rule Found------------")
          end
        end
      end
    end
    art = out
  end

  art = compress(art)

  -- Search for the number of # in output...
  local count = 0
  for c in art:gfind('(.)') do
    if (c == '#') then
      count = count + 1
    end
  end
  print("count: " .. count)
end


print('--------------INPUT--------------')
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
Day21(INPUT, 5)  -- Part A
Day21(INPUT, 18) -- Part B

