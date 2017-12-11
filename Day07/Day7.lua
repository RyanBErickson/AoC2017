
--[[

Day 7: Today, I finished both halves, but manually searched for the answer for the second half...
I was getting tired.  I need to drop the table dumper and figure out how to programmatically find the answer.
I've almost got it, but not quite.

]]

-- Table dumping routines...  ----------------------------------------------------
function dump(...)
  print(DataDumper(...), "\n---")
end


local dumplua_closure = [[
local closures = {}
local function closure(t)
  closures[#closures+1] = t
  t[1] = assert(loadstring(t[1]))
  return t[1]
end

for _,t in pairs(closures) do
  for i = 2,#t do
    debug.setupvalue(t[1], i-1, t[i])
  end
end
]]

local lua_reserved_keywords = {
  'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for',
  'function', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat',
  'return', 'then', 'true', 'until', 'while' }

local function keys(t)
  local res = {}
  local oktypes = { stringstring = true, numbernumber = true }
  local function cmpfct(a,b)
    if oktypes[type(a)..type(b)] then
      return a < b
    else
      return type(a) < type(b)
    end
  end
  for k in pairs(t) do
    res[#res+1] = k
  end
  table.sort(res, cmpfct)
  return res
end

local c_functions = {}
for _,lib in pairs{'_G', 'string', 'table', 'math',
    'io', 'os', 'coroutine', 'package', 'debug'} do
  local t = _G[lib] or {}
  lib = lib .. "."
  if lib == "_G." then lib = "" end
  for k,v in pairs(t) do
    if type(v) == 'function' and not pcall(string.dump, v) then
      c_functions[v] = lib..k
    end
  end
end

function DataDumper(value, varname, fastmode, ident)
  local defined, dumplua = {}
  -- Local variables for speed optimization
  local string_format, type, string_dump, string_rep =
        string.format, type, string.dump, string.rep
  local tostring, pairs, table_concat =
        tostring, pairs, table.concat
  local keycache, strvalcache, out, closure_cnt = {}, {}, {}, 0
  setmetatable(strvalcache, {__index = function(t,value)
    local res = string_format('%q', value)
    t[value] = res
    return res
  end})
  local fcts = {
    string = function(value) return strvalcache[value] end,
    number = function(value) return value end,
    boolean = function(value) return tostring(value) end,
    ['nil'] = function(value) return 'nil' end,
    ['function'] = function(value)
      return string_format("loadstring(%q)", string_dump(value))
    end,
    userdata = function() error("Cannot dump userdata") end,
    thread = function() error("Cannot dump threads") end,
  }
  local function test_defined(value, path)
    if defined[value] then
      if path:match("^getmetatable.*%)$") then
        out[#out+1] = string_format("s%s, %s)\n", path:sub(2,-2), defined[value])
      else
        out[#out+1] = path .. " = " .. defined[value] .. "\n"
      end
      return true
    end
    defined[value] = path
  end
  local function make_key(t, key)
    local s
    if type(key) == 'string' and key:match('^[_%a][_%w]*$') then
      s = key .. "="
    else
      s = "[" .. dumplua(key, 0) .. "]="
    end
    t[key] = s
    return s
  end
  for _,k in ipairs(lua_reserved_keywords) do
    keycache[k] = '["'..k..'"] = '
  end
  if fastmode then
    fcts.table = function (value)
      -- Table value
      local numidx = 1
      out[#out+1] = "{"
      for key,val in pairs(value) do
        if key == numidx then
          numidx = numidx + 1
        else
          out[#out+1] = keycache[key]
        end
        local str = dumplua(val)
        out[#out+1] = str..","
      end
      if string.sub(out[#out], -1) == "," then
        out[#out] = string.sub(out[#out], 1, -2);
      end
      out[#out+1] = "}"
      return ""
    end
  else
    fcts.table = function (value, ident, path)
      if test_defined(value, path) then return "nil" end
      -- Table value
      local sep, str, numidx, totallen = " ", {}, 1, 0
      local meta, metastr = (debug or getfenv()).getmetatable(value)
      if meta then
        ident = ident + 1
        metastr = dumplua(meta, ident, "getmetatable("..path..")")
        totallen = totallen + #metastr + 16
      end
      for _,key in pairs(keys(value)) do
        local val = value[key]
        local s = ""
        local subpath = path
        if key == numidx then
          subpath = subpath .. "[" .. numidx .. "]"
          numidx = numidx + 1
        else
          s = keycache[key]
          if not s:match "^%[" then subpath = subpath .. "." end
          subpath = subpath .. s:gsub("%s*=%s*$","")
        end
        s = s .. dumplua(val, ident+1, subpath)
        str[#str+1] = s
        totallen = totallen + #s + 2
      end
      if totallen > 80 then
        sep = "\n" .. string_rep("  ", ident+1)
      end
      str = "{"..sep..table_concat(str, ","..sep).." "..sep:sub(1,-3).."}"
      if meta then
        sep = sep:sub(1,-3)
        return "setmetatable("..sep..str..","..sep..metastr..sep:sub(1,-3)..")"
      end
      return str
    end
    fcts['function'] = function (value, ident, path)
      if test_defined(value, path) then return "nil" end
      if c_functions[value] then
        return c_functions[value]
      elseif debug == nil or debug.getupvalue(value, 1) == nil then
        return string_format("loadstring(%q)", string_dump(value))
      end
      closure_cnt = closure_cnt + 1
      local res = {string.dump(value)}
      for i = 1,math.huge do
        local name, v = debug.getupvalue(value,i)
        if name == nil then break end
        res[i+1] = v
      end
      return "closure " .. dumplua(res, ident, "closures["..closure_cnt.."]")
    end
  end
  function dumplua(value, ident, path)
    return fcts[type(value)](value, ident, path)
  end
  if varname == nil then
    varname = "return "
  elseif varname:match("^[%a_][%w_]*$") then
    varname = varname .. " = "
  end
  if fastmode then
    setmetatable(keycache, {__index = make_key })
    out[1] = varname
    table.insert(out,dumplua(value, 0))
    return table.concat(out)
  else
    setmetatable(keycache, {__index = make_key })
    local items = {}
    for i=1,10 do items[i] = '' end
    items[3] = dumplua(value, ident or 0, "t")
    if closure_cnt > 0 then
      items[1], items[6] = dumplua_closure:match("(.*\n)\n(.*)")
      out[#out+1] = ""
    end
    if #out > 0 then
      items[2], items[4] = "local t = ", "\n"
      items[5] = table.concat(out)
      items[7] = varname .. "t"
    else
      items[2] = varname
    end
    return table.concat(items)
  end
end

-- Table dumping routines...  ----------------------------------------------------

print("Day 7")

-- Read input data...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

--for k,v in pairs(INPUT) do print(k,v) end


function printtable(t, c)
  local out, tins = {}, table.insert
  for i, v in pairs(t) do
    if (i==c) then
      tins(out, "(" .. v .. ")")
    else
      tins(out, v)
    end
  end
  local tab = table.concat(out, ",")
  --print(tab)
  return tab
end

TESTDATA = {}
table.insert(TESTDATA, "pbga (66)")
table.insert(TESTDATA, "xhth (57)")
table.insert(TESTDATA, "ebii (61)")
table.insert(TESTDATA, "havc (66)")
table.insert(TESTDATA, "ktlj (57)")
table.insert(TESTDATA, "fwft (72) -> ktlj, cntj, xhth")
table.insert(TESTDATA, "qoyq (66)")
table.insert(TESTDATA, "padx (45) -> pbga, havc, qoyq")
table.insert(TESTDATA, "tknk (41) -> ugml, padx, fwft")
table.insert(TESTDATA, "jptl (61)")
table.insert(TESTDATA, "ugml (68) -> gyxo, ebii, jptl")
table.insert(TESTDATA, "gyxo (61)")
table.insert(TESTDATA, "cntj (57)")

-- node = name, weight, children...

function Day7a(input)
  local all = {}
  local childnames = {}
  for i, v in pairs(input) do
    local _, _, name, weight = v:find("(%S+)%s-%((%d+)%)")
    local mysubs = {}
    if (v:find("->")) then
      local _, _, subs = v:find(".-->%s-(.+)")
      subs = subs:gsub("%s", "")
      for sub in subs:gmatch('([^,]+)') do
        table.insert(mysubs, sub)
        childnames[sub] = true
      end
    end
    all[name] = {weight = weight, childnames = mysubs}
  end
  
  -- Find root node (node that has children, but that appears in no other node's children list)...
  local rootname = ""
  for name, node in pairs(all) do -- print(name,node.weight,#node.childnames)
    if (#node.childnames) then
      if (not childnames[name]) then
        print("found root: " .. name)
        rootname = name
      end
    end
  end
 
  --dump(all)

  local tree = {}
  local children = subtree(rootname, all)
  tree = {name = rootname, weight = all[rootname].weight, children = children}
  dump(tree)

  treeweights(tree)

  return 'blah'
end


function treeweights(node, level)
  level = level or 1
  if (#node.children == 0) then
    return node.weight
  end

  local w = -200 -- last child weight...
  local t = 0 -- total
  for _, child in pairs(node.children) do 
    local weight = treeweights(child, level+1)

    t = t + weight
    if (w ~= -200) and (weight ~= w) then
      print("offset: " .. weight - w)
    end
  end
  print(string.rep('--', level) .. t+node.weight .. "(" .. node.name .. ")")
  return t+node.weight
end


function subtree(name, all)
  local node = all[name]
  if (#node.childnames == 0) then return {} end

  local out = {}
  local nodeweight = 0
  for _, childname in pairs(all[name].childnames) do
    children = subtree(childname, all)
    table.insert(out, {name = childname, weight = all[childname].weight, children = children})
  end
  return out
end

--Day7a(TESTDATA)
Day7a(INPUT)

-- Test A
--print("Test A (and B) Results...")
--TESTDATA = {0, 2, 7, 0}
--assert(Day7a(TESTDATA) == 'tknk')
--Day7a({5,1,10,0,1,7,13,14,3,12,8,10,7,12,0,6})

