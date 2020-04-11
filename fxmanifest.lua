fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'ESX Z Jobs'

version '1.0.0'

server_script {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'server/main.lua',
    'config.lua'
}

client_script {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'client/main.lua',
    'config.lua',
    'client/jobs/fueler.lua',
    'client/jobs/lumberjack.lua',
    'client/jobs/slaughterer.lua',
    'client/jobs/tailor.lua',

}

dependencies {
	'es_extended',
	'esx_addonaccount',
	'skinchanger',
	'esx_skin'
}