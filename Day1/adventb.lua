
INPUT = {}
-- Test Data...
--table.insert(INPUT, {['1212'] = 6})
--table.insert(INPUT, {['1221'] = 0})
--table.insert(INPUT, {['123425'] = 4})
--table.insert(INPUT, {['123123'] = 12})
--table.insert(INPUT, {['12131415'] = 4})

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

dbg = print

-- Calculate
for _, test in pairs(INPUT) do
  local count = 0
  local input, result = next(test)
  local sum = 0
  local length = string.len(input)
  local halflength = math.floor(string.len(input) / 2)
  --dbg("input: " .. input .. " length: " .. length .. " halflength: " .. halflength)

  for digit in input:gfind("(.)") do
    digit = tonumber(digit)
    local half = halflength + count
    local index = (half % length) + 1
    --dbg("current half: " .. half .. " index: " .. index)
    local halfdigit = tonumber(input:sub(index, index))
    --dbg("Digit: " .. digit .. " Count: " .. count .. " Half: " .. half .. " Halfdigit: " .. halfdigit)
    if (digit == halfdigit) then
      sum = sum + digit
    end
    count = count + 1
  end

  print("Input: " .. input .. " Result: " .. sum .. " Expected Result: " .. result)
end

print("-----------------------------------------------------")
