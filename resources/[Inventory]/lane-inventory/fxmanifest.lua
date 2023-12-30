fx_version 'adamant'

game 'gta5'

description 'INVENTORY'
author ''
version '1.0.3'

server_scripts {
    'server/sv_main.lua',
}

shared_scripts {
    'locales.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/**/**'
}

ui_page 'html/index.html'

files {'html/**'}