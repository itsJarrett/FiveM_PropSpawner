--[[
FiveM-PropSpawner
A Prop/Object Spawner using GTA V Natives via the thoroughfare of FiveM.
Copyright (C) 2019  Jarrett Boice
]]

description "propspawner"
author "Slavko Avsenik"
version "1.0.0"

ui_page("nui/index.html")

server_scripts {
  "sv_propspawner.lua"
}

client_scripts {
  "cl_propspawner.lua"
}
