
--[[

Day 12: Path Searching.  Brute force solution works, but I'm sure there's a much more elegant way to solve this...
  This method puts everything to a table of related nodes, then repeatedly goes through and adds a groupid to each node that's attached.
  Then it finds the first one with no groupid, adds one, then goes through and matches on that groupid.

]]

print("Day 12")

-- Read Input...
INPUT = {}
-- Sample Input Line: 0 <-> 454, 528, 621, 1023, 1199

for line in io.lines("input") do
  table.insert(INPUT, line)
end


function Day12(input)
  local RELATED = {}

  for _, line in pairs(input) do

    _, _, idx, right = line:find("(%d-)%s-[-<>]+%s-(.+)")
    idx = tonumber(idx) or 0
    right = right:gsub("%s","") .. ","

    RELATED[idx] = RELATED[idx] or {}
    RELATED[idx].nodes = RELATED[idx].nodes or {}

    for related in right:gfind('(%d+).-') do
      related = tonumber(related)

      RELATED[idx].nodes[related] = true
      RELATED[idx].groupid = 0
    end
  end

  local groupcount = 0
  groupcount = groupcount + 1
  RELATED[0].groupid = groupcount

  -- Brute force through all of them to find found.  If not flipped, do again...
  local changed, found
  repeat
    found = false
    repeat
      changed = false
      for idx, tab in pairs(RELATED) do 
        --print("idx: " .. idx)
        if (tab.groupid ~= 0) then
          for nodeidx, _ in pairs(tab.nodes) do 
            --print("nodeidx: " .. nodeidx)
            if (RELATED[nodeidx].groupid == 0) then
              RELATED[nodeidx].groupid = tab.groupid
              changed = true
            end
          end
        end
      end
    until changed == false

    -- Mark first zero groupid
    local found = false
    for idx, tab in pairs(RELATED) do 
      if (tab.groupid == 0) and (not found) then
        --print("here: " .. idx)
        groupcount = groupcount + 1
        tab.groupid = groupcount
        found = true
        changed = true
      end
    end
  until found == false

  print("groupcount: " .. groupcount)
end


TESTINPUT = {
  "0 <-> 2",
  "1 <-> 1",
  "2 <-> 0, 3, 4",
  "3 <-> 2, 4",
  "4 <-> 2, 3, 6",
  "5 <-> 6",
  "6 <-> 4,5"
}

--Day12(TESTINPUT)
Day12(INPUT)
