--! @file   toolbox/init.lua
--
-- @brief Some helper functions.
--
-- @author  Perry Hargrave
-- @date    2011-10-25
--

local ipairs = ipairs
local pairs = pairs
local print = print
local table = table

local awful = require('awful')

require('toolbox.client')
require('toolbox.tag')

module('toolbox')

tab = {}

-- Return a table with all matches
function tab.filter(t, k, v, n)
    local n = n or -1
    tab_new = {}
    for i, o in ipairs(t) do
        if o[key] and o[key] == value then
            m[i] = o
       end
       if i == n + 1 then break end
   end
   return tab_new
end

screen = {}

-- Just try and figure out the current screen.
function screen.selected(s)
    return s or capi.client.focus.screen or capi.mouse.screen
end

function screen.next(s)
    return awful.util.cycle(capi.screen.count(), screen.selected(s) + 1)
end

function screen.prev(s)
    return awful.util.cycle(capi.screen.count(), screen.selected(s) - 1)
end

string = {}

function string.join(sep, ...)
    return table.concat({...}, sep)
end

path = {
    sep = '/'
}

function path.join(...)
    return string.join(path.sep, ...)
end

local function debug(...)
    print(string.join(...))
end
