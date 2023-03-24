fx_version 'cerulean'
game {'rdr3', 'gta5'}
author 'Füsti'
version '1.0'
lua54 'yes'
description 'jobcenter script using ox_lib'

client_script 'client/client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}