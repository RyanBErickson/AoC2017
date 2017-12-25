
--[[

Day 25: Turing Tape

]]


print("---------------- Day 25 ----------------")


function Day25(input)
  local states = {}
  local current_state, max_steps

  local val, state, ifval -- Temporaries during reading
  local MOVE = {left = -1, right = 1}

  -- Read States into states array
  for _, line in pairs(input) do
    local _, _, val = line:find('Begin in state (.-)%.')
    if (val) then current_state = val end

    local _, _, val = line:find('Perform a diagnostic checksum after (%d-) steps.')
    if (val) then max_steps = tonumber(val) end

    local _, _, val = line:find('In state (.-):')
    if (val) then state = val states[state] = {} end

    local _, _, val = line:find('If the current value is (.-):')
    if (val) then ifval = tonumber(val) states[state][ifval] = {} end

    local _, _, val = line:find('Write the value (%d+)%.')
    if (val) then states[state][ifval].write = tonumber(val) end

    local _, _, val = line:find('- Move one slot to the (.-)%.')
    if (val) then states[state][ifval].move = MOVE[val] end

    local _, _, val = line:find('- Continue with state (.-)%.')
    if (val) then states[state][ifval].newstate = val end
  end

  -- Play state machine max_steps...
  local tape = {}
  local cur_pos = 0
  local min, max = 0, 0
  for i = 1, max_steps do
    -- Read value under cursor
    local cur_val = tape[cur_pos] or 0 -- cells default to 0

    -- Get state actions for value and current state
    local state = states[current_state]
    local actions = state[cur_val]

    tape[cur_pos] = actions.write         -- Write
    cur_pos = cur_pos + actions.move      -- Move
    current_state = actions.newstate      -- New State

    -- Track min/max positions on tape, for calculating checksum later...
    if cur_pos > max then max = cur_pos end
    if cur_pos < min then min = cur_pos end
  end
  
  -- Calculate checksum...
  local checksum = 0
  for i = min, max do
    checksum = checksum + tape[i]
  end

  return checksum
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

assert(Day25(TEST) == 3)


INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

local cs = Day25(INPUT)
print('Checksum: ' .. cs)

