--! @file   client.lua
--
-- @brief
--
-- @author  Perry Hargrave
-- @date    2011-10-26
--

local pairs = pairs
local string = string
local type = type

local awful = require('awful')

module('toolbox.client')

function filter(key, value, n)
    return tab.filter(capi.client.get(), key, value, n)
end

function float_or_restore(c)
    if awful.client.floating.get(c) then
        awful.client.floating.set(c)
    end
end

function focus_min_or_restore(c)
    if c == client.focus then
        c.minimized = true
    else
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end
end

function is_maximized(c)
    return c.maximized_horizontal and c.maximized_vertical
end

function maximize(c)
    local new_state = not client.is_maximized(c)
    c.maximized_horizontal = new_state
    c.maximized_vertical = new_state
    c:raise()
end

-- Accepts a client, returns a nice stringification of its class property.
function title(c)
    if not c then return "E: no client passed" end
    s = awful.util.escape(c.class)
    s = s:match('^([%w%s_-]+)')
    s = s:gsub('[%s+_-]', ' ')
    s = s:gsub('%s%l', string.upper)
    return s
end

function create_launcher(command, notify)
    local notify = notify or false
    local f = function(...)
        local t = {...}
        local s = " "
        for _, v in pairs(t) do
            if type(v) == 'string' then s = s .. v end
        end
        awful.util.spawn(command .. s, notify)
    end
    return f
end
