
--[[

Day 9: Fun bit of character-by-character parsing today.  30 minutes of work.  State machine!

]]

print("Day 9")

-- Read input data...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


TESTDATA = {}
table.insert(TESTDATA, "{}") -- score of 1.
table.insert(TESTDATA, "{{{}}}") -- score of 1 + 2 + 3 = 6.
table.insert(TESTDATA, "{{},{}}") -- score of 1 + 2 + 2 = 5.
table.insert(TESTDATA, "{{{},{},{{}}}}") -- score of 1 + 2 + 3 + 3 + 3 + 4 = 16.
table.insert(TESTDATA, "{<a>,<a>,<a>,<a>}") -- score of 1.
table.insert(TESTDATA, "{{<ab>},{<ab>},{<ab>},{<ab>}}") -- score of 1 + 2 + 2 + 2 + 2 = 9.
table.insert(TESTDATA, "{{<!!>},{<!!>},{<!!>},{<!!>}}") -- score of 1 + 2 + 2 + 2 + 2 = 9.
table.insert(TESTDATA, "{{<a!>},{<a!>},{<a!>},{<ab>}}") -- score of 1 + 2 = 3.


function Day9a(input)
  local curlevel = 0
  local total = 0
  local garbage, ignore = false, false
  local numgarbage = 0

  --print(input)
  for c in input:gmatch("(.)") do
    if (ignore) then
      --print("Ignoring '" .. c .. "'.")
      ignore = false
    else
      if (garbage) then
        -- ! - Ignore next character...
        if (c == '!') then
          --print("Ignore found.")
          ignore = true -- Done processing this character...
        else
          -- Process Garbage...
          if (c == '>') then
            --print("end garbage...")
            garbage = false
          else
            numgarbage = numgarbage + 1
          end
        end
      else
        -- non-garbage
        if (c == '<') then
          --print("start garbage...")
          garbage = true
        else
          if (c == ',') then
            --print("comma")
          else
            -- Process not-garbage...
            --print("non-garbage: " .. c)
            if (c == '{') then
              curlevel = curlevel + 1
              total = total + curlevel
            end
            if (c == '}') then
              curlevel = curlevel - 1
            end
          end
        end
      end
    end
  end
  print("level: " .. curlevel .. " total: " .. total .. " numgarbage: " .. numgarbage)
end


--Day9a()
Day9a(INPUT[1])

