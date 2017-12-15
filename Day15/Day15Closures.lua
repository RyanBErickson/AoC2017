
-- Day15 with actual closure-based generators (iterators) in Lua...

function genGenerator(factor, START, mod2)
  local MOD = 2147483647
  local val = START
  if (mod2 == nil) then          -- PartA Generator
    return function ()
      val = val * factor % MOD
      return val
    end
  else                           -- PartB Generator (adds check for mod 4 or mod 8)
    return function ()
      repeat
        val = val * factor % MOD
      until (val % mod2) == 0
      return val
    end
  end
end


function iter(num, GenA, GenB)
  local count, band, mask = 0, bit.band, 0xFFFF
  for i = 1, num do
    if (band(GenA(), mask) == band(GenB(), mask)) then
      count = count + 1
    end
  end
  return count
end


function Day15(STARTA, STARTB)
  print("Day15")

  print("Part A Count: " .. iter(40000000, genGenerator(16807, STARTA), genGenerator(48271, STARTB)))
  print("Part B Count: " .. iter(5000000, genGenerator(16807, STARTA, 4), genGenerator(48271, STARTB, 8)))
end


--Day15(65, 8921) -- Test Values
Day15(618, 814) -- My Values
