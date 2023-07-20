fx_version 'cerulean'
game 'gta5'
lua54 'yes'
-- Original Script
-- https://forum.cfx.re/t/esx-ox-fusti-jobcenter/5071853

client_script {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua'
}