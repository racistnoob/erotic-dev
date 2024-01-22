fx_version 'cerulean'
game 'gta5'

description 'EchoRP | Framework'
version '2.0'

lua54 'yes'

server_script '@oxmysql/lib/MySQL.lua'

shared_scripts {
    -- 'common/*.lua'
}

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua',
}