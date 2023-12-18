fx_version 'adamant'
game 'gta5'
description 'echorp | Inventory Script'
version '1.0.5'

ui_page 'nui/ui.html'

files {
	'nui/*',
	'nui/icons/*',
}


shared_scripts ({
	'shared/**/*'
})

client_scripts ({
	'client/**/*'
})

server_scripts ({
	'server/**/*'
})

exports ({
	'getCash',
	'hasEnoughOfItem',
	'getQuantity',
	'GetCurrentWeapons',
	'GetItemInfo',
	'CreateCraftOption'
})