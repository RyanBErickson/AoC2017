
--[[

Day 14: Revisit Knot Hash...  Map coloring type solution for part 2.

]]


print("Day 14")


function CalcKnotHash(input) -- From Day 10...
  local ARRAY_SIZE = 255
  local array, tins = {}, table.insert
  for i = 0, ARRAY_SIZE do
    tins(array, i)
  end

  local curpos = 0
  local skipsize = 0

  -- Generate list of lengths from input string...
  local lengths = {}
  for c in input:gfind('(.)') do
    tins(lengths, string.byte(c))
  end
  tins(lengths, 17)
  tins(lengths, 31)
  tins(lengths, 73)
  tins(lengths, 47)
  tins(lengths, 23)

  for round = 1, 64 do
    for _, length in pairs(lengths) do
      length = tonumber(length) or 0

      local temp = {}
      for i = 0, length-1 do
        temp[i+1] = array[(curpos+i) % (ARRAY_SIZE+1) + 1]
      end
      local count = 1
      for i = length-1, 0, -1 do
        array[(curpos+i) % (ARRAY_SIZE+1) + 1] = temp[count]
        count = count + 1
      end
      curpos = (curpos + length + skipsize) % (ARRAY_SIZE+1)
      skipsize = skipsize + 1
    end
  end

  -- Reduce the sparse hash to dense hash...
  local hash = {}
  local count = 0
  for i = 0, 15 do
    local xorsum = 0
    for j = 1, 16 do
      xorsum = bit.bxor(xorsum, array[i*16+j])
      count = count + 1
    end
    tins(hash, string.format("%02x", xorsum))
  end
  return(table.concat(hash, ""))
end


HEX = {}
HEX['0'] = {bitmap = '....', sum = 0}
HEX['1'] = {bitmap = '...X', sum = 1}
HEX['2'] = {bitmap = '..X.', sum = 1}
HEX['3'] = {bitmap = '..XX', sum = 2}
HEX['4'] = {bitmap = '.X..', sum = 1}
HEX['5'] = {bitmap = '.X.X', sum = 2}
HEX['6'] = {bitmap = '.XX.', sum = 2}
HEX['7'] = {bitmap = '.XXX', sum = 3}
HEX['8'] = {bitmap = 'X...', sum = 1}
HEX['9'] = {bitmap = 'X..X', sum = 2}
HEX['a'] = {bitmap = 'X.X.', sum = 2}
HEX['b'] = {bitmap = 'X.XX', sum = 3}
HEX['c'] = {bitmap = 'XX..', sum = 2}
HEX['d'] = {bitmap = 'XX.X', sum = 3}
HEX['e'] = {bitmap = 'XXX.', sum = 3}
HEX['f'] = {bitmap = 'XXXX', sum = 4}

-- Not including Diagonals, duh...
CHK = {}
CHK[1] = {x = -1, y =  0}
CHK[2] = {x =  1, y =  0}
CHK[3] = {x =  0, y = -1}
CHK[4] = {x =  0, y =  1}


function findnum(x,y, grid)
  if (grid[x] == nil) then return nil end
  if (grid[x][y] == nil) then return nil end
  if (grid[x][y] == 'X') then return nil end
  if (grid[x][y] == '.') then return nil end
  --print("x: " .. x .. " y: " .. y .. " val: " .. grid[x][y])
  return grid[x][y]
end


function Day14(input)
  local sum = 0
  local grid = {}

  -- Fill grid with values from the KnotHash outputs... 'X' for used cell, '.' for unused cell...

  for i = 0, 127 do
    grid[i] = {}
    local idx = 0
    local hashinput = input .. "-" .. i
    local output = CalcKnotHash(hashinput)

    -- for each character in Knot Hash, lookup the HEX bits and the sum.  Could use bitwise, no need here...
    for c in output:gfind('(.)') do
      local bits = HEX[c].bitmap

      -- for each character in bits, add proper val to grid
      for b in bits:gfind('(.)') do
        grid[i][idx] = b
        idx = idx + 1
      end
      sum = sum + HEX[c].sum
    end
  end

  local groupnum = 0
  local newgroup

  -- Go through grid, first 'X' found, assign a number.  Search through grid from that point, any adjacent that are numbers are set.

  repeat     -- Repeat until no additional new group numbers can be assigned (all X have been found)...
    newgroup = false
    local first = true
    local foundone
    --io.write('.') io.flush()

    repeat     -- Repeat until no additional values with this num are found...
      foundone = false
      for i = 0, 127 do
        for j = 0, 127 do
          if grid[i][j] == 'X' then
            -- New group number
            if (first) then
              groupnum = groupnum + 1
              grid[i][j] = groupnum
              newgroup = true
              first = false
              foundone = true
            else
              local found, check = false, 0
              -- Check adjacents...
              while (not found) and (check < 4) do
                check = check + 1
                local n = findnum(i+CHK[check].x, j+CHK[check].y, grid)
                if (n) then
                  grid[i][j] = n
                  found = true
                  foundone = true
                end
              end
            end
          end
        end
      end
    until (foundone == false)
  until (newgroup == false)

  -- Print out corner of grid to see results...
  if (false) then
    local out, tins = {}, table.insert
    for i = 0, 40 do
      local line = {}
      for j = 0, 20 do
        if (type(grid[i][j]) == "number") then
          tins(line, (("%4d"):format(grid[i][j]):gsub(' ','_')))
        else
          tins(line, '____')
        end
      end
      tins(out, table.concat(line, " "))
    end
    print(table.concat(out, "\n"))
  end

  print("Squares: " .. sum)     -- Part 1 answer...
  print("Groups: " .. groupnum) -- Part 2 answer...
end


--Day14("flqrgnkx") -- Test Input
Day14("amgozmfv") -- My Input

