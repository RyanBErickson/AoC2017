
--[[

Day 17: Spinny.

]]


print("Day 17")


function Day17(step, last)
  local arr = {}
  local cur = 1
  table.insert(arr, '0')
  for i = 1, last do
    cur = (cur + step) % i + 1
    table.insert(arr, cur+1, i)

    -- Debug small sets...
    if (last < 20) then print(table.concat(arr, ',')) end
  end

  -- Part A solution...
  print('A: ' .. arr[cur+1] .. ' --> ' .. arr[cur+2])
  print('B: ' .. arr[1] .. ' --> ' .. arr[2])
end


function Day17b(step, last)
 local cur, pos1 = 1, 0
 for count = 1, last do
   cur = (cur+step) % count + 1
   if (cur == 1) then pos1 = count end
 end
 print(pos1)
end


--Day17(3,10) -- Test case
--Day17(3,2017) -- Test case
Day17(304,2017)
Day17b(304,2017)
Day17b(304, 50000000)

