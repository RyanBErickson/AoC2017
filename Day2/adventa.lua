
print("Day 2a")

INPUT = {}
-- Test Data
--table.insert(INPUT,{5,1,9,5})
--table.insert(INPUT,{7,5,3})
--table.insert(INPUT,{2,4,6,8})

-- Read input data...
for line in io.lines("input") do
  local out, tins = {}, table.insert
  for num in line:gmatch("(%d+)%s-") do
    tins(out, tonumber(num))
  end
  tins(INPUT, out)
end

-- Calculate 'High/Low' Diff Checksum...
local checksum = 0
for _, line in pairs(INPUT) do
  local high, low = -2000, 2000
  for _, num in pairs(line) do
    if (num > high) then high = num end
    if (num < low) then low = num end
  end
  checksum = checksum + math.abs(high-low)
end

print("checksum: " .. checksum)
