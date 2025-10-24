_addon.name = 'Portkey'
_addon.author = 'Mekaider'
_addon.version = '0.0.3'
_addon.commands = {'portkey'}

res = require('resources')

windower.register_event('addon command', function(...)
    local args = T{...}

    local ipc_mod = nil

    for arg in args:it() do
        local lower_arg = string.lower(arg)

        -- send accepts more (@zone, etc.) but superwarp only accepts all (a) or party (p)
        if lower_arg == 'a' or lower_arg == 'all' or
           lower_arg == 'p' or lower_arg == 'party' then
            ipc_mod = lower_arg
        end
    end

    -- https://github.com/Windower/Resources/blob/master/resources_data/zones.lua
    local zone = windower.ffxi.get_info().zone

    local base_cmd = nil
    local action = nil

    if zone == 102 or zone == 108 or zone == 117 then
        -- La Theine Plateau, Konschtat Highlands, Tahrongi Canyon
        base_cmd = 'ew'
        action   = 'enter'

    elseif zone == 288 or zone == 289 or zone == 291 then
        -- Escha Zi'Tah, Ru'Aun Gardens, Reisenjima
        base_cmd = 'ew'
        action   = 'exit'

    elseif zone == 279 or zone == 298 then
        -- Walk of Echoes P1 & P2 (Odyssey entry)
        base_cmd = 'od'
        action   = 'port'

    elseif zone == 133 or zone == 189 or zone == 275 then
        -- Sortie
        base_cmd = 'so'
        action   = 'port'

    elseif zone == 37 then
        -- Temenos
        base_cmd = 'te'
        action   = 'port'

    elseif zone == 38 then
        -- Apollyon
        base_cmd = 'ap'
        action   = 'port'
    end

    -- build the command and send it
    if base_cmd then
        local parts = { base_cmd }

        if ipc_mod then
            table.insert(parts, ipc_mod)
        end

        if action then
            table.insert(parts, action)
        end

        local final_cmd = table.concat(parts, ' ')

        windower.send_command(final_cmd)
        -- windower.add_to_chat(80, final_cmd)
    else
        windower.add_to_chat(80, 'Portkey: unknown area (' .. tostring(zone) .. ')')
    end
end)
