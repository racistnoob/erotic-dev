fx_version 'cerulean'
game 'gta5'

author 'Bimbo'
version '1.0.0'

ui_page 'gamesettings/settings/overtime/html/index.html'

files {
	'gamesettings/settings/overtime/html/images/*.png',
	'gamesettings/settings/overtime/html/**/*.html',
	'gamesettings/settings/overtime/html/**/*.css',
	'gamesettings/settings/overtime/html/**/*.js',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/**',
    'gamesettings/**/**/**',
}

server_scripts {
    'server/**',
}