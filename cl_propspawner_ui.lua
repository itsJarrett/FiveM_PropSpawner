--[[
FiveM-PropSpawner
A Prop/Object Spawner using GTA V Natives via the thoroughfare of FiveM.
Copyright (C) 2019  Jarrett Boice
]]

local uiOpen = false

RegisterNetEvent("propspawner:toggleUI")
AddEventHandler("propspawner:toggleUI", function()
    uiOpen = not uiOpen
    SetNuiFocus(uiOpen, uiOpen)
    SendNuiMessage({type = "uiOpen", value = uiOpen})
end)

