print("Day 2b")

INPUT = {}
-- Test Data
--table.insert(INPUT,{5, 9, 2, 8})
--table.insert(INPUT,{9, 4, 7, 3})
--table.insert(INPUT,{3, 8, 6, 5})

-- Read input data...
for line in io.lines("input") do
  local out, tins = {}, table.insert
  for num in line:gmatch("(%d+)%s-") do
    tins(out, tonumber(num))
  end
  tins(INPUT, out)
end

-- Calculate 'Divisibles' Checksum...
local checksum = 0
for _, line in pairs(INPUT) do
  -- Go through each number in the line
  for _, num1 in pairs(line) do
    local div = 0
    -- Compare to each number in the line (includes self, cancelled out below)
    for _, num2 in pairs(line) do
      if ((num1 % num2 == 0) and (num1 ~= num2)) then
        -- Verify dividing larger by smaller...
        if (num1 < num2) then
          num1, num2 = num2, num1
        end
        div = num1 / num2
      end
    end
    checksum = checksum + div
  end
end

print("checksum: " .. checksum)
