
--[[

Day 8: Straightforward today, and partb pretty easy add-on.

]]

print("Day 8")

-- Read input data...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


TESTDATA = {}
table.insert(TESTDATA, "b inc 5 if a > 1")
table.insert(TESTDATA, "a inc 1 if b < 5")
table.insert(TESTDATA, "c dec -10 if a >= 1")
table.insert(TESTDATA, "c inc -20 if c == 10")


function Day8a(input)
  local registers = {}
  local highest = -200000
  for i, line in pairs(input) do
    print(line)

    local _, _, reg,instr,val,_if,condreg,cond,condval = line:find('(%S+)%s-(%S+)%s-(%S+)%s-(%S+)%s-(%S+)%s-(%S+)%s-(%S+)')

    local value = tonumber(registers[condreg] or 0) or 0
    condval = tonumber(condval) or 0

    local met_conditional = false

    if (cond == '>') then met_conditional = (value > condval) end
    if (cond == '<') then met_conditional = (value < condval) end
    if (cond == '>=') then met_conditional = (value >= condval) end
    if (cond == '<=') then met_conditional = (value <= condval) end
    if (cond == '==') then met_conditional = (value == condval) end
    if (cond == '!=') then met_conditional = (value ~= condval) end

    if (met_conditional) then
      if (instr == "inc") then
        local newval = (registers[reg] or 0) + val
        registers[reg] = newval

        -- Partb: Track highest value in any register...
        if (newval > highest) then highest = newval end
      elseif (instr == "dec") then
        local newval = (registers[reg] or 0) - val
        registers[reg] = newval

        -- Partb: Track highest value in any register...
        if (newval > highest) then highest = newval end
      end
    end
  end

  -- Find maximum value of any register...
  local max = -200000
  for k,v in pairs(registers) do
    if (v > max) then max = v end
  end

  print("MAX: " .. max)
  print("highest: " .. highest)
end


--Day8a(TESTDATA)
Day8a(INPUT)

