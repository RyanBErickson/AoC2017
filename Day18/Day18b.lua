
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
MACH[1] = {vars = {p = 0}, input = {}, sendcount = 0, count = 1, done = false, blocked = false, blockreg = ''}
MACH[2] = {vars = {p = 1}, input = {}, sendcount = 0, count = 1, done = false, blocked = false, blockreg = ''}


function Run(machine)

  -- If we're blocked, and we get called, we have a read ready...

  local m = MACH[machine]
  if (m.done) then return end

  if (m.blocked) then
    local var = table.remove(m.input, 1)
    m.vars[m.blockreg] = var
    m.blocked = false
    m.count = m.count + 1
  end

  local i = instr[m.count]
  if (not i) then 
    print(machine .. " Done.")
    m.done = true
    return
  end

  --print("M: " .. machine .. " inst: " .. i.instruction .. " reg: " .. i.register .. " val: " .. (i.value or "none"))

  local instruction = i.instruction
  if (instruction == "set") then
    m.vars[i.register] = GetValue(i.value, m.vars)
    m.count = m.count + 1
  end
  if (instruction == "add") then
    local val = m.vars[i.register] or 0
    m.vars[i.register] = val + GetValue(i.value, m.vars)
    m.count = m.count + 1
  end
  if (instruction == "mul") then
    local val = m.vars[i.register] or 0
    m.vars[i.register] = val * GetValue(i.value, m.vars)
    m.count = m.count + 1
  end
  if (instruction == "mod") then
    --print(instruction, i.register)
    local val = m.vars[i.register] or 0
    m.vars[i.register] = val % GetValue(i.value, m.vars)
    m.count = m.count + 1
  end
  if (instruction == "jgz") then
    local val = m.vars[i.register] or 0
    if (i.register == '1') then val = 1 end -- TOTAL HACK...
    if (val > 0) then
      m.count = m.count + GetValue(i.value, m.vars)
    else
      m.count = m.count + 1
    end
  end

  if (instruction == "rcv") then
    if (#m.input < 1) then
      m.blocked = true
      m.blockreg = i.register
    else
      local var = table.remove(m.input, 1)
      m.vars[i.register] = var
      m.count = m.count + 1
    end
  end

  if (instruction == "snd") then
    local val = m.vars[i.register] or 0
    local sendm = 1
    if (machine == 1) then sendm = 2 end

    m.sendcount = m.sendcount + 1

    table.insert(MACH[sendm].input, val)
    --print("Sent: " .. val)
    m.count = m.count + 1
  end
end


function Day18(input)
  instr = {}

  -- Load instructions...
  for _, line in pairs(input) do
    local _, endp, inst, reg = line:find('(...) (.)')
    local rest = line:sub(endp+2)
    if (string.len(rest) > 0) then
      rest = tonumber(rest) or rest
    end

    table.insert(instr, {instruction = inst, register = reg, value = rest})
  end

  -- Run both machines...  Run one until it blocks, then two, then each if they have input, then back again...

  -- This would be better sovled with Lua coroutines... yield when blocked, etc...

  while ((MACH[1].blocked == false) or (MACH[2].blocked == false) and (MACH[1].done == false or MACH[2].done == false)) do
    while (not MACH[1].blocked) do
      Run(1)
    end

    while (not MACH[2].blocked) do
      Run(2)
    end

    while (#MACH[1].input > 0) do
      Run(1)
    end

    while (#MACH[2].input > 0) do
      Run(2)
    end
  end
  
  print('done')
  print("Sendcount0: " .. tostring(MACH[1].sendcount) .. " Sendcount1: " .. tostring(MACH[2].sendcount))
end


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
--[[
table.insert(TESTDATA, "snd 1")
table.insert(TESTDATA, "snd 2")
table.insert(TESTDATA, "snd p")
table.insert(TESTDATA, "rcv a")
table.insert(TESTDATA, "rcv b")
table.insert(TESTDATA, "rcv c")
table.insert(TESTDATA, "rcv d")
]]

--Day18(TESTDATA) -- Test case

INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
Day18(INPUT)

