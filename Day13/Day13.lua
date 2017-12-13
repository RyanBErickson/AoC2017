
--[[

Day 13: Have to cache 'current state' on this one, or you end up spending waaaayyy too much time to calculate the correct answer.

]]

print("Day 13")

-- Read Input...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

function printlevels(fw, maxd, maxr, cur)
  outd = {}
  for d = 0, maxd do
    local tab = fw[d] or ""
    if (tab == "") then
      table.insert(outd, string.format("%02d: ...", d))
    else
      local outr = {}
      for r = 0, maxr-1 do
        --print("d: " .. d .. " r: " .. r)
        --print("tab: " .. tab[r] or "none")
        if (tab[r]) then
          if (tab.current == r) then
            table.insert(outr, "[S]")
          else
            table.insert(outr, "[ ]")
          end
        else
          table.insert(outr, "   ")
        end
      end
      table.insert(outd, string.format("%02d: ", d) .. table.concat(outr, " "))
    end
  end
  print(table.concat(outd, "\n"))
end


function movescan(firewall)
  for index, tab in pairs(firewall) do
    local cur = tab.current or -1
    if (tab.current ~= -1) then
      if (tab[tab.current+tab.direction]) then
        tab.current = tab.current + tab.direction
      else
        tab.direction = tab.direction * -1
        tab.current = tab.current + tab.direction
      end
    end
  end
end


function testpass(firewall, delay, maxdepth, maxrange)
  done = false
  local severity = 0
  local packetdepth = 0

  -- Reset current...
  gLastDelay = gLastDelay or -1
  if (gCurrent) then
    --print("found current (gLastDay: " .. gLastDelay .. ")")
    for index, tab in pairs(firewall) do
      tab.current = gCurrent[index].current
      tab.direction = gCurrent[index].direction
    end
  else
    for index, tab in pairs(firewall) do
      tab.current = 0
    end
  end

  --print("Delay: " .. delay .. " gLastDelay: " .. gLastDelay)
  if (delay > 0) then
    for i = gLastDelay, delay-1 do
      movescan(firewall)
      --print("Delay[" .. i .. "] --------------------------------")
      --printlevels(firewall, maxdepth, maxrange, current)
    end
  end

  gLastDelay = delay
  gCurrent = {}
  for index, tab in pairs(firewall) do
    gCurrent[index] = {}
    gCurrent[index].current = tab.current
    gCurrent[index].direction = tab.direction
  end


  while (not done) do

    local curfw = firewall[packetdepth] or {current = -1}
    local current = curfw.current

    --printlevels(firewall, maxdepth, maxrange, current)
    --print("--------------------------------")

    -- check for 'collision'...
    if (current == 0) then
      --print("collision -- depth: " .. packetdepth .. " range: " .. curfw.range)
      if (severity == 0) then severity = 1 end
      severity = severity + (packetdepth * curfw.range)
    end

    -- Move scanners...
    movescan(firewall)

    packetdepth = packetdepth + 1
    if (packetdepth > maxdepth) then done = true end
  end
  return severity
end


function Day13(input)
  -- Build 'firewall'
  local inputs = {}
  local firewall = {}
  local maxdepth = 0
  local maxrange = 0

  -- read inputs...
  for _, line in pairs(input) do
    local _, _, depth, range = line:find("(%d+): (%d+)")
    depth, range = tonumber(depth), tonumber(range)
    --print("depth: " .. depth .. " range: " .. range)

    firewall[depth] = {}
    firewall[depth].current = 0
    firewall[depth].range = range
    firewall[depth].direction = 1
    for i = 0, range-1 do
      firewall[depth][i] = true
    end
    if (depth > maxdepth) then maxdepth = depth end
    if (range > maxrange) then maxrange = range end
  end

  --print("0 Severity: " .. testpass(firewall, 0, maxdepth, maxrange))
  --print("10 Severity: " .. testpass(firewall, 10, maxdepth, maxrange))

  for i = 0, 10000000 do
    if (i%1000 == 0) then print("i: " .. i) end
    if (testpass(firewall, i, maxdepth, maxrange) == 0) then
      print("winning delay: " .. i)
      os.exit()
    end
  end
end


TESTINPUT = {
  "0: 3",
  "1: 2",
  "4: 4",
  "6: 4",
}

--Day13(TESTINPUT)
Day13(INPUT)
