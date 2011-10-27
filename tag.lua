--! @file   toolbox/tag.lua
--
-- @brief
--
-- @author  Perry Hargrave
-- @date    2011-10-26
--

local pairs = pairs

local awful = require('awful')

local shifty = require('shifty')

local print = print
module('toolbox.tag')

function filter(key, value, n)
    return tab.filter(capi.screen:tags(), key, value, n)
end

function move(t, scr, fb)
    local ts = t or awful.tag.selected()
    if not ts then return end

    local scr_origin = ts.screen

    -- This moves the tag, not necessarily the clients
    ts.screen = scr or awful.util.cycle(screen.count(), ts.screen + 1)

    -- set screen for clients and assign the 'new' tag
    for _, c in pairs(ts:clients()) do
        if (not c.sticky) or (c.sticky and fb == nil) then
            c.screen = ts.screen
            c:tags({ts})
        else
            -- Sticky clients stay on the original screen if there is space.
            c:tags({fb})
        end
    end

    if awful.tag.selected(scr_origin) == nil then
        local new_tags = capi.screen[scr_origin]:tags()
        if #new_tags > 0 then
            awful.tag.history.restore(scr_origin)
            if awful.tag.selected(scr_origin) == nil then
                new_tags[1].selected = true
            end
        end
    end

    return ts
end

function restore_defaults(t)
    local t_defaults = shifty.config.tags[t.name] or shifty.config.defaults
    for k, v in pairs(t_defaults) do
        awful.tag.setproperty(t, k, v)
    end
end

function to_screen(t, scr)
    local ts = t or awful.tag.selected()
    local screen_origin = ts.screen
    local screen_target = scr or screen.next()

    -- awful.tag.history.restore(ts.screen, 1)
    -- tag_move(ts, screen_target)
    awful.tag.move(ts, screen_target)

    -- never waste a screen
    if #(screen[screen_origin]:tags()) == 0 then
        for _, tag in pairs(screen[screen_target]:tags()) do
            if not tag.selected then
                awful.tag.move(tag, screen_origin)
                tag.selected = true
                break
            end
        end
    end

    awful.tag.viewonly(ts)
    mouse.screen = ts.screen
    if #ts:clients() > 0 then
        local c = ts:clients()[1]
        client.focus = c
    end
end
