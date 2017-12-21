
--[[

Day 21: It's a grind...  At least Part 2 is easy...

]]


print("Day 21")


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
  return rotatedTable;
end


function rotate2(s, count)
  local _, _, one, two = s:find('(.+)/(.+)')
  local _, _, x1, x2 = one:find('(.)(.)')
  local _, _, y1, y2 = two:find('(.)(.)')
  local grid = {{x1, x2, x3}, {y1, y2, y3}}
  for i = 1, count do
    grid = rotateTable(grid)
  end
  return compress(grid)
end


function rotate3(s, count)
  local _, _, one, two, three = s:find('(.+)/(.+)/(.+)')
  local _, _, x1, x2, x3 = one:find('(.)(.)(.)')
  local _, _, y1, y2, y3 = two:find('(.)(.)(.)')
  local _, _, z1, z2, z3 = three:find('(.)(.)(.)')
  local grid = {{x1, x2, x3}, {y1, y2, y3}, {z1, z2, z3}}
  for i = 1, count do
    grid = rotateTable(grid)
  end
  return compress(grid)
end

function flipvert(s)
  local _, _, one, two, three = s:find('(.+)/(.+)/(.+)')
  if (one == nil) then
    local _, _, one, two = s:find('(.+)/(.+)')
    return string.reverse(one) .. '/' ..  string.reverse(two)
  else
    return string.reverse(one) .. '/' ..  string.reverse(two) .. '/' ..  string.reverse(three)
  end
end

function fliphoriz(s)
  local _, _, one, two, three = s:find('(.+)/(.+)/(.+)')
  if (one == nil) then
    local _, _, one, two = s:find('(.+)/(.+)')
    return two .. '/' .. one
  else
    return three .. '/' .. two .. '/' .. one
  end
end

function printsquare(s)
  local _, _, one, two, three = s:find('(.+)/(.+)/(.+)')
  print(one) print(two) print(three)
end


function Day21(input)
  --local art = {{".","#","."}, {".",".","#"}, {"#","#","#"}}
  local art = ".#./..#/###"

  print("START: " .. art)

  -- Read rules input...
  local rules = {}
  -- Rotate and flip each pattern for all possibilities...
  for _, line in pairs(input) do
    local _, _, pat, repl = line:find('(.-) => (.+)')
    rules[pat] = repl
    rules[flipvert(pat)] = repl
    rules[fliphoriz(pat)] = repl
    if (pat:find('.../.../...')) then
      -- 3x square
      for i = 1, 3 do
        local rot = rotate3(pat, i)
        rules[rot] = repl
        rules[flipvert(rot)] = repl
        rules[fliphoriz(rot)] = repl
      end
    else
      -- 2x square
      for i = 1, 3 do
        local rot = rotate2(pat, i)
        rules[rot] = repl
        rules[flipvert(rot)] = repl
        rules[fliphoriz(rot)] = repl
      end
    end
  end

  -- Start with small art, grow it X times...
  for i = 1, 18 do
    local size = art:find('/') - 1
    local t = expand(art)
    local out = {}
    if (size % 2 == 0) then
      -- Divide into 3-sized sides...
      for row = 0, (size/2 - 1) do
        for col = 0, (size/2 - 1) do
          local slice = {{t[row*2+1][col*2+1], t[row*2+1][col*2+2]},
                         {t[row*2+2][col*2+1], t[row*2+2][col*2+2]}}
          local rot = compress(slice)
          -- Look for transform rule...
          local rule = rules[rot]
          if (rule) then
            --print(rot .. " -> " .. rule)
            local tab = expand(rule)
            local rw = row*3+1
            out[rw] = out[rw] or {}
            out[rw][col*3+1] = tab[1][1]
            out[rw][col*3+2] = tab[1][2]
            out[rw][col*3+3] = tab[1][3]
            rw = row*3+2
            out[rw] = out[rw] or {}
            out[rw][col*3+1] = tab[2][1]
            out[rw][col*3+2] = tab[2][2]
            out[rw][col*3+3] = tab[2][3]
            rw = row*3+3
            out[rw] = out[rw] or {}
            out[rw][col*3+1] = tab[3][1]
            out[rw][col*3+2] = tab[3][2]
            out[rw][col*3+3] = tab[3][3]
          else
            print("----------No Rule Found------------")
          end
        end
      end
    elseif (size % 3 == 0) then
      -- Divide into 3-sized sides...
      for row = 0, (size/3 - 1) do
        for col = 0, (size/3 - 1) do
          local slice = {{t[row*3+1][col*3+1], t[row*3+1][col*3+2], t[row*3+1][col*3+3]}, {t[row*3+2][col*3+1], t[row*3+2][col*3+2], t[row*3+2][col*3+3]}, {t[row*3+3][col*3+1], t[row*3+3][col*3+2], t[row*3+3][col*3+3]}, }
          local rot = compress(slice)
          -- Look for transform rule...
          local rule = rules[rot]
          if (rule) then
            --print(rot .. " -> " .. rule)
            local tab = expand(rule)
            local rw = row*4+1
            out[rw] = out[rw] or {}
            out[rw][col*4+1] = tab[1][1]
            out[rw][col*4+2] = tab[1][2]
            out[rw][col*4+3] = tab[1][3]
            out[rw][col*4+4] = tab[1][4]
            rw = row*4+2
            out[rw] = out[rw] or {}
            out[rw][col*4+1] = tab[2][1]
            out[rw][col*4+2] = tab[2][2]
            out[rw][col*4+3] = tab[2][3]
            out[rw][col*4+4] = tab[2][4]
            rw = row*4+3
            out[rw] = out[rw] or {}
            out[rw][col*4+1] = tab[3][1]
            out[rw][col*4+2] = tab[3][2]
            out[rw][col*4+3] = tab[3][3]
            out[rw][col*4+4] = tab[3][4]
            rw = row*4+4
            out[rw] = out[rw] or {}
            out[rw][col*4+1] = tab[4][1]
            out[rw][col*4+2] = tab[4][2]
            out[rw][col*4+3] = tab[4][3]
            out[rw][col*4+4] = tab[4][4]
          else
            print("----------No Rule Found------------")
          end
        end
      end
    end
    art = compress(out)
    --print("OUT: " .. art)
    print("iteration: " .. i)
  end

  -- Search for the number of # in output...
  local count = 0
  for c in art:gfind('(.)') do
    if (c == '#') then
      count = count + 1
    end
  end
  print("count: " .. count)

end


print('--------------TEST--------------')
--TESTDATA = {}
--for line in io.lines("testdata") do
  --table.insert(TESTDATA, line)
--end
--Day21(TESTDATA)

--print('--------------INPUT--------------')
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
Day21(INPUT)

