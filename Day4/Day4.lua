
-- This one, part A was pretty straightforward.  For each word, check if in words array.  If found, return false.
-- Add word to array.
--
-- Part B was a bit harder, as I didn't know offhand how to generate the permutations for the anagrams.
-- I tried on my own for a while, and ended up looking up a permutation algorithm, which I implemented poorly (but quickly) in Lua.
-- It does use global variables, which is stupid, and I could probably fix it and make it much nicer, and maybe faster (it's slooow).
--
-- Looking at other's samples, it appears that I've done it the hardest way, by figuring out *all* anagrams of the word.
-- I could've just sorted the letters in the word in order, and compared against each word sorted in order, which
-- would be *MUCH* faster and *MUCH* easier.  Duh.
--
-- :)

print("Day 4")

-- Test Data
TESTDATA = {A = {}, B = {}}
table.insert(TESTDATA.A,"aa bb cc dd ee")
table.insert(TESTDATA.A,"aa bb cc dd aa")
table.insert(TESTDATA.A,"aa bb cc dd aaa")


-- Read input data...
function ReadData(fn)
  fn = fn or "input"
  local tins = table.insert
  local input = {}
  for line in io.lines(fn) do
    tins(input, line)
  end
  return input
end


-- Check if word has been seen before in line. If so, return false, otherwise true.  Track seen words in words table.
function Day4a(input)
  local words = {}
  for word in input:gmatch("(%S+)%s-") do
    if (words[word]) then return false end
    words[word] = true
  end
  return true
end


-- Test A
assert(Day4a(TESTDATA.A[1]) == true)
assert(Day4a(TESTDATA.A[2]) == false)
assert(Day4a(TESTDATA.A[3]) == true)

local lines = ReadData()
local count, total = 0, 0
for _, line in pairs(lines) do
  total = total + 1
  if (Day4a(line)) then
    count = count + 1
  end
end

print("Count: " .. count .. " of Total: " .. total)


table.insert(TESTDATA.B,"abcde fghij")
table.insert(TESTDATA.B,"abcde xyz ecdab")
table.insert(TESTDATA.B,"a ab abc abd abf abj")
table.insert(TESTDATA.B,"iiii oiii ooii oooi oooo")
table.insert(TESTDATA.B,"oiii ioii iioi iiio")


function totable(word)
  local chartable = {}
  for char in word:gmatch("(.)") do
    table.insert(chartable, char)
  end
  return chartable
end


function toword(t)
  local out, tins = {}, table.insert
  for _, c in pairs(t) do
    tins(out, c)
  end
  return table.concat(out, "")
end


function perm(a, l, r)
  if (l==r) then 
    gPermutations[toword(a)] = true
  else
    for i = l, r+1 do
      a[l], a[i] = a[i], a[l]
      perm(a, l+1, r)
      a[i], a[l] = a[l], a[i] -- backtrack
    end
  end
end

-- for k,v in pairs(allp("BCD")) do for k1, v1 in pairs(v) do print(k,k1,v1) end end

function Permute(str)
  gPermutations = {}
  perm(totable(str), 1, string.len(str))
  return gPermutations
end


function Day4b(input)
  local words = {}
  for word in input:gmatch("(%S+)%s-") do
    if (words[word]) then return false end

    -- Add all permutations of word to words array...
    for eachword, _ in pairs(Permute(word)) do
      words[eachword] = true
    end
  end
  return true
end


-- Test B
assert(Day4b(TESTDATA.B[1]) == true)
assert(Day4b(TESTDATA.B[2]) == false)
assert(Day4b(TESTDATA.B[3]) == true)
assert(Day4b(TESTDATA.B[4]) == true)
assert(Day4b(TESTDATA.B[5]) == false)

local lines = ReadData()
local count, total = 0, 0
for _, line in pairs(lines) do
  total = total + 1
  --print(total .. " of " .. #lines) -- progress... It's sloow...
  if (Day4b(line)) then
    count = count + 1
  end
end

print("B: Count: " .. count .. " of Total: " .. total)




