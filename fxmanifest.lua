fx_version 'adamant'

version '1.0.0'
description 'lab-pet'
author 'zhonnz'

game 'gta5'


client_scripts {
"@vrp/lib/utils.lua",
    'client/functions.lua',
}

server_scripts {
"@vrp/lib/utils.lua",
	'sql.lua',
	'server/main.lua',
}

shared_scripts {
"@vrp/lib/utils.lua",
	'locales.lua',
	'config.lua',
}


ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/*.ttf',
    'nui/*.png',
    'nui/*.jpg',
    'nui/*.css',
	'stream/*.ytd',
    'nui/*.js',
    'nui/*.mp3',
    'nui/img/*.png',
    'nui/img/*.jpg',
    'nui/sounds/*.ogg',
    'nui/sounds/*.mp3',
}

escrow_ignore {
    'config.lua',
    'locales.lua',
    'sql.lua',
    'stream/*.ytd'
}

lua54 'yes'
 