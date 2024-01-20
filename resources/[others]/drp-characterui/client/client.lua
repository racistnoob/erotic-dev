local charPed = nil
local CHARACTERS = {}

AddEventHandler("echorp:spawnInitialized", function()
    TriggerEvent('drp-characterui:client:chooseChar')
end)

local choosingCharacter = false
local cam = nil

function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SetNuiFocusKeepInput(bool)
    SendReactMessage('toggleVisiblity', bool)
    TriggerServerEvent('echorp:fetchcharacters')
    choosingCharacter = bool
    TriggerEvent('handleTurning')
    skyCam(bool)

    if bool then 
        TriggerServerEvent('drp-motels:apartment:enter')
        SetPedPopulationBudget(0)
        SetVehiclePopulationBudget(0)
    else 
        TriggerServerEvent('drp-motels:apartment:exit') 
        SetPedPopulationBudget(3)
        SetVehiclePopulationBudget(3)
    end
end

RegisterNUICallback('selectCharacter', function(data, cb)
  TriggerServerEvent('echorp:selectCharacter', data.id)
  TriggerEvent('drp-voice:mutePlayer', false)
  openCharMenu(false)
  if charPed then
    if DoesEntityExist(charPed) then SetEntityAsMissionEntity(charPed, true, true) DeleteEntity(charPed) charPed = nil end 
  end
  cb({})
end)

RegisterNetEvent('drp-characterui:client:closeNUI')
AddEventHandler('drp-characterui:client:closeNUI', function()
    if charPed and DoesEntityExist(charPed) then
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        charPed = nil
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end)

RegisterNetEvent('drp-characterui:client:chooseChar')
AddEventHandler('drp-characterui:client:chooseChar', function()
    local plyPed = PlayerPedId()
    DoScreenFadeOut(10)
    Citizen.Wait(250)
    FreezeEntityPosition(plyPed, true)
    Citizen.Wait(250)
    openCharMenu(true)
end)

function selectChar()
    openCharMenu(true)
end

local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}

function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(charPed, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(charPed, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(charPed, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(charPed, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(charPed, i-1)
        SetPedPropIndex(
            charPed,
            i-1,
            propZ,
            propTextures[i][2], true
        )
    end
end

local facialWear = {
	[1] = { ["Prop"] = -1, ["Texture"] = -1 },
	[2] = { ["Prop"] = -1, ["Texture"] = -1 },
	[3] = { ["Prop"] = -1, ["Texture"] = -1 },
	[4] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
	[5] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
	[6] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
}

RegisterNetEvent("facewear:ml:update")
AddEventHandler("facewear:ml:update",function()
	for i = 0, 3 do
		if GetPedPropIndex(charPed, i) ~= -1 then
			facialWear[i+1]["Prop"] = GetPedPropIndex(charPed, i)
		end
		if GetPedPropTextureIndex(charPed, i) ~= -1 then
			facialWear[i+1]["Texture"] = GetPedPropTextureIndex(charPed, i)
		end
	end

	if GetPedDrawableVariation(charPed, 1) ~= -1 then
		facialWear[4]["Prop"] = GetPedDrawableVariation(charPed, 1)
		facialWear[4]["Palette"] = GetPedPaletteVariation(charPed, 1)
		facialWear[4]["Texture"] = GetPedTextureVariation(charPed, 1)
	end

	if GetPedDrawableVariation(charPed, 11) ~= -1 then
		facialWear[5]["Prop"] = GetPedDrawableVariation(charPed, 11)
		facialWear[5]["Palette"] = GetPedPaletteVariation(charPed, 11)
		facialWear[5]["Texture"] = GetPedTextureVariation(charPed, 11)
	end
end)

-- TATTOOOS
tattoosList = {
	["mpbusiness_overlays"] = {
		"MP_Buis_M_Neck_000",
		"MP_Buis_M_Neck_001",
		"MP_Buis_M_Neck_002",
		"MP_Buis_M_Neck_003",
		"MP_Buis_M_LeftArm_000",
		"MP_Buis_M_LeftArm_001",
		"MP_Buis_M_RightArm_000",
		"MP_Buis_M_RightArm_001",
		"MP_Buis_M_Stomach_000",
		"MP_Buis_M_Chest_000",
		"MP_Buis_M_Chest_001",
		"MP_Buis_M_Back_000",
		"MP_Buis_F_Chest_000",
		"MP_Buis_F_Chest_001",
		"MP_Buis_F_Chest_002",
		"MP_Buis_F_Stom_000",
		"MP_Buis_F_Stom_001",
		"MP_Buis_F_Stom_002",
		"MP_Buis_F_Back_000",
		"MP_Buis_F_Back_001",
		"MP_Buis_F_Neck_000",
		"MP_Buis_F_Neck_001",
		"MP_Buis_F_RArm_000",
		"MP_Buis_F_LArm_000",
		"MP_Buis_F_LLeg_000",
		"MP_Buis_F_RLeg_000",
	},

	["mphipster_overlays"] = {
		"FM_Hip_M_Tat_000",
		"FM_Hip_M_Tat_001",
		"FM_Hip_M_Tat_002",
		"FM_Hip_M_Tat_003",
		"FM_Hip_M_Tat_004",
		"FM_Hip_M_Tat_005",
		"FM_Hip_M_Tat_006",
		"FM_Hip_M_Tat_007",
		"FM_Hip_M_Tat_008",
		"FM_Hip_M_Tat_009",
		"FM_Hip_M_Tat_010",
		"FM_Hip_M_Tat_011",
		"FM_Hip_M_Tat_012",
		"FM_Hip_M_Tat_013",
		"FM_Hip_M_Tat_014",
		"FM_Hip_M_Tat_015",
		"FM_Hip_M_Tat_016",
		"FM_Hip_M_Tat_017",
		"FM_Hip_M_Tat_018",
		"FM_Hip_M_Tat_019",
		"FM_Hip_M_Tat_020",
		"FM_Hip_M_Tat_021",
		"FM_Hip_M_Tat_022",
		"FM_Hip_M_Tat_023",
		"FM_Hip_M_Tat_024",
		"FM_Hip_M_Tat_025",
		"FM_Hip_M_Tat_026",
		"FM_Hip_M_Tat_027",
		"FM_Hip_M_Tat_028",
		"FM_Hip_M_Tat_029",
		"FM_Hip_M_Tat_030",
		"FM_Hip_M_Tat_031",
		"FM_Hip_M_Tat_032",
		"FM_Hip_M_Tat_033",
		"FM_Hip_M_Tat_034",
		"FM_Hip_M_Tat_035",
		"FM_Hip_M_Tat_036",
		"FM_Hip_M_Tat_037",
		"FM_Hip_M_Tat_038",
		"FM_Hip_M_Tat_039",
		"FM_Hip_M_Tat_040",
		"FM_Hip_M_Tat_041",
		"FM_Hip_M_Tat_042",
		"FM_Hip_M_Tat_043",
		"FM_Hip_M_Tat_044",
		"FM_Hip_M_Tat_045",
		"FM_Hip_M_Tat_046",
		"FM_Hip_M_Tat_047",
		"FM_Hip_M_Tat_048",
	},

	["mpbiker_overlays"] = {
		"MP_MP_Biker_Tat_000_M",
		"MP_MP_Biker_Tat_001_M",
		"MP_MP_Biker_Tat_002_M",
		"MP_MP_Biker_Tat_003_M",
		"MP_MP_Biker_Tat_004_M",
		"MP_MP_Biker_Tat_005_M",
		"MP_MP_Biker_Tat_006_M",
		"MP_MP_Biker_Tat_007_M",
		"MP_MP_Biker_Tat_008_M",
		"MP_MP_Biker_Tat_009_M",
		"MP_MP_Biker_Tat_010_M",
		"MP_MP_Biker_Tat_011_M",
		"MP_MP_Biker_Tat_012_M",
		"MP_MP_Biker_Tat_013_M",
		"MP_MP_Biker_Tat_014_M",
		"MP_MP_Biker_Tat_015_M",
		"MP_MP_Biker_Tat_016_M",
		"MP_MP_Biker_Tat_017_M",
		"MP_MP_Biker_Tat_018_M",
		"MP_MP_Biker_Tat_019_M",
		"MP_MP_Biker_Tat_020_M",
		"MP_MP_Biker_Tat_021_M",
		"MP_MP_Biker_Tat_022_M",
		"MP_MP_Biker_Tat_023_M",
		"MP_MP_Biker_Tat_024_M",
		"MP_MP_Biker_Tat_025_M",
		"MP_MP_Biker_Tat_026_M",
		"MP_MP_Biker_Tat_027_M",
		"MP_MP_Biker_Tat_028_M",
		"MP_MP_Biker_Tat_029_M",
		"MP_MP_Biker_Tat_030_M",
		"MP_MP_Biker_Tat_031_M",
		"MP_MP_Biker_Tat_032_M",
		"MP_MP_Biker_Tat_033_M",
		"MP_MP_Biker_Tat_034_M",
		"MP_MP_Biker_Tat_035_M",
		"MP_MP_Biker_Tat_036_M",
		"MP_MP_Biker_Tat_037_M",
		"MP_MP_Biker_Tat_038_M",
		"MP_MP_Biker_Tat_039_M",
		"MP_MP_Biker_Tat_040_M",
		"MP_MP_Biker_Tat_041_M",
		"MP_MP_Biker_Tat_042_M",
		"MP_MP_Biker_Tat_043_M",
		"MP_MP_Biker_Tat_044_M",
		"MP_MP_Biker_Tat_045_M",
		"MP_MP_Biker_Tat_046_M",
		"MP_MP_Biker_Tat_047_M",
		"MP_MP_Biker_Tat_048_M",
		"MP_MP_Biker_Tat_049_M",
		"MP_MP_Biker_Tat_050_M",
		"MP_MP_Biker_Tat_051_M",
		"MP_MP_Biker_Tat_052_M",
		"MP_MP_Biker_Tat_053_M",
		"MP_MP_Biker_Tat_054_M",
		"MP_MP_Biker_Tat_055_M",
		"MP_MP_Biker_Tat_056_M",
		"MP_MP_Biker_Tat_057_M",
		"MP_MP_Biker_Tat_058_M",
		"MP_MP_Biker_Tat_059_M",
		"MP_MP_Biker_Tat_060_M",
	},

	["mpairraces_overlays"] = {
		"MP_Airraces_Tattoo_000_M",
		"MP_Airraces_Tattoo_001_M",
		"MP_Airraces_Tattoo_002_M",
		"MP_Airraces_Tattoo_003_M",
		"MP_Airraces_Tattoo_004_M",
		"MP_Airraces_Tattoo_005_M",
		"MP_Airraces_Tattoo_006_M",
		"MP_Airraces_Tattoo_007_M",
	},

	["mpbeach_overlays"] = {
		"MP_Bea_M_Back_000",
		"MP_Bea_M_Chest_000",
		"MP_Bea_M_Chest_001",
		"MP_Bea_M_Head_000",
		"MP_Bea_M_Head_001",
		"MP_Bea_M_Head_002",
		"MP_Bea_M_Lleg_000",
		"MP_Bea_M_Rleg_000",
		"MP_Bea_M_RArm_000",
		"MP_Bea_M_Head_000",
		"MP_Bea_M_LArm_000",
		"MP_Bea_M_LArm_001",
		"MP_Bea_M_Neck_000",
		"MP_Bea_M_Neck_001",
		"MP_Bea_M_RArm_001",
		"MP_Bea_M_Stom_000",
		"MP_Bea_M_Stom_001",
	},

	["mpchristmas2_overlays"] = {
		"MP_Xmas2_M_Tat_000",
		"MP_Xmas2_M_Tat_001",
		"MP_Xmas2_M_Tat_003",
		"MP_Xmas2_M_Tat_004",
		"MP_Xmas2_M_Tat_005",
		"MP_Xmas2_M_Tat_006",
		"MP_Xmas2_M_Tat_007",
		"MP_Xmas2_M_Tat_008",
		"MP_Xmas2_M_Tat_009",
		"MP_Xmas2_M_Tat_010",
		"MP_Xmas2_M_Tat_011",
		"MP_Xmas2_M_Tat_012",
		"MP_Xmas2_M_Tat_013",
		"MP_Xmas2_M_Tat_014",
		"MP_Xmas2_M_Tat_015",
		"MP_Xmas2_M_Tat_016",
		"MP_Xmas2_M_Tat_017",
		"MP_Xmas2_M_Tat_018",
		"MP_Xmas2_M_Tat_019",
		"MP_Xmas2_M_Tat_022",
		"MP_Xmas2_M_Tat_023",
		"MP_Xmas2_M_Tat_024",
		"MP_Xmas2_M_Tat_025",
		"MP_Xmas2_M_Tat_026",
		"MP_Xmas2_M_Tat_027",
		"MP_Xmas2_M_Tat_028",
		"MP_Xmas2_M_Tat_029",
	},

	["mpgunrunning_overlays"] = {
		"MP_Gunrunning_Tattoo_000_M",
		"MP_Gunrunning_Tattoo_001_M",
		"MP_Gunrunning_Tattoo_002_M",
		"MP_Gunrunning_Tattoo_003_M",
		"MP_Gunrunning_Tattoo_004_M",
		"MP_Gunrunning_Tattoo_005_M",
		"MP_Gunrunning_Tattoo_006_M",
		"MP_Gunrunning_Tattoo_007_M",
		"MP_Gunrunning_Tattoo_008_M",
		"MP_Gunrunning_Tattoo_009_M",
		"MP_Gunrunning_Tattoo_010_M",
		"MP_Gunrunning_Tattoo_011_M",
		"MP_Gunrunning_Tattoo_012_M",
		"MP_Gunrunning_Tattoo_013_M",
		"MP_Gunrunning_Tattoo_014_M",
		"MP_Gunrunning_Tattoo_015_M",
		"MP_Gunrunning_Tattoo_016_M",
		"MP_Gunrunning_Tattoo_017_M",
		"MP_Gunrunning_Tattoo_018_M",
		"MP_Gunrunning_Tattoo_019_M",
		"MP_Gunrunning_Tattoo_020_M",
		"MP_Gunrunning_Tattoo_021_M",
		"MP_Gunrunning_Tattoo_022_M",
		"MP_Gunrunning_Tattoo_023_M",
		"MP_Gunrunning_Tattoo_024_M",
		"MP_Gunrunning_Tattoo_025_M",
		"MP_Gunrunning_Tattoo_026_M",
		"MP_Gunrunning_Tattoo_027_M",
		"MP_Gunrunning_Tattoo_028_M",
		"MP_Gunrunning_Tattoo_029_M",
		"MP_Gunrunning_Tattoo_030_M",
	},

	["mpimportexport_overlays"] = {
		"MP_MP_ImportExport_Tat_000_M",
		"MP_MP_ImportExport_Tat_001_M",
		"MP_MP_ImportExport_Tat_002_M",
		"MP_MP_ImportExport_Tat_003_M",
		"MP_MP_ImportExport_Tat_004_M",
		"MP_MP_ImportExport_Tat_005_M",
		"MP_MP_ImportExport_Tat_006_M",
		"MP_MP_ImportExport_Tat_007_M",
		"MP_MP_ImportExport_Tat_008_M",
		"MP_MP_ImportExport_Tat_009_M",
		"MP_MP_ImportExport_Tat_010_M",
		"MP_MP_ImportExport_Tat_011_M",
	},

	["mplowrider2_overlays"] = {
		"MP_LR_Tat_000_M",
		"MP_LR_Tat_003_M",
		"MP_LR_Tat_006_M",
		"MP_LR_Tat_008_M",
		"MP_LR_Tat_011_M",
		"MP_LR_Tat_012_M",
		"MP_LR_Tat_016_M",
		"MP_LR_Tat_018_M",
		"MP_LR_Tat_019_M",
		"MP_LR_Tat_022_M",
		"MP_LR_Tat_028_M",
		"MP_LR_Tat_029_M",
		"MP_LR_Tat_030_M",
		"MP_LR_Tat_031_M",
		"MP_LR_Tat_032_M",
		"MP_LR_Tat_035_M",
	},

	["mplowrider_overlays"] = {
		"MP_LR_Tat_001_M",
		"MP_LR_Tat_002_M",
		"MP_LR_Tat_004_M",
		"MP_LR_Tat_005_M",
		"MP_LR_Tat_007_M",
		"MP_LR_Tat_009_M",
		"MP_LR_Tat_010_M",
		"MP_LR_Tat_013_M",
		"MP_LR_Tat_014_M",
		"MP_LR_Tat_015_M",
		"MP_LR_Tat_017_M",
		"MP_LR_Tat_020_M",
		"MP_LR_Tat_021_M",
		"MP_LR_Tat_023_M",
		"MP_LR_Tat_026_M",
		"MP_LR_Tat_027_M",
		"MP_LR_Tat_033_M",
	}
}

local tatCategs = {
    {"ZONE_TORSO", 0},
    {"ZONE_HEAD", 0},
    {"ZONE_LEFT_ARM", 0},
    {"ZONE_RIGHT_ARM", 0},
    {"ZONE_LEFT_LEG", 0},
    {"ZONE_RIGHT_LEG", 0},
    {"ZONE_UNKNOWN", 0},
    {"ZONE_NONE", 0},
}

function AddZoneIDToTattoos()
    tempTattoos = {}
    for key in pairs(tattoosList) do
        for i = 1, #tattoosList[key] do
            if tempTattoos[key] == nil then tempTattoos[key] = {} end
            tempTattoos[key][i] = {
                tattoosList[key][i],
                tatCategs[
                    GetPedDecorationZoneFromHashes(
                        key,
                        GetHashKey(tattoosList[key][i])
                    ) + 1
                ][1]
            }
        end
    end
    tattoosList = tempTattoos
end
AddZoneIDToTattoos()

function CreateHashList()
    tempTattooHashList = {}
    for key in pairs(tattoosList) do
        for i = 1, #tattoosList[key] do
            local categ = tattoosList[key][i][2]
            if tempTattooHashList[categ] == nil then tempTattooHashList[categ] = {} end
            table.insert(
                tempTattooHashList[categ],
                {GetHashKey(tattoosList[key][i][1]),
                GetHashKey(key)}
            )
        end
    end
    return tempTattooHashList
end

function GetTatCategs()
    for key in pairs(tattoosList) do
        for i = 1, #tattoosList[key] do
            local zone = GetPedDecorationZoneFromHashes(
                key,
                GetHashKey(tattoosList[key][i][1])
            )
            tatCategs[zone+1] = {tatCategs[zone+1][1], tatCategs[zone+1][2]+1}
        end
    end
    return tatCategs
end

local tatCategory = GetTatCategs()
local tattooHashList = CreateHashList()

function GetTats(currentTats)
    local tempTats = {}
    if currentTats == nil then return {} end
    for i = 1, #currentTats do
        for key in pairs(tattooHashList) do
            for j = 1, #tattooHashList[key] do
                if tattooHashList[key][j][1] == currentTats[i][2] then
                    tempTats[key] = j
                end
            end
        end
    end
    return tempTats
end

function SetTats(data, currenttats)
    local tempTats = {}
    for k, v in pairs(data) do
        for categ in pairs(tattooHashList) do
            if k == categ then
                local something = tattooHashList[categ][tonumber(v)]
                if something ~= nil then
                    table.insert(tempTats, {something[2], something[1]})
                end
            end
        end
    end
    ClearPedDecorations(charPed)
    if currenttats ~= nil then
        for k,v in pairs(currenttats) do
            AddPedDecorationFromHashes(charPed, v[1], v[2])
        end
        for k,v in pairs(tempTats) do
            AddPedDecorationFromHashes(charPed, v[1], v[2])
        end
    end
end

-- HEAD AND HAIR

local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes","eyecolor"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}

local randommodels = { `a_f_m_prolhost_01`, `a_f_y_hipster_02`, `a_f_y_smartcaspat_01`, `a_m_m_business_01`, `a_m_m_fatlatin_01`, `a_m_m_hasjew_01`, `a_m_m_hillbilly_01`, `a_m_m_og_boss_01`, `s_m_m_highsec_01`, `ig_orleans`, `ig_rashcosvki`, `player_one`, `player_two`, `player_zero`, `ig_tonya`}

function SetHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(charPed, i-1, data[i])
    end
end

function SetHeadOverlayData(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            if data[i].name == "eyecolor" then
                SetPedEyeColor(charPed, tonumber(data[i].val))
            else
                SetPedHeadOverlay(charPed,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            end
            -- SetPedHeadOverlayColor(player, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end

        SetPedHeadOverlayColor(charPed, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(charPed, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(charPed, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(charPed, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(charPed, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(charPed, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(charPed, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(charPed, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(charPed, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(charPed, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(charPed, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(charPed, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

local isBusy = false

local function setDefault(gender)
    if gender ~= nil then
        if gender == 'm' then
            local model = `mp_m_freemode_01`
            RequestModel(model)
            while not HasModelLoaded(model) do Citizen.Wait(0) end
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
            isBusy = false
        elseif gender == 'f' then
            local model = `mp_f_freemode_01`
            RequestModel(model)
            while not HasModelLoaded(model) do Citizen.Wait(0) end
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
            isBusy = false
        end 
    else
        local model = randommodels[math.random(1, #randommodels)]
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end
        FreezeEntityPosition(charPed, false)
        SetEntityInvincible(charPed, true)
        PlaceObjectOnGroundProperly(charPed)
        SetBlockingOfNonTemporaryEvents(charPed, true)
        isBusy = false
    end
end

-- More NUI stuff
RegisterNUICallback('cDataPed', function(data, cb)
    cb('ok')
    print(json.encode(data))
    local cData = data
    while isBusy do Wait(0) end;
    isBusy = true
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    charPed = nil
    if cData ~= nil then
        local thisId = tonumber(cData.KEK)
        print(thisId)
        sentData = CHARACTERS[thisId]['cPed']
        local model = sentData.model 
        if model == nil then setDefault(cData.gender) return end
        model = model ~= nil and tonumber(model) or false
        RequestModel(model) while not HasModelLoaded(model) do Citizen.Wait(0) end
        if not IsModelInCdimage(model) or not IsModelValid(model) then setDefault() return end
        if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
            SetPedRandomComponentVariation(charPed, true)
        else
            SetPedHeadBlendData(charPed, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
            SetPedComponentVariation(charPed, 11, 0, 11, 0)
            SetPedComponentVariation(charPed, 8, 0, 1, 0)
            SetPedComponentVariation(charPed, 6, 1, 2, 0)
            SetPedHeadOverlayColor(charPed, 1, 1, 0, 0)
            SetPedHeadOverlayColor(charPed, 2, 1, 0, 0)
            SetPedHeadOverlayColor(charPed, 4, 2, 0, 0)
            SetPedHeadOverlayColor(charPed, 5, 2, 0, 0)
            SetPedHeadOverlayColor(charPed, 8, 2, 0, 0)
            SetPedHeadOverlayColor(charPed, 10, 1, 0, 0)
            SetPedHeadOverlay(charPed, 1, 0, 0.0)
            SetPedHairColor(charPed, 1, 1)
        end
        FreezeEntityPosition(charPed, false)
        SetEntityInvincible(charPed, true)
        PlaceObjectOnGroundProperly(charPed)
        SetBlockingOfNonTemporaryEvents(charPed, true)
        CreateThread(function()
            SetClothing(sentData.drawables, sentData.props, sentData.drawtextures, sentData.proptextures)
            TriggerEvent("facewear:ml:update")
            SetTats(GetTats(sentData['tattoos']), sentData['tattoos'])
            local head = sentData.headBlend
            local haircolor = sentData.hairColor
        
            if head ~= nil then
                SetPedHeadBlendData(charPed,
                    tonumber(head['shapeFirst']),
                    tonumber(head['shapeSecond']),
                    tonumber(head['shapeThird']),
                    tonumber(head['skinFirst']),
                    tonumber(head['skinSecond']),
                    tonumber(head['skinThird']),
                    tonumber(head['shapeMix']),
                    tonumber(head['skinMix']),
                    tonumber(head['thirdMix']),
                false)
            end
            if sentData.headStructure ~= nil then
                SetHeadStructure(sentData.headStructure)
            end
            if haircolor ~= nil then
                SetPedHairColor(charPed, tonumber(haircolor[1]), tonumber(haircolor[2]))
            end
            if sentData.headOverlay ~= nil then
                SetHeadOverlayData(sentData.headOverlay)
            end
            isBusy = false
        end)
    else
        Citizen.CreateThread(function()
            local model = randommodels[math.random(1, #randommodels)]
            RequestModel(model)
            while not HasModelLoaded(model) do Citizen.Wait(0) end
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
            isBusy = false
        end)
    end
end)

local function DisableControls()
    DisableAllControlActions(0)
    EnableControlAction(0, 174, true)
    EnableControlAction(0, 175, true)
end

AddEventHandler("handleTurning",function(sentData)
    while choosingCharacter do
        Wait(0)
        DisableControls()
        if charPed ~= nil then
            if DoesEntityExist(charPed) then
                if IsControlPressed(0, 174) then
                    SetEntityHeading(charPed, GetEntityHeading(charPed)-3)
                elseif IsControlPressed(0, 175) then
                    SetEntityHeading(charPed, GetEntityHeading(charPed)+3)
                end
            end 
        end
    end
end)

RegisterNetEvent("fetchCharacters")
AddEventHandler("fetchCharacters",function(sentData)
    local data = {}
    CHARACTERS = sentData
    for i=1, #CHARACTERS do
        data[i] = CHARACTERS[i]['info']
        if data[i] ~= nil then data[i]['KEK'] = i end
    end

    SendReactMessage('characterData', data)

end)

RegisterNUICallback('removeBlur', function()
    TriggerEvent('reset-timecycle')
end)

RegisterNUICallback('createNewCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    TriggerServerEvent('echorp:createCharacter', cData)
    if charPed and DoesEntityExist(charPed) then SetEntityAsMissionEntity(charPed, true, true) DeleteEntity(charPed) charPed = nil end
    TriggerEvent('drp-characterui:client:chooseChar')
    cb('ok')
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('echorp:deleteCharacter', data.id)
    if charPed and DoesEntityExist(charPed) then SetEntityAsMissionEntity(charPed, true, true) DeleteEntity(charPed) charPed = nil end
    TriggerEvent('drp-characterui:client:chooseChar')
    cb('ok')
end)

function skyCam(bool)
    if bool then
        DoScreenFadeIn(1000)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetCamActive(cam, false)
        DestroyCam(cam, true)
    end
end

exports('InCharacterUI', function()
    -- exports["drp-characterui"]:InCharacterUI()
    return choosingCharacter
end) -- if exports["drp-characterui"]:InCharacterUI() then return end if exports["drp_clothing"]:inMenu() then return end 



--[[local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterCommand('show-nui', function()
  toggleNuiFrame(true)
  debugPrint('Show NUI frame')
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

RegisterNUICallback('getClientData', function(data, cb)
  debugPrint('Data sent by React', json.encode(data))

-- Lets send back client coords to the React frame for use
  local curCoords = GetEntityCoords(PlayerPedId())

  local retData <const> = { x = curCoords.x, y = curCoords.y, z = curCoords.z }
  cb(retData)
end)]]

