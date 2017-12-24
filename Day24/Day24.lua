
--[[

Day 24: Combinations recursively... 

]]


print("---------------- Day 24 ----------------")


function Day24(input, eval, bursts)
  local pieces = {}
  local startpieces = {}

  -- Read Input into component pieces...
  local i = 1
  for _, line in pairs(input) do
    for c, d in line:gfind('(%d+)%/(%d+)') do
      c = tonumber(c) or -1
      d = tonumber(d) or -1
      if (c == -1 or d == -1) then print("------------invalid piece.------------") end
      pieces[i] = {c1 = c, c2 = d, val = c+d}
      if (c == 0 or d == 0) then
        table.insert(startpieces, i)
      end
      i = i + 1
    end
  end

  -- Start with a 0 port, make a bridge, make all possible bridges, find highest 'strength'
  -- Each piece can only be used once.
  local num = 1
  for _, i in pairs(startpieces) do
    print(num .. " of " .. #startpieces .. " start pieces: " .. pieces[i].c1 .. "/" .. pieces[i].c2)
    num = num + 1

    local val = pieces[i].val
    local cur = pieces[i].c2
    local np = copy(pieces)
    table.remove(np, i)
    local path = {}
    table.insert(path, {c1 = pieces[i].c1, c2 = pieces[i].c2, val = pieces[i].val})
    solve(cur, np, path)
  end

  print()
  print("--------------------------------")
  print("Part A MAX: " .. gMax)
  print("--------------------------------")
  print("Part B MAXLEN: " .. gMaxLen)
  print("Part B MAX: " .. gMaxLenStrength)
end


function copy(arr)
  local out = {}
  for k,v in pairs(arr) do
    out[k] = {}
    for k1, v1 in pairs(v) do
      out[k][k1] = v1
    end
  end
  return out
end


function solve(cur, pieces, path)
  for i = 1, #pieces do
    if (pieces[i].c1 == cur) or (pieces[i].c2 == cur) then
      local npath = copy(path)
      table.insert(npath, {c1 = pieces[i].c1, c2 = pieces[i].c2, val = pieces[i].val})
      local np = copy(pieces)
      table.remove(np, i)
      if (pieces[i].c1 == cur) then
        solve(pieces[i].c2, np, npath)
      else
        solve(pieces[i].c1, np, npath)
      end
    end
  end

  -- show path...
  local out = {}
  local max = 0
  local len = 0
  gMax = gMax or 0
  gMaxLen = gMaxLen or 0
  gMaxLenStrength = gMaxLenStrength or 0
  for r = 1, #path do
    max = max + path[r].val
    len = len + 1
    table.insert(out, path[r].c1 .. "/" .. path[r].c2)
  end

  -- Part A calculation
  if (max > gMax) then gMax = max end

  -- Part B calculation
  if (len > gMaxLen) then
    gMaxLen = len
    gMaxLenStrength = max
  elseif (len == gMaxLen) then
    if (max > gMaxLenStrength) then
      gMaxLenStrength = max
    end
  end
end


-- Read Inputs...
TEST = {}
table.insert(TEST, "0/2")
table.insert(TEST, "2/2")
table.insert(TEST, "2/3")
table.insert(TEST, "3/4")
table.insert(TEST, "3/5")
table.insert(TEST, "0/1")
table.insert(TEST, "10/1")
table.insert(TEST, "9/10")

INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


Day24(TEST)
--Day24(INPUT)

