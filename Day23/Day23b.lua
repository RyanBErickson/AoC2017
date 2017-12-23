
-- Direct implementation of code to figure out register h...

a, b, c, d, e, f, g, h = 1,0,0,0,0,0,0,0

b = 79 -- set b 79
c = b  -- set c b
if (a ~= 0) then -- goto I00 end -- jnz a 2
  b = b * 100        -- mul b 100
  b = b + 100000     -- sub b -100000
  c = b              -- set c b
  c = c + 17000      -- sub c -17000
  print("b: " .. b .. " c: " .. c)
end
::LOOP:: f = 1              -- set f 1
d = 2              -- set d 2
::I3:: --e = 2              -- set e 2

-- Optimization: optimize out the inner loop
if (b % d == 0 and b/d ~= 1) then
  f = 0
end

--::I2:: g = d              -- set g d
--g = g * e          -- mul g e
--g = g - b          -- sub g b
--if (g ~= 0) then goto I1 end -- jnz g 2 -- I1
--f = 0              -- set f 0
--::I1:: e = e + 1          -- sub e -1
--g = e              -- set g e
--g = g - b          -- sub g b
--if (g ~= 0) then goto I2 end -- jnz g -8 -- I2

d = d + 1          -- sub d -1
g = d              -- set g d
g = g - b          -- sub g b
if (g ~= 0) then goto I3 end -- jnz g -13 -- I3
if (f ~= 0) then goto I4 end -- jnz f 2 -- I4
h = h + 1          -- sub h -1
::I4:: g = b              -- set g b
g = g - c          -- sub g c
if (g ~= 0) then goto I5 end -- jnz g I5:
goto done -- jnz 1 3 -- OUT
::I5:: b = b + 17         -- sub b -17
goto LOOP -- jnz 1 -23

::done::

print(h)
