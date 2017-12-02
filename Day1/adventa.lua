
INPUT = {}
-- Test Data...
--table.insert(INPUT, {['1122'] = 3})
--table.insert(INPUT, {['1111'] = 4})
--table.insert(INPUT, {['1234'] = 0})
--table.insert(INPUT, {['91212129'] = 9})

-- Read actual input data...
local file = io.open("input", "r")
local line = file:read("*l")
if (line) then
  --print(line)
  table.insert(INPUT, {[tostring(line)] = '?'})
  while (line) do
    line = file:read("*l")
    if (line) then
      --print(line)
      table.insert(INPUT, {[tostring(line)] = '?'})
    end
  end
end

-- Calculate
for _, test in pairs(INPUT) do
  local input, result = next(test)
  -- Append a copy of the first digit to the end of the string, so comparisons just go along...
  local newinp = input .. input:sub(1,1)
  local sum = 0

  local lastdigit = -1
  for digit in newinp:gfind("(.)") do
    digit = tonumber(digit)
    if (digit == lastdigit) then
      sum = sum + digit
    end
    lastdigit = digit
    --print("Digit: " .. digit .. " LastDigit: " .. lastdigit .. " Sum: " .. sum)
  end
  print("Input: " .. input .. " Result: " .. sum .. " Expected Result: " .. result)
end

print("-----------------------------------------------------")
