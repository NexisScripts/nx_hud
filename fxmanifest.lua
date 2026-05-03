fx_version 'cerulean'
game 'gta5'

author 'Nexis Scripts'
description 'Modern, Optimized & Free HUD by NexisScripts'
version '2.2.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    'shared/framework.lua'
}

client_scripts {
    'bridge/esx.lua',
    'bridge/qb.lua',
    'bridge/qbox.lua',
    'client/functions.lua',
    'client/main.lua'
}

server_scripts {
    'server/functions.lua',
    'server/main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}