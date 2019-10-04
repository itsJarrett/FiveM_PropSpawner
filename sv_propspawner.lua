--[[
FiveM-PropSpawner
A Prop/Object Spawner using GTA V Natives via the thoroughfare of FiveM.
Copyright (C) 2019  Jarrett Boice
]]

local availableProps = {}
availableProps = setmetatable(availableProps, {})

Citizen.CreateThread(function()
    Citizen.Wait(0)
    local rawAvailableProps = LoadResourceFile(GetCurrentResourceName(), "availableProps.json")
    availableProps = json.decode(rawAvailableProps)
end)

RegisterServerEvent("propspawner:getAvailableProps")
AddEventHandler("propspawner:getAvailableProps", function()
  local _source = source
  TriggerClientEvent("propspawner:getAvailableProps", _source, availableProps)
end)

RegisterCommand("testprop", function(source, args, rawCommand)
  local _source = source
  TriggerClientEvent("propspawner:toggleUI", _source)
end, false)
