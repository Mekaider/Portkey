_addon.name = 'Portkey'
_addon.author = 'Mekaider'
_addon.version = '0.0.7'
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
    runic_return = {cmd='po', action='return'},
    escha_enter = {cmd='ew', action='enter'},
    escha_exit  = {cmd='ew', action='exit'},
    odyssey_port = {cmd='od', action='port'},
    sortie_port = {cmd='so', action='port'},
    temenos_port  = {cmd='te', action='port'},
    apollyon_port = {cmd='ap', action='port'},
}
-- https://github.com/Windower/Resources/blob/master/resources_data/zones.lua
local zone_to_command_data = {
    [79] = commands.runic_return, -- Caedarva Mire
    [52] = commands.runic_return, -- Bhaflau Thickets
    [61] = commands.runic_return, -- Mount Zhayolm
    [52] = commands.runic_return, -- Arrapago Reef
    [72] = commands.runic_return, -- Alzadaal Undersea Ruins

    [126] = commands.escha_enter, -- Qufim Island
    [25]  = commands.escha_enter, -- Misareaux Coast
    [102] = commands.escha_enter, -- La Theine Plateau
    [108] = commands.escha_enter, -- Konschtat Highlands
    [117] = commands.escha_enter, -- Tahrongi Canyon

    [288] = commands.escha_exit,  -- Escha Zi'Tah
    [289] = commands.escha_exit,  -- Ru'Aun Gardens
    [291] = commands.escha_exit,  -- Reisenjima

    [279] = commands.odyssey_port, -- Walk of Echoes P1
    [298] = commands.odyssey_port, -- Walk of Echoes P2

    [133] = commands.sortie_port,  -- Sortie
    [189] = commands.sortie_port,  -- Sortie
    [275] = commands.sortie_port,  -- Sortie

    [37]  = commands.temenos_port,  -- Temenos
    [38]  = commands.apollyon_port, -- Apollyon
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
