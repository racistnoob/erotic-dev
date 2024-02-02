fx_version 'cerulean'
game 'gta5'

author 'noob'
version '1.0.0'

ui_page "client/game_view/index.html"


files {
    "client/game_view/**/*",
}
client_scripts {
    "@PolyZone/client.lua",
    "@PolyZone/BoxZone.lua",
    "@PolyZone/EntityZone.lua",
    "@PolyZone/CircleZone.lua",
    "@PolyZone/ComboZone.lua",
    
    "client/*.lua",
    "client/*.js",
    "client/modules/**/*.lua"
}

server_scripts {
    "server/*.lua",
    "server/*.js"
}
