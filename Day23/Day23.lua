
--[[

Day 23: Stoppy.

]]


print("Day 23")

function GetValue(val, vars)
  if (type(val) == 'number') then
    return val
  else
    return vars[val] or 0
  end
end


function Day23(input, areg)
  local vars = {a=areg}
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
  local c, runcount = 0, 0
  while (not done) do
    local i = instr[count]
    if (not i) then done = true break end

    local instruction = i.instruction

    if (instruction == "set") then
      vars[i.register] = GetValue(i.value, vars)
      count = count + 1
    end
    if (instruction == "sub") then
      local val = vars[i.register] or 0
      vars[i.register] = val - GetValue(i.value, vars)
      count = count + 1
    end
    if (instruction == "mul") then
      local val = vars[i.register] or 0
      vars[i.register] = val * GetValue(i.value, vars)
      count = count + 1
      c = c + 1
    end
    if (instruction == "jnz") then
      local val = vars[i.register] or 0
      if (tonumber(i.register) or -1) ~= -1 then
        val = tonumber(i.register)
      end
      if (val ~= 0) then
        count = count + GetValue(i.value, vars)
      else
        count = count + 1
      end
    end
  end

  print(c)
end


INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
--Day23(INPUT, 0)

Day23(INPUT, 1)

