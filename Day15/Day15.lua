
--[[

Day 15: Solved PartA easily enough, then PartB threw me, since I was running both generators *in the loop*, and keeping A values in a table.
        Didn't think that I should only generate each until I get a value.  First puzzle I had to look for a clue on Reddit.
        Clue said: "It says generator, use generators.".  All the clue I needed.
        Yes, they're not real 'generators' in that they don't encapsulate the next functionality... but it gave me the clue.

Generator A starts with 618
Generator B starts with 814

]]


print("Day 15")


-- For Part A, don't do mod check...
function GenA(A)
  repeat
    A = A * 16807 % 2147483647
  until ((A%4) == 0)
  return A
end


-- For Part A, don't do mod check...
function GenB(B)
  repeat
    B = B * 48271 % 2147483647
  until ((B%8) == 0)
  return B
end


function Day15(A, B)

  local count = 0

  for i=1, 5000000 do
  --for i=1, 40000000 do
    A = GenA(A)
    B = GenB(B)
    if (bit.band(A, 0xFFFF) == bit.band(B, 0xFFFF)) then
      count = count + 1
    end
  end

  print("count: " .. count)
end

--Day15(65, 8921) -- Test Data
Day15(618, 814) -- My Data

