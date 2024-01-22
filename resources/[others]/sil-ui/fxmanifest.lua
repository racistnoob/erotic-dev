fx_version "cerulean"

description "Silence - UI"
author "silence"
version '0.0.1'

lua54 'yes'

game "gta5"

ui_page 'web/build/index.html'

client_scripts {
  'client/cl_exports.lua',
  'client/model/cl_*.lua'
}

server_scripts {
  'server/sv_*.lua',
  -- 'server/sv_*.js'
}

files {
  'web/build/index.html',
  'web/build/**/*'
}