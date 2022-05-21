fx_version 'adamant'
game 'gta5'

lua54 'yes'

version '1.0.0'
author 'Mista Putt'
description 'from https://github.com/FiveM-Scripts/CorruptSnail-Gamemode.'

shared_scripts {
	"@ox_lib/init.lua",
	"@mista_overlay/client/zones.lua",
	"config.lua"
}

server_scripts {
	"spawning/sv_zombies.lua",
}

client_scripts {
	"cl_utils.lua",
	"cl_entityenum.lua",
	"cl_player.lua",
	"cl_env.lua",
	"cl_groupholder.lua",
	"cl_pedscache.lua",
	-- "spawning/cl_player.lua",
	"spawning/cl_zombies.lua",
	"spawning/cl_savezones.lua",
	"spawning/cl_staticzones.lua",
}