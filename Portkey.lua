_addon.name = 'Portkey'
_addon.author = 'Mekaider'
_addon.version = '0.0.5'
_addon.commands = {'portkey', 'pk'}

local res = require('resources')
require('logger')

local ipc_modifier_options = {
    a = 'all',
    all = 'all',
    p = 'party',
    party = 'party',
}
local commands = {
    enter_escha = {cmd='ew', action='enter'},
    exit_escha  = {cmd='ew', action='exit'},
    port_odyssey = {cmd='od', action='port'},
    port_temenos  = {cmd='te', action='port'},
    port_apollyon = {cmd='ap', action='port'},
    port_sortie = {cmd='so', action='port'},
}
-- https://github.com/Windower/Resources/blob/master/resources_data/zones.lua
local zone_to_command_data = {
    [102] = commands.enter_escha, -- La Theine Plateau
    [108] = commands.enter_escha, -- Konschtat Highlands
    [117] = commands.enter_escha, -- Tahrongi Canyon

    [288] = commands.exit_escha,  -- Escha Zi'Tah
    [289] = commands.exit_escha,  -- Ru'Aun Gardens
    [291] = commands.exit_escha,  -- Reisenjima

    [279] = commands.port_odyssey, -- Walk of Echoes P1
    [298] = commands.port_odyssey, -- Walk of Echoes P2

    [133] = commands.port_sortie,  -- Sortie
    [189] = commands.port_sortie,  -- Sortie
    [275] = commands.port_sortie,  -- Sortie

    [37]  = commands.port_temenos,  -- Temenos
    [38]  = commands.port_apollyon, -- Apollyon
}

windower.register_event('addon command', function(...)
    local args = {...}
    command = args[1] and args[1]:lower()
    local ipc_mod = command and ipc_modifier_options[command]
    if command and not ipc_mod then
        error('Unknown IPC modifier "%s".\n  valid commands are: a, all, p, party':format(command))
        return
    end
    local zone_id = windower.ffxi.get_info().zone
    if not zone_id then return end
    local command_info = zone_to_command_data[zone_id]
    if not command_info then
        local zone_name = res.zones and res.zones[zone_id] and res.zones[zone_id].name or tostring(zone_id)
        error('Invalid Area "%s"':format(zone_name))
        return
    end

    local sw_command_list = L{command_info.cmd}
    if ipc_mod then
        sw_command_list:append(ipc_mod)
    end
    sw_command_list:append(command_info.action)
    local final_cmd = sw_command_list:sconcat()
    log(final_cmd)
    windower.send_command(final_cmd)
end)
