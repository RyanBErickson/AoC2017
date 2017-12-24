
--[[

Day 24: Combinations recursively... 

]]


print("---------------- Day 24 ----------------")


function Day24(input)
  local pieces = {}

  -- Read Input into component pieces...
  for _, line in pairs(input) do
    for left, right in line:gfind('(%d+)%/(%d+)') do
      left, right = tonumber(left), tonumber(right)
      table.insert(pieces, {left = left, right = right, strength = left+right})
    end
  end

  -- Start with each 0 port, recursively find all bridges (solve)...  Each piece can only be used once.
  solve(0, pieces, {})

  print("Part A MAX: " .. gMax)
  print("----------------------------------------")
  print("Part B MAXLEN: " .. gMaxLen)
  print("Part B MAX: " .. gMaxLenStrength)
end


-- Copy table, remove component at index...  This is inefficient...
function copyminus(t, i)
  local nt = copy(t)
  table.remove(nt, i)
  return nt
end


-- Copy table, add specified component...  This is inefficient...
function copyplus(t, v)
  local nt = copy(t)
  table.insert(nt, v)
  return nt
end


function copy(arr) -- non-iterating copy about 2x faster...  Still inefficient.  :)
  local out = {}
  for i = 1, #arr do
    local a = arr[i]
    out[i] = {left = a.left, right = a.right, strength = a.strength}
  end
  return out
end


function solve(cur, pieces, path)
  for i = 1, #pieces do
    local piece = pieces[i]
    if (piece.left == cur) then
      solve(piece.right, copyminus(pieces, i), copyplus(path, piece))
    elseif (piece.right == cur) then
      solve(piece.left, copyminus(pieces, i), copyplus(path, piece))
    end
  end

  -- Calc path strength and length...
  local strength, length = 0, 0
  for r = 1, #path do
    strength = strength + path[r].strength
    length = length + 1
  end

  -- Part A calculation
  if (strength > (gMax or 0)) then gMax = strength end

  -- Part B calculation
  if (length > (gMaxLen or 0)) then
    gMaxLen = length
    gMaxLenStrength = strength
  elseif (length == (gMaxLen or 0)) then
    if (strength > (gMaxLenStrength or 0)) then
      gMaxLenStrength = strength
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

--Day24(TEST)
Day24(INPUT)

