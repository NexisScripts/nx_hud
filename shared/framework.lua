Framework = { Type = 'standalone' }

-- Smart Framework Auto-Detection
if GetResourceState('qbx_core') == 'started' then
    Framework.Type = 'qbox'
elseif GetResourceState('qb-core') == 'started' then
    Framework.Type = 'qb'
elseif GetResourceState('es_extended') == 'started' then
    Framework.Type = 'esx'
end

-- Global Debug Function
function DebugPrint(...)
    if Config.Debug then
        print('^5[nx_hud DEBUG]^7', ...)
    end
end

DebugPrint('Framework detected:', Framework.Type)