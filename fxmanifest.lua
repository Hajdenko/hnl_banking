fx_version 'cerulean'
game 'gta5'

lua54 'yes'
author 'Hajden & Lachysek (HnL)'
description 'Banking System made with ox library (ox_lib)'

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'locale.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/*.lua',
}

dependency {'es_extended', 'ox_lib', 'oxmysql'}