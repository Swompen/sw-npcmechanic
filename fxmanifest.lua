name "sw-npcmechanic"
author "Swompen"
version "v1.0.0"
description "A simple NPC mechanic script"
fx_version 'cerulean'
games {'gta5' }

shared_scripts {
    'config.lua',
    'locales/*.lua'
}
server_script 'sv_npcmechanic.lua'
client_scripts {
    'locales/*.lua',
    'cl_npcmechanic.lua'
}