
--[[

Day 20: moving nodes around...

]]


print("Day 20")


function Day20(input, PartB)
  PartB = PartB or false

  local DecodeTriplet = function(s)
    local _, _, a, b, c = (s .. ','):find('([0-9%-]+),([0-9%-]+),([0-9%-]+),')
    return tonumber(a), tonumber(b), tonumber(c)
  end

  -- Load particle list...
  local particle, count = {}, 0
  for _, line in pairs(input) do
    local _, _, p, v, a = line:find('p=%<(.-)%>.-v=%<(.-)%>.-a=%<(.-)%>')
    local px, py, pz = DecodeTriplet(p)
    local vx, vy, vz = DecodeTriplet(v)
    local ax, ay, az = DecodeTriplet(a)

    particle[count] = 
    {
        coll = false,
        x = {pos = px, vel = vx, acc = ax},
        y = {pos = py, vel = vy, acc = ay},
        z = {pos = pz, vel = vz, acc = az},
    }
    count = count + 1
  end

  -- Run particles for a while (1000 seems enough)...
  for loop = 1, 1000 do
    local node_at = {} -- Collision track hash (PartB)
    for i = 0, count-1 do
      local x, y, z, coll = particle[i].x, particle[i].y, particle[i].z, particle[i].coll
      if (coll == false) then
        -- Update x/y/z velocities...
        x.vel, y.vel, z.vel = x.vel + x.acc, y.vel + y.acc, z.vel + z.acc
        -- Update x/y/z positions...
        x.pos, y.pos, z.pos = x.pos + x.vel, y.pos + y.vel, z.pos + z.vel

        -- Detect Collisions... store 'x,y,z' in hash, if found, mark nodes as collision.
        if (PartB) then
          local coords = x.pos .. ',' .. y.pos .. ',' .. z.pos
          if (node_at[coords]) then
            particle[node_at[coords]].coll = true  -- mark original as collision...
            particle[i].coll = true                -- mark newly found as collision...
          end
          node_at[coords] = i
        end
      end
    end
  end

  -- Find nearest to 0,0,0
  local dist, node = 0, -1

  local nc = 0
  for i = 0, count-1 do
    local part = particle[i]
    if (part.coll == true) then
      nc = nc + 1
    else
      local md = math.abs(part.x.pos) + math.abs(part.y.pos) + math.abs(part.z.pos) -- Compute Manhattan Distance to (0,0,0)
      if (md < dist) or (node == -1) then
        node = i
        dist = md
      end
    end
  end

  if (not PartB) then
    print("Part A: nearest node: " .. node)
  else
    print("Part B: num collisions: " .. nc .. " num nodes left: " .. count - nc)
  end
end


--[[
print('--------------TEST--------------')
TESTDATA = {}
for line in io.lines("testdata") do
  table.insert(TESTDATA, line)
end
Day20(TESTDATA)
]]

print('--------------INPUT--------------')
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end
-- Part A
Day20(INPUT)
-- Part B
Day20(INPUT, true)

