
--[[

Day 16: "They were DAAAAANCING!!!!"

-- Part2: Search for a repeat of initial input in output... If found, only need to go (1000000000 % i) more times...

]]


print("Day 16")


function dance(first, i)
  local mov, tins, trem = moves, table.insert, table.remove

  for _, m in pairs(mov) do

    -- spin
    if (m.move == 's') then
      for i = 1, m.p1 do
        table.insert(arr, 1, table.remove(arr)) -- Remove last element, add to front...
      end
    end

    -- swap by numbers
    if (m.move == 'x') then
      arr[m.p1], arr[m.p2] = arr[m.p2], arr[m.p1]
    end

    -- swap partner by name
    if (m.move == 'p') then
      -- Find one/two...
      local pos1, pos2 = -1, -1
      for i = 1, #arr do
        if (arr[i] == m.p1) then pos1 = i end
        if (arr[i] == m.p2) then pos2 = i end
      end
      arr[pos1], arr[pos2] = arr[pos2], arr[pos1]
    end

    if (fullarr(arr) == first) then
      print('dup: ' .. i)
      return 1000000000 % i
    end
  end
end


function fullarr(arr)
  return table.concat(arr)
end


function Day16(start, input)
  arr = {}
  local tins = table.insert
  for c in start:gfind('(.)') do
    table.insert(arr, c)
  end

  input = input .. ','

  -- pre-parse dance moves...
  -- Turns out, this doesn't make it that much faster, still take *waaaay* too long to do a billion iterations...
  -- This is just wasted code.

  moves = {}
  for move, params in input:gfind('(.)(.-),') do
    if (move == 's') then
      tins(moves, {move = move, p1 = tonumber(params)})
    end
    if (move == 'x') then
      local _, _, one, two = params:find('(.-)/(.+)')
      one, two = tonumber(one) + 1, tonumber(two) + 1 -- zero-based...
      tins(moves, {move = move, p1 = one, p2 = two})
    end
    if (move == 'p') then
      local _, _, one, two = params:find('(.)/(.)')
      tins(moves, {move = move, p1 = one, p2 = two})
    end
  end

  local rep
  for i = 1, 1000000000 do
    rep = dance(first, i)
    if (rep) then break end
  end

  for i = 1, rep do
    dance(first, i)
  end

  print(fullarr(arr))

end

--Day16("abcdefghijklmnop","x8/10x3/4,x1/2,x3/4,x1/1") -- Test Data

for line in io.lines("input") do
  input = line
end

Day16("abcdefghijklmnop",input) -- My Data

