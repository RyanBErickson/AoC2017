
--[[

Day 18: Musicy

]]


print("Day 18")

function GetValue(val, vars)
  if (type(val) == 'number') then
    return val
  else
    return vars[val] or 0
  end
end

MACH = {}
MACH[1] = {vars = {}, count = 1, done = false}
MACH[2] = {vars = {}, count = 1, done = false}

function Run(i, machine)
end


function Day18(input)
  local vars = {}
  local instr = {}

  -- Load instructions...
  for _, line in pairs(input) do
    local _, endp, inst, reg = line:find('(...) (.)')
    local rest = line:sub(endp+2)
    if (string.len(rest) > 0) then
      rest = tonumber(rest) or rest
    end

    table.insert(instr, {instruction = inst, register = reg, value = rest})
  end

  local count = 1
  local done = false
  while (not done) do
    local i = instr[count]
    if (not i) then done = true break end

    print("inst: " .. i.instruction .. " reg: " .. i.register .. " val: " .. (i.value or "none"))
    local instruction = i.instruction

    if (instruction == "set") then
      vars[i.register] = GetValue(i.value, vars)
      count = count + 1
    end
    if (instruction == "add") then
      local val = vars[i.register] or 0
      vars[i.register] = val + GetValue(i.value, vars)
      count = count + 1
    end
    if (instruction == "mul") then
      local val = vars[i.register] or 0
      vars[i.register] = val * GetValue(i.value, vars)
      count = count + 1
    end
    if (instruction == "mod") then
      print(instruction, i.register)
      local val = vars[i.register] or 0
      vars[i.register] = val % GetValue(i.value, vars)
      count = count + 1
    end
    if (instruction == "rcv") then
      local val = vars[i.register] or 0
      if (val ~= 0) then
        -- recovers the frequency of the last sound played?
        print('RCV: ' .. gLastSound)
        done = true
        break
      end
      count = count + 1
    end
    if (instruction == "jgz") then
      local val = vars[i.register] or 0
      if (val > 0) then
        count = count + GetValue(i.value, vars)
      else
        count = count + 1
      end
    end

    if (instruction == "snd") then
      print("snd")
      print('reg: ' .. i.register)
      local val = vars[i.register] or 0
      print("Sound Played: " .. val)
      gLastSound = val
        -- plays sound of frequency of value of register?
      count = count + 1
    end
  end

  --for k,v in pairs(vars) do print(k,v) end
  
  print('done')

end


--[[function Day17b(step, last)
 local cur, pos1 = 1, 0
 for count = 1, last do
   cur = (cur+step) % count + 1
   if (cur == 1) then pos1 = count end
 end
 print(pos1)
end
]]

TESTDATA = {}
table.insert(TESTDATA, "set a 1")
table.insert(TESTDATA, "add a 2")
table.insert(TESTDATA, "mul a a")
table.insert(TESTDATA, "mod a 5")
table.insert(TESTDATA, "snd a")
table.insert(TESTDATA, "set a 0")
table.insert(TESTDATA, "rcv a")
table.insert(TESTDATA, "jgz a -1")
table.insert(TESTDATA, "set a 1")
table.insert(TESTDATA, "jgz a -2")

--Day18(TESTDATA) -- Test case

INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
Day18(INPUT)

