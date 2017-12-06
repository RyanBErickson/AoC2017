
--[[

Day 6: Today, solving part b was trivial after part a, since I was storing the output in a hash, I just stored the value instead of true.

]]

print("Day 6")


function printtable(t, c)
  local out, tins = {}, table.insert
  for i, v in pairs(t) do
    if (i==c) then
      tins(out, "(" .. v .. ")")
    else
      tins(out, v)
    end
  end
  local tab = table.concat(out, ",")
  --print(tab)
  return tab
end


function Day6a(input)
  local done = false
  local seen = {}
  local count = 0
  local cycle = 0

  -- Store initial config in output table...
  seen[printtable(input)] = count
  while (not done) do
    local max = -2000
    local maxi = -1

    -- Find largest... If tie, pick first one.
    for i = 1, #input do
      if (input[i] > max) then
        maxi = i
        max = input[i]
      end
    end

    -- Zero out found, redistribute to others...
    input[maxi] = 0
    while (max > 0) do
      local ind = maxi % #input + 1
      input[ind] = input[ind] + 1
      maxi = maxi + 1
      max = max - 1
    end

    -- Check if result previously seen.  If not, store new result.
    local tab = printtable(input)
    count = count + 1
    if (not seen[tab]) then
      seen[tab] = count -- Part b -- Store count, to get cycle at end...
    else
      cycle = count - seen[tab]
      done = true
    end
  end
  print("Count: " .. count .. " Cycle: " .. cycle)
  return count, cycle
end


-- Test A
print("Test A (and B) Results...")
TESTDATA = {0, 2, 7, 0}
assert(Day6a(TESTDATA) == 5, 4)
Day6a({5,1,10,0,1,7,13,14,3,12,8,10,7,12,0,6})

