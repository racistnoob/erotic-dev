local CAR_LIST = {
    [1] = {
        ['model'] = 'Revolter',
        ['image'] = 'https://www.gtaboom.com/wp-content/uploads/2018/01/revolter3.jpg',
    },
    [2] = {
        ['model'] = 'Sheava',
        ['image'] = 'https://th.bing.com/th/id/OIP.EMgDHhVJgXfJIevi7Am2_QHaEK?rs=1&pid=ImgDetMain',
    },
    [3] = {
        ['model'] = 'Issi7',
        ['image'] = 'https://th.bing.com/th/id/OIP.meiRzJA_S-t9PQTCMyX1IgHaEK?rs=1&pid=ImgDetMain',
    },
    [4] = {
        ['model'] = 'Cyclone',
        ['image'] = 'https://th.bing.com/th/id/OIP.eTYHQOMIqy_8bfrBIXaFhQHaEK?rs=1&pid=ImgDetMain',
    },
    [5] = {
        ['model'] = 'Shotaro',
        ['image'] = 'https://vignette.wikia.nocookie.net/gtawiki/images/d/df/Shotaro-GTAO-front.png/revision/latest?cb=20161004182220',
    },
    [6] = {
        ['model'] = 'Toros',
        ['image'] = 'https://th.bing.com/th/id/R.86f1754dbf9f5d4b21d0302538724fbf?rik=bdWUn0Mfs8viNg&pid=ImgRaw&r=0',
    },
    [7] = {
        ['model'] = 'OmnisEGT',
        ['image'] = 'https://i.imgur.com/oBiQZox.png',
    },
    [8] = {
        ['model'] = 'Paragon',
        ['image'] = 'https://th.bing.com/th/id/OIP.8rhhZAUg31f-tmcLl-Zp5gHaEK?rs=1&pid=ImgDetMain',
    },
    [9] = {
        ['model'] = 'SultanRS',
        ['image'] = 'https://th.bing.com/th/id/OIP.wDl0mWbPQJ8zfcuNwut7EQHaEK?rs=1&pid=ImgDetMain',
    },
    [10] = {
        ['model'] = 'Neon',
        ['image'] = 'https://th.bing.com/th/id/OIP.f4ko3ibB0k2kemcKRL2q0QHaEK?rs=1&pid=ImgDetMain',
    },
    [11] = {
        ['model'] = 'Streiter',
        ['image'] = 'https://th.bing.com/th/id/OIP.E_5wXcp1nRdp3vgn3T3rnwHaEK?rs=1&pid=ImgDetMain',
    },
    [12] = {
        ['model'] = 'Raiden',
        ['image'] = 'https://th.bing.com/th/id/OIP.ZYQ-UQxQDzMpyPZaCSTK6AHaEK?rs=1&pid=ImgDetMain',
    },
    [13] = {
        ['model'] = 'Tulip',
        ['image'] = 'https://th.bing.com/th/id/OIP.1n86Z0mgIorXc5xmilJsBgHaEK?rs=1&pid=ImgDetMain',
    },
    [14] = {
        ['model'] = 'Buffalo',
        ['image'] = 'https://vignette.wikia.nocookie.net/gta/images/0/04/Buffalo_(V).jpg/revision/latest?cb=20140817165118&path-prefix=pl',
    },
    [15] = {
        ['model'] = 'Buffalo2',
        ['image'] = 'https://th.bing.com/th/id/OIP.lSP2O90sK20KTltM5b81QwHaEK?rs=1&pid=ImgDetMain',
    },
    [16] = {
        ['model'] = 'Buffalo3',
        ['image'] = 'https://th.bing.com/th/id/OIP.Wcil-AJf5ksGRVN4HhGgTgHaEK?rs=1&pid=ImgDetMain',
    },
    [17] = {
        ['model'] = 'Seven70',
        ['image'] = 'https://th.bing.com/th/id/OIP.tA-ErojzoHS7EMIV0q1ONgHaEK?rs=1&pid=ImgDetMain',
    },
    [18] = {
        ['model'] = 'Massacro',
        ['image'] = 'https://th.bing.com/th/id/R.b09165ced1789499007b48b953788f83?rik=II%2bCWroUG9jc3w&pid=ImgRaw&r=0',
    },
    [19] = {
        ['model'] = 'Guardian',
        ['image'] = 'https://th.bing.com/th/id/OIP.lYmIP_ZnrD2YdHmo_We9VAHaEK?rs=1&pid=ImgDetMain',
    },
    [20] = {
        ['model'] = 'Vigero2',
        ['image'] = 'https://assets.gamepur.com/wp-content/uploads/2022/07/26095024/gta-vigero-850x478.jpg',
    },
    [21] = {
        ['model'] = 'Coquette4',
        ['image'] = 'https://th.bing.com/th/id/OIP.qE2qqSiSVmwuqElk_AsNywHaEL?rs=1&pid=ImgDetMain',
    },
    [22] = {
        ['model'] = 'Jester',
        ['image'] = 'https://i.pinimg.com/736x/0a/08/83/0a0883982bb51e8aebb971070366330e--gta--jester.jpg',
    },
    [23] = {
        ['model'] = 'Jester3',
        ['image'] = 'https://th.bing.com/th/id/OIP.OFEpZn21zZR6kVfWtZgdzgHaEK?rs=1&pid=ImgDetMain',
    },
    [24] = {
        ['model'] = 'Jester4',
        ['image'] = 'https://th.bing.com/th/id/OIP.Ge66sZLvCi6PbpZ4P1RlrAHaEK?rs=1&pid=ImgDetMain',
    },
    [25] = {
        ['model'] = 'Penumbra2',
        ['image'] = 'https://th.bing.com/th/id/OIP.3V67UqryqZYhoM7_i57ZfgAAAA?rs=1&pid=ImgDetMain',
    },
    [26] = {
        ['model'] = 'Schlagen',
        ['image'] = 'https://th.bing.com/th/id/OIP.NsX71075lO6ubsEXnY_tOAHaEK?rs=1&pid=ImgDetMain',
    },
    [27] = {
        ['model'] = 'ItaliGTO',
        ['image'] = 'https://th.bing.com/th/id/OIP.-U8Roa707xUHzzD-RQMwiAHaEK?rs=1&pid=ImgDetMain',
    },
    [28] = {
        ['model'] = 'Comet2',
        ['image'] = 'https://th.bing.com/th/id/OIP.rV_NlRISp1TJXSj7kR6tUwHaEK?rs=1&pid=ImgDetMain',
    },
    [29] = {
        ['model'] = 'Comet6',
        ['image'] = 'https://th.bing.com/th/id/R.03ca405be8961e05a4f8d9cec815f812?rik=i8tvo%2f7Iuxe22A&pid=ImgRaw&r=0',
    },
    [30] = {
        ['model'] = 'Pariah',
        ['image'] = 'https://th.bing.com/th/id/OIP.P-4lJxMJbIMq4iZ0ycGyIQHaEK?rs=1&pid=ImgDetMain',
    },
    [31] = {
        ['model'] = 'Nero2',
        ['image'] = 'https://th.bing.com/th/id/OIP.93OroyExvmpcowZu-kKaJAHaEK?rs=1&pid=ImgDetMain',
    },
    [32] = {
        ['model'] = 'Specter2',
        ['image'] = 'https://th.bing.com/th/id/OIP.38pUZihSjExVYskG2XDuqAHaEK?rs=1&pid=ImgDetMain',
    },
    [33] = {
        ['model'] = 'Tempesta',
        ['image'] = 'https://th.bing.com/th/id/OIP.N4V_tUz72kGYNJFlN5jPYgHaEK?rs=1&pid=ImgDetMain',
    },
    [34] = {
        ['model'] = 'Elegy',
        ['image'] = 'https://th.bing.com/th/id/OIP.EM8dNamv4RNnne2HFkXBIgHaEK?rs=1&pid=ImgDetMain',
    },
    [35] = {
        ['model'] = 'Sultan2',
        ['image'] = 'https://th.bing.com/th/id/OIP.UCL3Z6L1MrzUQpj0GQ5qLQHaEK?rs=1&pid=ImgDetMain',
    },
    [36] = {
        ['model'] = 'Banshee2',
        ['image'] = 'https://th.bing.com/th/id/OIP.TCyNdYUkMvSYH8GYjoofxgHaEK?rs=1&pid=ImgDetMain',
    },
    [37] = {
        ['model'] = 'Cliffhanger',
        ['image'] = 'https://th.bing.com/th/id/OIP.LZGiATzYygs6SnkZbmZeSAHaEK?rs=1&pid=ImgDetMain',
    },
    [38] = {
        ['model'] = 'Bati',
        ['image'] = 'https://th.bing.com/th/id/OIP.b70esTJp9zdg2OkQ1AjSJgHaEK?w=290&h=180&c=7&r=0&o=5&pid=1.7',
    },
    [39] = {
        ['model'] = 'Sanchez',
        ['image'] = 'https://th.bing.com/th/id/OIP.-RLOctMNhF9pydtsCDj7GwHaEK?rs=1&pid=ImgDetMain',
    },
    [40] = {
        ['model'] = 'Manchez',
        ['image'] = 'https://th.bing.com/th/id/OIP.Px_nYbqbAjfKdq6h-aYfDwHaEK?rs=1&pid=ImgDetMain',
    },
    [41] = {
        ['model'] = 'BF400',
        ['image'] = 'https://th.bing.com/th/id/OIP.pVtP2_4VJpKkwBOjAExSqwHaEK?rs=1&pid=ImgDetMain',
    },
    [42] = {
        ['model'] = 'Powersurge',
        ['image'] = 'https://img.atwiki.jp/gtav/attach/2958/11234/Powersurge.jpg',
    },
}

RegisterNetEvent('carspawner:openMenu')
AddEventHandler('carspawner:openMenu', function()
    SetNuiFocus(true, true)
      SendReactMessage('vehiclespawner', {
        cars = CAR_LIST
    })

end)

RegisterNUICallback('carspawner:closeNUI', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('carspawner:spawnVehicle', function(DATA)
    SetNuiFocus(false, false)
    TriggerEvent('drp:spawnvehicle', DATA.MODEL)
    SetResourceKvp("last_vehicle", DATA.MODEL)
end)

RegisterCommand('+car_menu', function()
    TriggerEvent('carspawner:openMenu')
end)

RegisterKeyMapping('+car_menu', '[Car Spawner] Open Menu', 'keyboard', 'm')

RegisterCommand("previous_vehicle", function()
    local previousVehicle = GetResourceKvpString('last_vehicle')
    if previousVehicle then
        TriggerEvent("drp:spawnvehicle", previousVehicle)
    end
end)