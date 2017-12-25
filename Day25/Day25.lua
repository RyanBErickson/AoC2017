
--[[

Day 25: Turing Tape

]]


print("---------------- Day 25 ----------------")


function Day25(input)
  local tape = {}
  local states = {}
  local current_state = ""
  local diag_breakpoint_step = 0
  local _, state, ifval, writeval, movedir

  -- Read States into states array
  for _, line in pairs(input) do
    if (line:find('Begin in')) then
      _, _, current_state = line:find('Begin in state (.-)%.')
    end
    if (line:find('Perform a diag')) then
      _, _, diag_breakpoint_step = line:find('Perform a diagnostic checksum after (%d-) steps.')
      diag_breakpoint_step = tonumber(diag_breakpoint_step)
    end
    if (line:find('In state')) then
      _, _, state = line:find('In state (.-):')
      states[state] = {}
    end
    if (line:find('If the current')) then
      _, _, ifval = line:find('If the current value is (.-):')
      ifval = tonumber(ifval)
      states[state][ifval] = {}
    end
    if (line:find('- Write the value')) then
      _, _, writeval = line:find('Write the value (%d+)%.')
      writeval = tonumber(writeval)
      states[state][ifval].write = writeval
    end
    if (line:find('- Move one slot')) then
      _, _, movedir = line:find('- Move one slot to the (.-)%.')
      if (movedir == 'left') then
        states[state][ifval].move = -1
      elseif (movedir == 'right') then
        states[state][ifval].move = 1
      end
    end
    if (line:find('- Continue with')) then
      _, _, newstate = line:find('- Continue with state (.-)%.')
      states[state][ifval].newstate = newstate
    end
  end

  local cur_pos = 0
  local min, max = 0, 0
  for i = 1, diag_breakpoint_step do
    local cur_val = tape[cur_pos] or 0

    local state = states[current_state]
    local actions = state[cur_val]
    tape[cur_pos] = actions.write
    cur_pos = cur_pos + actions.move

    if cur_pos > max then max = cur_pos end
    if cur_pos < min then min = cur_pos end
    current_state = actions.newstate
  end
  
  -- Calculate checksum...
  local checksum = 0
  for i = min, max do
    if (tape[i] == 1) then
      checksum = checksum + 1
    end
  end

  print('checksum: ' .. checksum)
end


-- Read Inputs...
TEST = {}
table.insert(TEST, "")
table.insert(TEST, "Begin in state A.")
table.insert(TEST, "Perform a diagnostic checksum after 6 steps.")
table.insert(TEST, "")
table.insert(TEST, "In state A:")
table.insert(TEST, "If the current value is 0:")
table.insert(TEST, "- Write the value 1.")
table.insert(TEST, "- Move one slot to the right.")
table.insert(TEST, "- Continue with state B.")
table.insert(TEST, "If the current value is 1:")
table.insert(TEST, "- Write the value 0.")
table.insert(TEST, "- Move one slot to the left.")
table.insert(TEST, "- Continue with state B.")
table.insert(TEST, "")
table.insert(TEST, "In state B:")
table.insert(TEST, "If the current value is 0:")
table.insert(TEST, "- Write the value 1.")
table.insert(TEST, "- Move one slot to the left.")
table.insert(TEST, "- Continue with state A.")
table.insert(TEST, "If the current value is 1:")
table.insert(TEST, "- Write the value 1.")
table.insert(TEST, "- Move one slot to the right.")
table.insert(TEST, "- Continue with state A.")


INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

--Day25(TEST)
Day25(INPUT)

