-- Resources:
-- **********
-- IPL list: https://wiki.rage.mp/index.php?title=Interiors_and_Locations

fx_version 'cerulean'
game 'gta5'

author 'Bob_74'
description 'Load and customize your map'
version '2.1.3'

lua54 "yes"

client_scripts {
    "lib/common.lua"
    , "client.lua"

    -- GTA V
    , "gtav/base.lua" 
    , "gtav/ammunations.lua"
    , "gtav/franklin_aunt.lua"
    , "gtav/michael.lua"
    , "gtav/simeon.lua"
    , "gtav/stripclub.lua"

    -- for ppl that wanna fuck around on cargo lol
    , "dlc_heists/carrier.lua"

    -- ffa lobby
    , "dlc_gunrunning/bunkers.lua"
}
