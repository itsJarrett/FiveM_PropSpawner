--[[
FiveM-PropSpawner
A Prop/Object Spawner using GTA V Natives via the thoroughfare of FiveM.
Copyright (C) 2019  Jarrett Boice
]]

availableProps = {}
availableProps = setmetatable(availableProps, {})

propDatabase = { 
    { propHash = "prop_vend_soda_02", propCoords = { x = 1828.914, y = 3706.582, z = 33.604 }, propHeading = 2.437, propSpawned = false} 
}
propDatabase = setmetatable(propDatabase, {})

currentSpawnedProps = {}

local minSpawnDistance = 15

RegisterCommand("getdata", function()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    x = tonumber(string.format("%.3f", x))
    y = tonumber(string.format("%.3f", y))
    z = tonumber(string.format("%.3f", z))
    local heading = tonumber(string.format("%.3f", GetEntityHeading(PlayerPedId())))
    print("{ x = " .. x .. ", y = " .. y .. ", z =  " .. z .. "}, propHeading = " .. heading)
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local playerPos = GetEntityCoords(PlayerPedId())
        for i, propData in ipairs(propDatabase) do
            local propCoords = vector3(propData.propCoords.x, propData.propCoords.y, propData.propCoords.z)
            local distance = GetDistanceBetweenCoords(propCoords, playerPos, false)
            if distance <= minSpawnDistance and propData.propSpawned == false then
                local propModel = GetHashKey(propData.propHash)
                RequestModel(propModel)
                while (not HasModelLoaded(propModel)) do
                    Wait(1)
                end
                local spawnedProp = CreateObject(propModel, propCoords, true, true, true)
                SetEntityHeading(spawnedProp, propData.propHeading)
                PlaceObjectOnGroundProperly(spawnedProp)
                SetModelAsNoLongerNeeded(model)
                SetEntityAsMissionEntity(spawnedProp)
                currentSpawnedProps[spawnedProp] = {i, propData}
                propDatabase[i].propSpawned = true
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local playerPos = GetEntityCoords(PlayerPedId())
        for propId, propArray in pairs(currentSpawnedProps) do
            local propData = propArray[2]
            local propCoords = vector3(propData.propCoords.x, propData.propCoords.y, propData.propCoords.z)
            local distance = GetDistanceBetweenCoords(propCoords, playerPos, false)
            if distance > minSpawnDistance then
                DeleteObject(propId)
                currentSpawnedProps[propId] = nil
                propDatabase[propArray[1]].propSpawned = false
            end
        end
    end
end)

AddEventHandler("onResourceStart", function(name)
    if name == GetCurrentResourceName() then
        TriggerServerEvent("propspawner:getAvailableProps")
    end
end)

RegisterNetEvent("propspawner:getAvailableProps")
AddEventHandler("propspawner:getAvailableProps", function(returnAvilableProps)
    availableProps = returnAvilableProps
end)
