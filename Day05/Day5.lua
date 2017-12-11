
--[[

Day 5: Not too tough today.  Finished both parts in 19 minutes.

]]

print("Day 5")


-- Read input data...
function ReadData(fn)
  fn = fn or "input"
  local tins = table.insert
  local input = {}
  for line in io.lines(fn) do
    tins(input, tonumber(line))
  end
  return input
end


function table_count(t)
  local count = 0
  for _, _ in pairs(t) do count = count + 1 end
  return count
end


dbg = print
function printtable(t, c)
  local out, tins = {}, table.insert
  for i, v in pairs(t) do
    if (i==c) then
      tins(out, "(" .. v .. ")")
    else
      tins(out, v)
    end
  end
  print(table.concat(out, ","))
end


function Day5a(input)
  local index = 1
  local len = table_count(input)
  local count = 0

  --printtable(input, index)
  while (index <= len) do
    local inc = input[index]
    input[index] = input[index] + 1
    index = index + inc
    count = count + 1
    --printtable(input, index)
  end
  print(count .. " steps to exit.")
  return count
end


-- Test A
print("Test A Results...")
TESTDATA = {0, 3, 0, 1, -3}
assert(Day5a(TESTDATA) == 5)
Day5a(ReadData())



function Day5b(input)
  local index = 1
  local len = table_count(input)
  local count = 0

  --printtable(input, index)
  while (index <= len) do
    local inc = input[index]

    if (inc >= 3) then
      input[index] = input[index] - 1
    else
      input[index] = input[index] + 1
    end

    index = index + inc
    count = count + 1
    --printtable(input, index)
  end
  print(count .. " steps to exit.")
  return count
end


-- Test B
print("Test B Results...")
TESTDATA = {0, 3, 0, 1, -3}
assert(Day5b(TESTDATA) == 10)
Day5b(ReadData())


