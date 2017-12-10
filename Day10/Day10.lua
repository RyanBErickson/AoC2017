
--[[

Day 10: Hasing for fun and $$$...

NOTE: Switched to running with luajit, since I needed bitlib, and the Lua5.1 I had installed locally didn't have bitlib.

]]

print("Day 10")

TESTDATA = {}
table.insert(TESTDATA, "3,4,1,5")
table.insert(TESTDATA, "183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88") -- Input data...


function Day10a(input)
  local ARRAY_SIZE = 255
  --local ARRAY_SIZE = 4 -- Testing version...
  local array = {}
  for i = 0, ARRAY_SIZE do
    table.insert(array, i)
  end

  local curpos = 0
  local skipsize = 0

  -- Generate list of lengths from input string...
  local lengths = {}
  for c in input:gfind('(.)') do
    table.insert(lengths, string.byte(c))
  end
  table.insert(lengths, 17)
  table.insert(lengths, 31)
  table.insert(lengths, 73)
  table.insert(lengths, 47)
  table.insert(lengths, 23)

  -- PartA processing input numbers... 
  --for length in input:gfind('(%d+).-') do

  for round = 1, 64 do
    for _, length in pairs(lengths) do
      length = tonumber(length) or 0

      --print("curpos: " .. curpos .. " length: " .. length)
      local temp = {}
      for i = 0, length-1 do
        --print("i: " .. i+1 .. " arraypos: " .. (curpos+i) % (ARRAY_SIZE+1) + 1)
        temp[i+1] = array[(curpos+i) % (ARRAY_SIZE+1) + 1]
      end
      local count = 1
      for i = length-1, 0, -1 do
        --print("count: " .. count .. " arraypos: " .. (curpos+i) % (ARRAY_SIZE+1) + 1)
        array[(curpos+i) % (ARRAY_SIZE+1) + 1] = temp[count]
        count = count + 1
      end

      curpos = (curpos + length + skipsize) % (ARRAY_SIZE+1)

      skipsize = skipsize + 1
    end
  end

  -- Reduce the sparse hash to dense hash...
  -- use bit.bxor(a, b)
  local out = {}
  local count = 0
  for i = 0, 15 do
    local xorsum = 0
    for j = 1, 16 do
      xorsum = bit.bxor(xorsum, array[i*16+j])
      count = count + 1
    end
    table.insert(out, string.format("%02x", xorsum))
  end
  return(table.concat(out, ""))
end


assert(Day10a("") == "a2582a3a0e66e6e86e3812dcb672a272")
assert(Day10a("AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd")
assert(Day10a("1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d")
assert(Day10a("1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e")

print("Answer: " .. Day10a(TESTDATA[2]))

