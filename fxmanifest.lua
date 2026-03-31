-- BSM | Basil Saji Mathew
-- BSM Weapon Control System

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Basil Saji Mathew (BSM)'
description 'Advanced Weapon Disarm System'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/main.lua',
    'client/events.lua',
    'client/death.lua',
    'client/ui.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/persistence.lua',
    'server/radius.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

provide 'bsm_weapon_control'
