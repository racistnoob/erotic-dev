local clothingShops = {
    {coords = vector3(212.9796, -1377.5498, 30.5875), blip = true, job = 'all'},
}

local barberShops = {
    {coords = vector3(219.7580, -1389.5319, 30.5875), blip = true},
}

local tattoosShops = {
    {coords = vector3(215.8360, -1385.9246, 30.5878), blip = true},
}

local currentMenu = ""
local plyPed, cam, customCam, oldPed = false, false, false, false
local currentTats = {}
local newplayer = false
local nearClothing = 0

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
    
    ["mpchristmas2017_overlays"] = {
        "MP_Christmas2017_Tattoo_000_M",
        "MP_Christmas2017_Tattoo_001_M",
        "MP_Christmas2017_Tattoo_002_M",
        "MP_Christmas2017_Tattoo_003_M",
        "MP_Christmas2017_Tattoo_004_M",
        "MP_Christmas2017_Tattoo_005_M",
        "MP_Christmas2017_Tattoo_006_M",
        "MP_Christmas2017_Tattoo_007_M",
        "MP_Christmas2017_Tattoo_008_M",
        "MP_Christmas2017_Tattoo_009_M",
        "MP_Christmas2017_Tattoo_010_M",
        "MP_Christmas2017_Tattoo_011_M",
        "MP_Christmas2017_Tattoo_012_M",
        "MP_Christmas2017_Tattoo_013_M",
        "MP_Christmas2017_Tattoo_014_M",
        "MP_Christmas2017_Tattoo_015_M",
        "MP_Christmas2017_Tattoo_016_M",
        "MP_Christmas2017_Tattoo_017_M",
        "MP_Christmas2017_Tattoo_018_M",
        "MP_Christmas2017_Tattoo_019_M",
        "MP_Christmas2017_Tattoo_020_M",
        "MP_Christmas2017_Tattoo_021_M",
        "MP_Christmas2017_Tattoo_022_M",
        "MP_Christmas2017_Tattoo_023_M",
        "MP_Christmas2017_Tattoo_024_M",
        "MP_Christmas2017_Tattoo_025_M",
        "MP_Christmas2017_Tattoo_026_M",
        "MP_Christmas2017_Tattoo_027_M",
        "MP_Christmas2017_Tattoo_028_M",
        "MP_Christmas2017_Tattoo_029_M",
    },
    
    ["mpchristmas2018_overlays"] = {
        "MP_Christmas2018_Tat_000_M",
    },
    
    ["mpluxe2_overlays"] = {
        "MP_LUXE_TAT_002_M",
        "MP_LUXE_TAT_005_M",
        "MP_LUXE_TAT_010_M",
        "MP_LUXE_TAT_011_M",
        "MP_LUXE_TAT_012_M",
        "MP_LUXE_TAT_016_M",
        "MP_LUXE_TAT_017_M",
        "MP_LUXE_TAT_018_M",
        "MP_LUXE_TAT_022_M",
        "MP_LUXE_TAT_023_M",
        "MP_LUXE_TAT_025_M",
        "MP_LUXE_TAT_026_M",
        "MP_LUXE_TAT_027_M",
        "MP_LUXE_TAT_028_M",
        "MP_LUXE_TAT_029_M",
        "MP_LUXE_TAT_030_M",
        "MP_LUXE_TAT_031_M",
    },
    
    ["mpluxe_overlays"] = {
        "MP_LUXE_TAT_000_M",
        "MP_LUXE_TAT_001_M",
        "MP_LUXE_TAT_003_M",
        "MP_LUXE_TAT_004_M",
        "MP_LUXE_TAT_006_M",
        "MP_LUXE_TAT_007_M",
        "MP_LUXE_TAT_008_M",
        "MP_LUXE_TAT_009_M",
        "MP_LUXE_TAT_013_M",
        "MP_LUXE_TAT_014_M",
        "MP_LUXE_TAT_015_M",
        "MP_LUXE_TAT_019_M",
        "MP_LUXE_TAT_020_M",
        "MP_LUXE_TAT_021_M",
        "MP_LUXE_TAT_024_M",
    },
    
    ["mpsmuggler_overlays"] = {
        "MP_Smuggler_Tattoo_001_M",
        "MP_Smuggler_Tattoo_002_M",
        "MP_Smuggler_Tattoo_003_M",
        "MP_Smuggler_Tattoo_004_M",
        "MP_Smuggler_Tattoo_005_M",
        "MP_Smuggler_Tattoo_006_M",
        "MP_Smuggler_Tattoo_007_M",
        "MP_Smuggler_Tattoo_008_M",
        "MP_Smuggler_Tattoo_009_M",
        "MP_Smuggler_Tattoo_010_M",
        "MP_Smuggler_Tattoo_011_M",
        "MP_Smuggler_Tattoo_012_M",
        "MP_Smuggler_Tattoo_013_M",
        "MP_Smuggler_Tattoo_014_M",
        "MP_Smuggler_Tattoo_015_M",
        "MP_Smuggler_Tattoo_016_M",
        "MP_Smuggler_Tattoo_017_M",
        "MP_Smuggler_Tattoo_018_M",
        "MP_Smuggler_Tattoo_019_M",
        "MP_Smuggler_Tattoo_020_M",
        "MP_Smuggler_Tattoo_021_M",
        "MP_Smuggler_Tattoo_022_M",
        "MP_Smuggler_Tattoo_023_M",
        "MP_Smuggler_Tattoo_024_M",
        "MP_Smuggler_Tattoo_025_M",
    },
    
    ["mpstunt_overlays"] = {
        "MP_MP_Stunt_Tat_000_M",
        "MP_MP_Stunt_Tat_001_M",
        "MP_MP_Stunt_Tat_002_M",
        "MP_MP_Stunt_Tat_003_M",
        "MP_MP_Stunt_Tat_004_M",
        "MP_MP_Stunt_Tat_005_M",
        "MP_MP_Stunt_Tat_006_M",
        "MP_MP_Stunt_Tat_007_M",
        "MP_MP_Stunt_Tat_008_M",
        "MP_MP_Stunt_Tat_009_M",
        "MP_MP_Stunt_Tat_010_M",
        "MP_MP_Stunt_Tat_011_M",
        "MP_MP_Stunt_Tat_012_M",
        "MP_MP_Stunt_Tat_013_M",
        "MP_MP_Stunt_Tat_014_M",
        "MP_MP_Stunt_Tat_015_M",
        "MP_MP_Stunt_Tat_016_M",
        "MP_MP_Stunt_Tat_017_M",
        "MP_MP_Stunt_Tat_018_M",
        "MP_MP_Stunt_Tat_019_M",
        "MP_MP_Stunt_Tat_020_M",
        "MP_MP_Stunt_Tat_021_M",
        "MP_MP_Stunt_Tat_022_M",
        "MP_MP_Stunt_Tat_023_M",
        "MP_MP_Stunt_Tat_024_M",
        "MP_MP_Stunt_Tat_025_M",
        "MP_MP_Stunt_Tat_026_M",
        "MP_MP_Stunt_Tat_027_M",
        "MP_MP_Stunt_Tat_028_M",
        "MP_MP_Stunt_Tat_029_M",
        "MP_MP_Stunt_Tat_030_M",
        "MP_MP_Stunt_Tat_031_M",
        "MP_MP_Stunt_Tat_032_M",
        "MP_MP_Stunt_Tat_033_M",
        "MP_MP_Stunt_Tat_034_M",
        "MP_MP_Stunt_Tat_035_M",
        "MP_MP_Stunt_Tat_036_M",
        "MP_MP_Stunt_Tat_037_M",
        "MP_MP_Stunt_Tat_038_M",
        "MP_MP_Stunt_Tat_039_M",
        "MP_MP_Stunt_Tat_040_M",
        "MP_MP_Stunt_Tat_041_M",
        "MP_MP_Stunt_Tat_042_M",
        "MP_MP_Stunt_Tat_043_M",
        "MP_MP_Stunt_Tat_044_M",
        "MP_MP_Stunt_Tat_045_M",
        "MP_MP_Stunt_Tat_046_M",
        "MP_MP_Stunt_Tat_047_M",
        "MP_MP_Stunt_Tat_048_M",
        "MP_MP_Stunt_Tat_049_M",
    },
    
    ["multiplayer_overlays"] = {
        "FM_Tat_Award_M_000",
        "FM_Tat_Award_M_001",
        "FM_Tat_Award_M_002",
        "FM_Tat_Award_M_003",
        "FM_Tat_Award_M_004",
        "FM_Tat_Award_M_005",
        "FM_Tat_Award_M_006",
        "FM_Tat_Award_M_007",
        "FM_Tat_Award_M_008",
        "FM_Tat_Award_M_009",
        "FM_Tat_Award_M_010",
        "FM_Tat_Award_M_011",
        "FM_Tat_Award_M_012",
        "FM_Tat_Award_M_013",
        "FM_Tat_Award_M_014",
        "FM_Tat_Award_M_015",
        "FM_Tat_Award_M_016",
        "FM_Tat_Award_M_017",
        "FM_Tat_Award_M_018",
        "FM_Tat_Award_M_019",
        "FM_Tat_M_000",
        "FM_Tat_M_001",
        "FM_Tat_M_002",
        "FM_Tat_M_003",
        "FM_Tat_M_004",
        "FM_Tat_M_005",
        "FM_Tat_M_006",
        "FM_Tat_M_007",
        "FM_Tat_M_008",
        "FM_Tat_M_009",
        "FM_Tat_M_010",
        "FM_Tat_M_011",
        "FM_Tat_M_012",
        "FM_Tat_M_013",
        "FM_Tat_M_014",
        "FM_Tat_M_015",
        "FM_Tat_M_016",
        "FM_Tat_M_017",
        "FM_Tat_M_018",
        "FM_Tat_M_019",
        "FM_Tat_M_011",
        "FM_Tat_M_012",
        "FM_Tat_M_013",
        "FM_Tat_M_014",
        "FM_Tat_M_015",
        "FM_Tat_M_016",
        "FM_Tat_M_017",
        "FM_Tat_M_018",
        "FM_Tat_M_020",
        "FM_Tat_M_021",
        "FM_Tat_M_022",
        "FM_Tat_M_023",
        "FM_Tat_M_024",
        "FM_Tat_M_025",
        "FM_Tat_M_026",
        "FM_Tat_M_027",
        "FM_Tat_M_028",
        "FM_Tat_M_029",
        "FM_Tat_M_030",
        "FM_Tat_M_031",
        "FM_Tat_M_032",
        "FM_Tat_M_033",
        "FM_Tat_M_034",
        "FM_Tat_M_035",
        "FM_Tat_M_036",
        "FM_Tat_M_037",
        "FM_Tat_M_038",
        "FM_Tat_M_039",
        "FM_Tat_M_040",
        "FM_Tat_M_041",
        "FM_Tat_M_042",
        "FM_Tat_M_043",
        "FM_Tat_M_044",
        "FM_Tat_M_045",
        "FM_Tat_M_046",
        "FM_Tat_M_047",
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

local function AddZoneIDToTattoos()
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

local function CreateHashList()
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

local function GetTatCategs()
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

local fr_skins = {
    'mp_f_freemode_01',
}

local frm_skins = {
    'mp_m_freemode_01',
}

local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "shirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes","eyecolor"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}
local tatCategory = GetTatCategs()
local tattooHashList = CreateHashList()

local function GetSkin()
    local entModel = GetEntityModel(PlayerPedId())
    for i = 1, #frm_skins do if GetHashKey(frm_skins[i]) == entModel then return {name="skin_male", value=i} end end
    for i = 1, #fr_skins do if GetHashKey(fr_skins[i]) == entModel then return {name="skin_female", value=i} end end
    return false
end

local function GetDrawables()
    local drawables = {}
    local model = GetEntityModel(PlayerPedId())
    local mpPed = false
    if (model == `mp_f_freemode_01` or model == `mp_m_freemode_01`) then mpPed = true end
    for i = 0, #drawable_names-1 do
        if mpPed and drawable_names[i+1] == "shirts" and GetPedDrawableVariation(plyPed, i) == -1 then SetPedComponentVariation(plyPed, i, 15, 0, 2) end
        drawables[i] = {drawable_names[i+1], GetPedDrawableVariation(plyPed, i)}
    end
    return drawables
end

local function GetProps()
    local props = {}
    for i = 0, #prop_names-1 do props[i] = {prop_names[i+1], GetPedPropIndex(plyPed, i)} end
    return props
end

local function GetDrawTextures()
    local textures = {}
    for i = 0, #drawable_names-1 do table.insert(textures, {drawable_names[i+1], GetPedTextureVariation(plyPed, i)}) end
    return textures
end

local function GetPropTextures()
    local textures = {}
    for i = 0, #prop_names-1 do table.insert(textures, {prop_names[i+1], GetPedPropTextureIndex(plyPed, i)}) end
    return textures
end

local function GetDrawablesTotal()
    local drawables = {}
    for i = 0, #drawable_names - 1 do drawables[i] = {drawable_names[i+1], GetNumberOfPedDrawableVariations(plyPed, i)} end
    return drawables
end

local function GetPropDrawablesTotal()
    local props = {}
    for i = 0, #prop_names - 1 do props[i] = {prop_names[i+1], GetNumberOfPedPropDrawableVariations(plyPed, i)} end
    return props
end

local function GetTextureTotals()
    local values = {}
    local draw = GetDrawables()
    local props = GetProps()
    
    for idx = 0, #draw-1 do
        local name = draw[idx][1]
        local value = draw[idx][2]
        values[name] = GetNumberOfPedTextureVariations(plyPed, idx, value)
    end
    
    for idx = 0, #props-1 do
        local name = props[idx][1]
        local value = props[idx][2]
        values[name] = GetNumberOfPedPropTextureVariations(plyPed, idx, value)
    end
    return values
end

local function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables == nil or drawables[0] == nil then
            if drawable_names[i] == "shirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(plyPed, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(plyPed, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "shirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(plyPed, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(plyPed, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end
    
    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        
        ClearPedProp(plyPed, i-1)
        SetPedPropIndex(plyPed, i-1, propZ, propTextures[i][2], true)
    end
end

local function GetSkinTotal()
    return { #frm_skins, #fr_skins }
end

local toggleClothing = {}

local function has_value (tab, val)
    for index = 1, #tab do
        if tab[index] == val then
            return index-1
        end
    end
    return -1
end

local function ToggleProps(data)
    local name = data["name"]
    selectedValue = has_value(drawable_names, name)
    if (selectedValue > -1) then
        if (toggleClothing[name] ~= nil) then
            SetPedComponentVariation(plyPed, tonumber(selectedValue), tonumber(toggleClothing[name][1]), tonumber(toggleClothing[name][2]), 2)
            toggleClothing[name] = nil
        else
            toggleClothing[name] = { GetPedDrawableVariation(plyPed, tonumber(selectedValue)), GetPedTextureVariation(plyPed, tonumber(selectedValue))	}
            local value = -1
            if name == "shirts" or name == "torsos" then
                value = 15
                if name == "shirts" and GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
                    value = -1
                end
            end
            if name == "legs" then
                value = 14
            end
            SetPedComponentVariation(plyPed, tonumber(selectedValue), value, 0, 2)
        end
    else
        selectedValue = has_value(prop_names, name)
        if (selectedValue > -1) then
            if (toggleClothing[name] ~= nil) then
                SetPedPropIndex(plyPed, tonumber(selectedValue), tonumber(toggleClothing[name][1]), tonumber(toggleClothing[name][2]), true)
                toggleClothing[name] = nil
            else
                toggleClothing[name] = { GetPedPropIndex(plyPed, tonumber(selectedValue)), GetPedPropTextureIndex(plyPed, tonumber(selectedValue)) }
                ClearPedProp(plyPed, tonumber(selectedValue))
            end
        end
    end
end

local function SaveToggleProps()
    for k in pairs(toggleClothing) do
        local name  = k
        selectedValue = has_value(drawable_names, name)
        if (selectedValue > -1) then
            SetPedComponentVariation(plyPed, tonumber(selectedValue), tonumber(toggleClothing[name][1]), tonumber(toggleClothing[name][2]), 2)
            toggleClothing[name] = nil
        else
            selectedValue = has_value(prop_names, name)
            if (selectedValue > -1) then
                SetPedPropIndex(plyPed, tonumber(selectedValue), tonumber(toggleClothing[name][1]), tonumber(toggleClothing[name][2]), true)
                toggleClothing[name] = nil
            end
        end
    end
end

local function SetSkin(model, setDefault)
    SetEntityInvincible(PlayerPedId(), true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        plyPed = PlayerPedId()
        FreezePedCameraRotation(plyPed, true)
                
        if setDefault and model ~= nil then
            if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
                SetPedRandomComponentVariation(PlayerPedId(), true)
            else
                SetPedHeadBlendData(plyPed, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
                SetPedComponentVariation(plyPed, 11, 0, 11, 0)
                SetPedComponentVariation(plyPed, 8, 0, 1, 0)
                SetPedComponentVariation(plyPed, 6, 1, 2, 0)
                SetPedHeadOverlayColor(plyPed, 1, 1, 0, 0)
                SetPedHeadOverlayColor(plyPed, 2, 1, 0, 0)
                SetPedHeadOverlayColor(plyPed, 4, 2, 0, 0)
                SetPedHeadOverlayColor(plyPed, 5, 2, 0, 0)
                SetPedHeadOverlayColor(plyPed, 8, 2, 0, 0)
                SetPedHeadOverlayColor(plyPed, 10, 1, 0, 0)
                SetPedHeadOverlay(plyPed, 1, 0, 0.0)
                SetPedHairColor(plyPed, 1, 1)
            end
        end
        SetPedArmour(plyPed, 100)
    end
    SetEntityInvincible(PlayerPedId(), false)
end

local function SetPedHeadBlend(data)
    if data then
        SetPedHeadBlendData(plyPed, tonumber(data['shapeFirst']), tonumber(data['shapeSecond']), tonumber(data['shapeThird']), tonumber(data['skinFirst']), tonumber(data['skinSecond']), tonumber(data['skinThird']), tonumber(data['shapeMix']), tonumber(data['skinMix']), tonumber(data['thirdMix']), false)
    end
end

local function LoadPed(data)
    SetSkin(data.model, true)
    Citizen.Wait(100)
    SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
    SetPedHairColor(plyPed, tonumber(data.hairColor[1]), tonumber(data.hairColor[2]))
    SetPedHeadBlend(data.headBlend)
    SetHeadStructure(data.headStructure)
    SetHeadOverlayData(data.headOverlay)
end

local function GetPedHeadBlendData()
    local blob = string.rep("\0\0\0\0\0\0\0\0", 6 + 3 + 1)
    if not Citizen.InvokeNative(0x2746BD9D88C5C5D0, plyPed, blob, true) then return nil end
    
    return {
        shapeFirst = string.unpack("<i4", blob, 1),
        shapeSecond = string.unpack("<i4", blob, 9),
        shapeThird = string.unpack("<i4", blob, 17),
        skinFirst = string.unpack("<i4", blob, 25),
        skinSecond = string.unpack("<i4", blob, 33),
        skinThird = string.unpack("<i4", blob, 41),
        shapeMix = string.unpack("<f", blob, 49),
        skinMix = string.unpack("<f", blob, 57),
        thirdMix = string.unpack("<f", blob, 65),
        hasParent = string.unpack("b", blob, 73) ~= 0,
    }
end

local function GetCurrentPed()
    plyPed = PlayerPedId()
    return {
        model = GetEntityModel(plyPed),
        hairColor = GetPedHair(),
        eyecolor = GetPedEyeColor(plyPed),
        headBlend = GetPedHeadBlendData(),
        headOverlay = GetHeadOverlayData(),
        headStructure = GetHeadStructure(),
        drawables = GetDrawables(),
        props = GetProps(),
        drawtextures = GetDrawTextures(),
        proptextures = GetPropTextures(),
    }
end

local function PlayerModel(data)
    local skin = data['value'] == 1 and fr_skins[1] or data['value'] == 0 and frm_skins[1]
    rotation(180.0)
    SetSkin(GetHashKey(skin), true)
    Citizen.Wait(1)
    rotation(180.0)
end

RegisterNUICallback('updateclothes', function(data, cb)
    plyPed = PlayerPedId()
    toggleClothing[data["name"]] = nil
    selectedValue = has_value(drawable_names, data["name"])
    if (selectedValue > -1) then
        SetPedComponentVariation(plyPed, tonumber(selectedValue), tonumber(data["value"]), tonumber(data["texture"]), 2)
        cb({ GetNumberOfPedTextureVariations(plyPed, tonumber(selectedValue), tonumber(data["value"])) })
    else
        selectedValue = has_value(prop_names, data["name"])
        if (tonumber(data["value"]) == -1) then
            ClearPedProp(plyPed, tonumber(selectedValue))
        else
            SetPedPropIndex( plyPed, tonumber(selectedValue), tonumber(data["value"]), tonumber(data["texture"]), true)
        end
        cb({ GetNumberOfPedPropTextureVariations(plyPed, tonumber(selectedValue), tonumber(data["value"])) })
    end
end)

local function RefreshUI(type)
    plyPed = PlayerPedId()
    
    if type then currentMenu = type end
    
    SendNUIMessage({
        type = "totalData",
        drawTotal = GetDrawablesTotal(),
        propDrawTotal = GetPropDrawablesTotal(),
        textureTotal = GetTextureTotals(),
        headoverlayTotal = GetHeadOverlayTotals(),
        skinTotal = GetSkinTotal()
    })
    
    if currentMenu == "Barber" then
        SendNUIMessage({
            type = "barberData",
            headBlend = GetPedHeadBlendData(),
            headOverlay = GetHeadOverlayData(),
            headStructure = GetHeadStructureData()
        })
    end
    
    SendNUIMessage({
        type = "clothingData",
        drawables = GetDrawables(),
        props = GetProps(),
        drawtextures = GetDrawTextures(),
        proptextures = GetPropTextures(),
        skin = GetSkin(),
    })
    
    if currentMenu == "Tattoo" then
        SendNUIMessage({
            type = "tattooData",
            tatCategory = tatCategory,
            tats = GetTats()
        })
    end
end

RegisterNUICallback('setped', function(data, cb)
    PlayerModel(data)
    RefreshUI()
    cb('ok')
end)

RegisterNUICallback('resetped', function(data, cb)
    LoadPed(oldPed)
    cb('ok')
end)

-- Barber Stuff

function GetHeadOverlayData()
    local headData = {}
    for i = 1, #head_overlays do
        if head_overlays[i] == "eyecolor" then
            headData[i] = {}
            headData[i].name = "eyecolor"
            headData[i].val = GetPedEyeColor(plyPed)
        else
            local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(plyPed, i-1)
            if retval then
                headData[i] = {}
                headData[i].name = head_overlays[i]
                headData[i].overlayValue = overlayValue
                headData[i].colourType = colourType
                headData[i].firstColour = firstColour
                headData[i].secondColour = secondColour
                headData[i].overlayOpacity = overlayOpacity
            end
        end
    end
    return headData
end

function SetHeadOverlayData(data)
	if json.encode(data) ~= "[]" then
			for i = 1, #head_overlays do
					if data[i] then
							if data[i].name == "eyecolor" then
									SetPedEyeColor(plyPed, tonumber(data[i].val))
							else
									SetPedHeadOverlay(plyPed,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
							end
					end
					-- SetPedHeadOverlayColor(plyPed, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
			end

			SetPedHeadOverlayColor(plyPed, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
			SetPedHeadOverlayColor(plyPed, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
			SetPedHeadOverlayColor(plyPed, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
			SetPedHeadOverlayColor(plyPed, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
			SetPedHeadOverlayColor(plyPed, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
			SetPedHeadOverlayColor(plyPed, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
			SetPedHeadOverlayColor(plyPed, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
			SetPedHeadOverlayColor(plyPed, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
			SetPedHeadOverlayColor(plyPed, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
			SetPedHeadOverlayColor(plyPed, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
			SetPedHeadOverlayColor(plyPed, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
			SetPedHeadOverlayColor(plyPed, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
	end
end

function GetHeadOverlayTotals()
    local totals = {}
    for i = 1, #head_overlays do
        if head_overlays[i] ~= "eyecolor" then
            totals[head_overlays[i]] = GetNumHeadOverlayValues(i-1)
        end
    end
    return totals
end

function GetPedHair()
    local hairColor = {}
    hairColor[1] = GetPedHairColor(plyPed)
    hairColor[2] = GetPedHairHighlightColor(plyPed)
    return hairColor
end

function GetHeadStructureData()
    local structure = {}
    for i = 1, #face_features do
        structure[face_features[i]] = GetPedFaceFeature(plyPed, i-1)
    end
    return structure
end

function GetHeadStructure(data)
    local structure = {}
    for i = 1, #face_features do
        structure[i] = GetPedFaceFeature(plyPed, i-1)
    end
    return structure
end

function SetHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(plyPed, i-1, data[i])
    end
end


RegisterNUICallback('saveheadblend', function(data, cb)
    plyPed = PlayerPedId()
    SetPedHeadBlendData(plyPed,
    tonumber(data.shapeFirst),
    tonumber(data.shapeSecond),
    tonumber(data.shapeThird),
    tonumber(data.skinFirst),
    tonumber(data.skinSecond),
    tonumber(data.skinThird),
    tonumber(data.shapeMix / 100),
    tonumber(data.skinMix / 100),
    tonumber(data.thirdMix / 100), false)
    cb('ok')
end)

RegisterNUICallback('savehaircolor', function(data, cb)
    if not data['secondColour'] then data['secondColour'] = GetPedHairHighlightColor(PlayerPedId())
    elseif not data['firstColour'] then data['firstColour'] = GetPedHairColor(PlayerPedId()) end
    SetPedHairColor(plyPed, tonumber(data['firstColour']), tonumber(data['secondColour']))
end)

RegisterNUICallback('saveeyecolor', function(data, cb)
    SetPedEyeColor(plyPed,  tonumber(data['firstColour']))
end)

RegisterNUICallback('savefacefeatures', function(data, cb)
    local index = has_value(face_features, data["name"])
    if (index <= -1) then return end
    local scale = tonumber(data["scale"]) / 100
    SetPedFaceFeature(plyPed, index, scale)
    cb('ok')
end)

RegisterNUICallback('saveheadoverlay', function(data, cb)
    local index = has_value(head_overlays, data["name"])
    SetPedHeadOverlay(plyPed,  index, tonumber(data["value"]), tonumber(data["opacity"]) / 100)
    cb('ok')
end)

RegisterNUICallback('saveheadoverlaycolor', function(data, cb)
    local index = has_value(head_overlays, data["name"])
    local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(plyPed, index)
    local sColor = tonumber(data['secondColour'])
    local pColor = tonumber(data['firstColour'])
    if (sColor == nil) then 
        sColor = secondColour
    elseif (pColor == nil) then
        pColor = firstColour
    end
    SetPedHeadOverlayColor(plyPed, index, colourType, pColor, sColor)
    cb('ok')
end)

function EnableGUI(enable, menu)
    plyPed = PlayerPedId()
    enabled = enable
    SetNuiFocus(enable, enable)
    SetNuiFocusKeepInput(enable)
    SendNUIMessage({
        type = "enableClothing",
        allowCancel = canCancel,
        enable = enable,
        menu = menu,
        isService = isService,
    })
    
    if (not enable) then
        currentMenu = ""
        SaveToggleProps()
        plyPed = PlayerPedId()
    end
end

function CustomCamera(position)
    if customCam or position == "torso" then
        FreezePedCameraRotation(plyPed, false)
        SetCamActive(cam, false)
        RenderScriptCams(false,  false,  0,  true,  true)
        if (DoesCamExist(cam)) then
            DestroyCam(cam, false)
        end
        customCam = false
    else
        if (DoesCamExist(cam)) then
            DestroyCam(cam, false)
        end
        
        local pos = GetEntityCoords(plyPed, true)
        SetEntityRotation(plyPed, 0.0, 0.0, 0.0, 1, true)
        FreezePedCameraRotation(plyPed, true)
        
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, plyPed)
        SetCamRot(cam, 0.0, 0.0, 0.0)
        
        SetCamActive(cam, true)
        RenderScriptCams(true,  false,  0,  true,  true)
        
        SwitchCam(position)
        customCam = true
    end
end

function rotation(dir)
    local pedRot = GetEntityHeading(PlayerPedId())+dir
    SetEntityHeading(PlayerPedId(), pedRot % 360)
end

function TogRotation()
    local pedRot = GetEntityHeading(PlayerPedId())+90 % 360
    SetEntityHeading(PlayerPedId(), math.floor(pedRot / 90) * 90.0)
end

function SwitchCam(name)
    if name == "cam" then
        TogRotation()
        return
    end
    
    local pos = GetEntityCoords(plyPed, true)
    local bonepos = false
    if (name == "head") then
        bonepos = GetPedBoneCoords(plyPed, 31086)
        bonepos = vector3(bonepos.x - 0.1, bonepos.y + 0.4, bonepos.z + 0.05)
    end
    if (name == "torso") then
        bonepos = GetPedBoneCoords(plyPed, 11816)
        bonepos = vector3(bonepos.x - 0.4, bonepos.y + 2.2, bonepos.z + 0.2)
    end
    if (name == "leg") then
        bonepos = GetPedBoneCoords(plyPed, 46078)
        bonepos = vector3(bonepos.x - 0.1, bonepos.y + 1, bonepos.z)
    end
    
    SetCamCoord(cam, bonepos.x, bonepos.y, bonepos.z)
    SetCamRot(cam, 0.0, 0.0, 180.0)
end


RegisterNUICallback('escape', function(data, cb)
    DestroyAllCams(true)
    EnableGUI(false, false)
    Save(data['save'])
    ClearPedDecorationsLeaveScars(PlayerPedId())
    TriggerEvent('drp_clothing:retrieve_tats')
    cb('ok')
end)

RegisterNUICallback('switchcam', function(data, cb)
    CustomCamera(data['name'])
    cb('ok')
end)

RegisterNUICallback('toggleclothes', function(data, cb)
    ToggleProps(data)
    cb('ok')
end)

-- Tattoo bs

function GetTats()
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

function AddTats(data)
    for k, v in pairs(data) do
        for categ in pairs(tattooHashList) do
            if k == categ then
                local something = tattooHashList[categ][tonumber(v)]
                if something ~= nil then
                    table.insert(currentTats, {something[2], something[1]})
                end
            end
        end
    end
end

function DeleteTats(data)
    for k, v in pairs(data) do
        for categ in pairs(tattooHashList) do
            if k == categ then
                local something = tattooHashList[categ][tonumber(v)]
                if something ~= nil then
                    for m, w in pairs(currentTats) do
                        if tonumber(w[2]) == tonumber(something[1]) then
                            if tonumber(w[1]) == tonumber(something[2]) then
                                table.remove(currentTats, m)
                                break
                            end 
                        end
                    end
                end
            end
        end
    end
    ClearPedDecorations(PlayerPedId())
    if currentTats ~= nil then
        for k,v in pairs(currentTats) do
            AddPedDecorationFromHashes(PlayerPedId(), v[1], v[2])
        end
    end
end

function SetTats(data)
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
    ClearPedDecorations(PlayerPedId())
    if currentTats ~= nil then
        for k,v in pairs(currentTats) do
            AddPedDecorationFromHashes(PlayerPedId(), v[1], v[2])
        end
        for k,v in pairs(tempTats) do
            AddPedDecorationFromHashes(PlayerPedId(), v[1], v[2])
        end
    end
end

RegisterNUICallback('settats', function(data, cb)
    SetTats(data["tats"])
    cb('ok')
end)

RegisterNUICallback('deletetats', function(data, cb)
    DeleteTats(data["tats"])
    cb('ok')
end)

function ClearAllTats(data)
    ClearPedDecorationsLeaveScars(PlayerPedId())
    currentTats = {}
end

RegisterNUICallback('clearalltats', function(data, cb)
    ClearAllTats()
    cb('ok')
end)

RegisterNUICallback('clearcategtats', function(data, cb)
    local k = data.name
    ClearPedDecorationsLeaveScars(PlayerPedId())
    for categ in pairs(tattooHashList) do
        if k == categ then
            for i=1, 100 do
                local something = tattooHashList[categ][i]
                for k,v in pairs(currentTats) do
                    if (something[2] == v[1]) or (something[1] == v[2]) then
                        table.remove(currentTats, k)
                    end
                end
            end
        end
    end
    if currentTats then
        for k,v in pairs(currentTats) do
            AddPedDecorationFromHashes(PlayerPedId(), v[1], v[2])
        end
    end
    cb('ok')
end)

RegisterNUICallback('previewtat', function(data, cb)
    local k = data.name
    local v = tonumber(data.value)
    ClearPedDecorationsLeaveScars(PlayerPedId())
    if currentTats then
        for k,v in pairs(currentTats) do
            AddPedDecorationFromHashes(PlayerPedId(), v[1], v[2])
        end
    end
    for categ in pairs(tattooHashList) do
        if k == categ then
            local something = tattooHashList[categ][v]
            if something then
                AddPedDecorationFromHashes(PlayerPedId(), something[2], something[1])
                break
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('addtat', function(data, cb)
    local k = data.name
    local v = tonumber(data.value)
    for categ in pairs(tattooHashList) do
        if k == categ then
            local something = tattooHashList[categ][v]
            if something then
                table.insert(currentTats, {something[2], something[1]})
                break
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('removetat', function(data, cb)
    local k = data.name
    local v = tonumber(data.value)
    
    for categ in pairs(tattooHashList) do
        if k == categ then
            local something = tattooHashList[categ][v]
            if something then
                for s, h in pairs(currentTats) do
                    if something[2] == h[1] then
                        if something[1] == h[2] then
                            table.remove(currentTats, s)
                            ClearPedDecorationsLeaveScars(PlayerPedId())
                            if currentTats then
                                for k,v in pairs(currentTats) do
                                    AddPedDecorationFromHashes(PlayerPedId(), v[1], v[2])
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
    cb('ok')
end)

-- Main stuff

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local scale = 0.45
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function OpenMenu(name)
    plyPed = PlayerPedId()
    oldPed = GetCurrentPed()
    local isAllowed = false
    if(oldPed.model == 1885233650 or oldPed.model == -1667301416) then isAllowed = true end
    if((oldPed.model ~= 1885233650 or oldPed.model ~= -1667301416) and (name == "Clothing" or name == "Tattoo")) then isAllowed = true end
    if isAllowed then
        FreezePedCameraRotation(plyPed, true)
        RefreshUI(name)
        EnableGUI(true, name)
    end
end

function Save(save)
    if save then
        data = GetCurrentPed()
        if data.model == `mp_f_freemode_01` or data.model == `mp_m_freemode_01` then
            if data.headBlend == "null" or data.headBlend == nil then
                data.headBlend = {}
            end
            SetResourceKvp("character_current", json.encode(data))
            SetResourceKvp("character_face", json.encode(data))
            SetResourceKvp("playersTattoos", json.encode(currentTats))
        end
    else
        LoadPed(oldPed)
    end
    CustomCamera('torso')
end

local function IsNearShop(shops, pos)
    local job = nil
    local dstchecked = 750
    local coordsabove = nil
    for i = 1, #shops do
        local coords = shops[i]['coords']
        local jobs = shops[i]['job']
        local comparedst = #(pos - coords)
        if comparedst < dstchecked then dstchecked, coordsabove, job = comparedst, coords, jobs end
    end
    local data = {dstchecked, coordsabove, job}
    return data
end


RegisterNetEvent("drp_clothing:retrieve_tats")
AddEventHandler("drp_clothing:retrieve_tats", function()
    local kvpValue = GetResourceKvpString("playersTattoos")
    if kvpValue then
        local data = json.decode(kvpValue)
        TriggerEvent("drp_clothing:settattoos", data)
    else
        TriggerEvent("drp_clothing:settattoos", {})
    end
end)

local promptstatus = 0

CreateThread(function()
    
    for i=1, #clothingShops do
        if clothingShops[i]['blip'] then
            exports['core']:createBlip({
                resource = GetCurrentResourceName(),
                group = "Clothing",
                coords = clothingShops[i]['coords'],
                sprite = 73,
                scale = 0.7,
                color = 81,
                shortrange = true,
                text = 'Clothing Store'
            })
        end
    end
    
    for i=1, #barberShops do
        if barberShops[i]['blip'] then
            exports['core']:createBlip({
                resource = GetCurrentResourceName(),
                group = "Barber",
                coords = barberShops[i]['coords'],
                sprite = 71,
                scale = 0.7,
                color = 51,
                shortrange = true,
                text = 'Barber Shop'
            })
        end
    end
    
    for i=1, #tattoosShops do
        if tattoosShops[i]['blip'] then
            exports['core']:createBlip({
                resource = GetCurrentResourceName(),
                group = "Tattoo",
                coords = tattoosShops[i]['coords'],
                sprite = 75,
                scale = 0.7,
                color = 1,
                shortrange = true,
                text = 'Tattoo Shop'
            })
        end
    end
    
    while true do
        local sleepTimer = 1500
        if exports["noob"]:inSafeZone() then
            local plyPos = GetEntityCoords(PlayerPedId())
            local clothShop = IsNearShop(clothingShops, plyPos)
            local nearcloth = clothShop[1]
            local shopCoords = clothShop[2]
            nearClothing = nearcloth
            
            local currMenu = ""
            local allowed = false
            
            if nearcloth < 6.0 then
                allowed = true
                sleepTimer = 1
                
                if allowed and nearcloth > 0.65 then
                    DrawMarker(1, shopCoords.x, shopCoords.y, shopCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 159, 72, 240, 120, false, true, 2, nil, nil, false)
                    DrawText3D(shopCoords.x, shopCoords.y, shopCoords.z + 0.5, "Press ~h~H~h~ For Clothing")
                end						
                if nearcloth < 2.0 and allowed then
                    sleepTimer = 0
                    currMenu = "Clothing"
                    if promptstatus == 0 then
                        --TriggerEvent('drp-prompts:ShowUI', 'show', '[H] '..currMenu)
                        promptstatus = 1
                    end
                end
            end
            
            if sleepTimer ~= 0 then
                local tatShop = IsNearShop(tattoosShops, plyPos)
                local neartat = tatShop[1]
                local shopCoords = tatShop[2]
                if neartat < 6.0 then
                    sleepTimer = 1
                    if neartat > 0.65 then
                        DrawMarker(1, shopCoords.x, shopCoords.y, shopCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 159, 72, 240, 120, false, true, 2, nil, nil, false)
                        DrawText3D(shopCoords.x, shopCoords.y, shopCoords.z + 0.5, "Speak to Harold (~h~H~h~) For Tattoos")
                    end
                    if neartat < 2.0 then
                        sleepTimer = 0
                        currMenu = "Tattoo"
                        if promptstatus == 0 then
                            --TriggerEvent('drp-prompts:ShowUI', 'show', '[H] '..currMenu)
                            promptstatus = 1
                        end
                    end
                end
            end
            
            if sleepTimer ~= 0 then
                local barbShop = IsNearShop(barberShops, plyPos)
                local nearbarber = barbShop[1]
                local shopCoords = barbShop[2]
                if nearbarber < 6.0 then
                    sleepTimer = 1
                    if nearbarber > 0.65 then
                        DrawMarker(1, shopCoords.x, shopCoords.y, shopCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 159, 72, 240, 120, false, true, 2, nil, nil, false)
                        DrawText3D(shopCoords.x, shopCoords.y, shopCoords.z + 0.5, "Press ~h~H~h~ For Barber")
                    end
                    
                    if nearbarber < 2.0 then
                        sleepTimer = 0
                        currMenu = "Barber"
                        if promptstatus == 0 then
                            --TriggerEvent('drp-prompts:ShowUI', 'show', '[H] '..currMenu)
                            promptstatus = 1
                        end
                    end
                end
            end
            
            if currMenu ~= "" then
                if IsControlJustReleased(0, 74) then
                    ClearPedDecorationsLeaveScars(PlayerPedId())
                    TriggerEvent('drp_clothing:retrieve_tats')
                    OpenMenu(currMenu)
                end
            else
                if promptstatus == 1 then
                    TriggerEvent('drp-prompts:HideUI')
                    allowed = false
                    promptstatus = 0
                end
            end
        else
            sleepTimer = 3000
        end
        Wait(sleepTimer)
    end
end)

RegisterNetEvent("drp_clothing:setpedfeatures")
AddEventHandler("drp_clothing:setpedfeatures", function(data)
    plyPed = PlayerPedId()
    if data == false then SetSkin(GetEntityModel(plyPed), true) return end
    local head = data.headBlend
    local haircolor = data.hairColor
    SetPedHeadBlendData(plyPed, tonumber(head['shapeFirst']), tonumber(head['shapeSecond']), tonumber(head['shapeThird']), tonumber(head['skinFirst']), tonumber(head['skinSecond']), tonumber(head['skinThird']), tonumber(head['shapeMix']), tonumber(head['skinMix']), tonumber(head['thirdMix']), false)
    SetHeadStructure(data.headStructure)
    SetPedHairColor(plyPed, tonumber(haircolor[1]), tonumber(haircolor[2]))
    SetHeadOverlayData(data.headOverlay)
end)

RegisterNetEvent("drp_clothing:setclothes")
AddEventHandler("drp_clothing:setclothes", function(data,alreadyExist,firstspawn, kvpArmour, kvpStress, kvpThirst, kvpHunger)
    plyPed = PlayerPedId()
    local function setDefault()
        CreateThread(function()
            SetSkin(`mp_m_freemode_01`, true)
            --DestroyAllCams(false)
            --RenderScriptCams(false, true, 1, true, true)
            --OpenMenu("Clothing")
            --newplayer, inClothes = true, true
            --SetEntityCoords(PlayerPedId(),221.1265, -1376.3824, 30.5432)
            --SetEntityHeading(PlayerPedId(),191.9764)
            --exports['erotic-lobby']:switchWorld(1)
            --DoScreenFadeIn(50)
            --DestroyAllCams(false)
            --RenderScriptCams(false, true, 1, true, true)
            plyPed = PlayerPedId()
        end)
    end
    
    if not data.model and alreadyExist == nil then setDefault() return end
    if not data.model and alreadyExist ~= nil then return end
    model = data.model
    model = model ~= nil and tonumber(model) or false
    if not IsModelInCdimage(model) or not IsModelValid(model) then setDefault() return end
    SetSkin(model, false)
    Wait(100) SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures) Wait(100)
    DestroyAllCams(false)
    RenderScriptCams(false, true, 1, true, true)
    exports['drp-notifications']:SendAlert('inform', 'Press F1 for Help Page', 10000)
    DoScreenFadeIn(50)
    DestroyAllCams(false)
    RenderScriptCams(false, true, 1, true, true)
    TriggerEvent("facewear:update")

    local kvpValue = GetResourceKvpString("character_face")
    if kvpValue then
        local data = json.decode(kvpValue)
        if data.model == 1885233650 or data.model == -1667301416 then
            TriggerEvent("drp_clothing:setpedfeatures", data)
        end
    else
        TriggerEvent("drp_clothing:setpedfeatures", false)
    end

    TriggerEvent('drp_clothing:retrieve_tats')
    plyPed = PlayerPedId()
    SetPedArmour(plyPed, 100)
end)
-- #DL
RegisterNetEvent("drp_clothing:settattoos")
AddEventHandler("drp_clothing:settattoos", function(playerTattoosList)
    currentTats = playerTattoosList
    SetTats(GetTats())
end)

RegisterCommand("g1", function(source, args, rawCommand) TriggerEvent("facewear:adjust",2,false) end, false)
RegisterCommand("g0", function(source, args, rawCommand) TriggerEvent("facewear:adjust",2,true) end, false)
RegisterCommand("e1", function(source, args, rawCommand) TriggerEvent("facewear:adjust",3,false) end, false)
RegisterCommand("e0", function(source, args, rawCommand) TriggerEvent("facewear:adjust",3,true) end, false)
RegisterCommand("m1", function(source, args, rawCommand) TriggerEvent("facewear:adjust",4,false) end, false)
RegisterCommand("m0", function(source, args, rawCommand) TriggerEvent("facewear:adjust",4,true) end, false)
RegisterCommand("t1", function(source, args, rawCommand) TriggerEvent("facewear:adjust",5,false) end, false)
RegisterCommand("t0", function(source, args, rawCommand) TriggerEvent("facewear:adjust",5,true) end, false)
RegisterCommand("h1", function(source, args, rawCommand) TriggerEvent("facewear:adjust",6,false) end, false)
RegisterCommand("h0", function(source, args, rawCommand) TriggerEvent("facewear:adjust",6,true) end, false)


local facialWear = {
    [1] = { ["Prop"] = -1, ["Texture"] = -1 },
    [2] = { ["Prop"] = -1, ["Texture"] = -1 },
    [3] = { ["Prop"] = -1, ["Texture"] = -1 },
    [4] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 },
    [5] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 },
    [6] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, 
}

--arms 4
-- face 0
RegisterNetEvent("facewear:update")
AddEventHandler("facewear:update",function()
    for i = 0, 3 do
        if GetPedPropIndex(PlayerPedId(), i) ~= -1 then
            facialWear[i+1]["Prop"] = GetPedPropIndex(PlayerPedId(), i)
        end
        if GetPedPropTextureIndex(PlayerPedId(), i) ~= -1 then
            facialWear[i+1]["Texture"] = GetPedPropTextureIndex(PlayerPedId(), i)
        end
    end
    
    if GetPedDrawableVariation(PlayerPedId(), 1) ~= -1 then
        facialWear[4]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 1)
        facialWear[4]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 1)
        facialWear[4]["Texture"] = GetPedTextureVariation(PlayerPedId(), 1)
    end
    
    if GetPedDrawableVariation(PlayerPedId(), 11) ~= -1 then
        facialWear[5]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 11)
        facialWear[5]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 11)
        facialWear[5]["Texture"] = GetPedTextureVariation(PlayerPedId(), 11)
    end
end)

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
end

RegisterNetEvent("facewear:adjust")
AddEventHandler("facewear:adjust",function(faceType,remove)
    local AnimSet = "none"
    local AnimationOn = "none"
    local AnimationOff = "none"
    local PropIndex = 0
    
    local AnimSet = "mp_masks@on_foot"
    local AnimationOn = "put_on_mask"
    local AnimationOff = "put_on_mask"
    
    facialWear[6]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 0)
    facialWear[6]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 0)
    facialWear[6]["Texture"] = GetPedTextureVariation(PlayerPedId(), 0)
    
    for i = 0, 3 do
        if GetPedPropIndex(PlayerPedId(), i) ~= -1 then
            facialWear[i+1]["Prop"] = GetPedPropIndex(PlayerPedId(), i)
        end
        if GetPedPropTextureIndex(PlayerPedId(), i) ~= -1 then
            facialWear[i+1]["Texture"] = GetPedPropTextureIndex(PlayerPedId(), i)
        end
    end
    
    if GetPedDrawableVariation(PlayerPedId(), 1) ~= -1 then
        facialWear[4]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 1)
        facialWear[4]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 1)
        facialWear[4]["Texture"] = GetPedTextureVariation(PlayerPedId(), 1)
    end
    
    if GetPedDrawableVariation(PlayerPedId(), 11) ~= -1 then
        facialWear[5]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 11)
        facialWear[5]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 11)
        facialWear[5]["Texture"] = GetPedTextureVariation(PlayerPedId(), 11)
    end
    
    if faceType == 1 then
        PropIndex = 0
    elseif faceType == 2 then
        PropIndex = 1
        AnimSet, AnimationOn, AnimationOff = "clothingspecs", "take_off", "take_off"
    elseif faceType == 3 then
        PropIndex = 2
    elseif faceType == 4 then
        PropIndex = 1
        if remove then AnimSet, AnimationOn, AnimationOff = "missfbi4", "takeoff_mask", "takeoff_mask" end
    elseif faceType == 5 then
        PropIndex = 11
        AnimSet, AnimationOn, AnimationOff = "oddjobs@basejump@ig_15", "puton_parachute", "puton_parachute"
    end
    
    loadAnimDict(AnimSet)
    if faceType == 5 then
        if remove then
            SetPedComponentVariation(PlayerPedId(), 3, 2, facialWear[6]["Texture"], facialWear[6]["Palette"])
        end
    end
    if remove then
        TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOff, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
        Citizen.Wait(500)
        if faceType ~= 5 then
            if faceType == 4 then
                SetPedComponentVariation(PlayerPedId(), PropIndex, -1, -1, -1)
            else
                if faceType ~= 2 then
                    ClearPedProp(PlayerPedId(), tonumber(PropIndex))
                end
            end
        end
    else
        TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOn, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
        Citizen.Wait(500)
        if faceType ~= 5 and faceType ~= 2 then
            if faceType == 4 then
                SetPedComponentVariation(PlayerPedId(), PropIndex, facialWear[faceType]["Prop"], facialWear[faceType]["Texture"], facialWear[faceType]["Palette"])
            else
                SetPedPropIndex( PlayerPedId(), tonumber(PropIndex), tonumber(facialWear[PropIndex+1]["Prop"]), tonumber(facialWear[PropIndex+1]["Texture"]), false)
            end
        end
    end
    if faceType == 5 then
        if not remove then
            SetPedComponentVariation(PlayerPedId(), 3, 1, facialWear[6]["Texture"], facialWear[6]["Palette"])
            SetPedComponentVariation(PlayerPedId(), PropIndex, facialWear[faceType]["Prop"], facialWear[faceType]["Texture"], facialWear[faceType]["Palette"])
        else
            SetPedComponentVariation(PlayerPedId(), PropIndex, -1, -1, -1)
        end
        Citizen.Wait(1800)
    end
    if faceType == 2 then
        Citizen.Wait(600)
        if remove then
            ClearPedProp(PlayerPedId(), tonumber(PropIndex))
        end
        
        if not remove then
            Citizen.Wait(140)
            SetPedPropIndex( PlayerPedId(), tonumber(PropIndex), tonumber(facialWear[PropIndex+1]["Prop"]), tonumber(facialWear[PropIndex+1]["Texture"]), false)
        end
    end
    if faceType == 4 and remove then
        Citizen.Wait(1200)
    end
    ClearPedTasks(PlayerPedId())
end)

CreateThread(function()
    while true do
        Wait(0)
        if currentMenu ~= "" then
            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
            EnableControlAction(0, 34, true)
            EnableControlAction(0, 35, true)
            EnableControlAction(0, 25, true)
            EnableControlAction(0, 249, true)
            if IsControlPressed(0, 34) then
                local charPed = PlayerPedId()
                SetEntityHeading(charPed, GetEntityHeading(charPed)-3)
            elseif IsControlPressed(0, 35) then
                local charPed = PlayerPedId()
                SetEntityHeading(charPed, GetEntityHeading(charPed)+3)
            end
        else
            Wait(1500)
        end
    end
end)

RegisterNetEvent('clothing:checkIfNew')
AddEventHandler('clothing:checkIfNew', function()
    local kvpValue = GetResourceKvpString("character_current")
    if kvpValue then
        local skin = json.decode(kvpValue)
        local temp_data = {
            model = skin.model,
            drawables = skin.drawables,
            props = skin.props,
            drawtextures = skin.drawtextures,
            proptextures = skin.proptextures,
        }
        TriggerEvent("drp_clothing:setclothes", temp_data, 0, false)
    else
        TriggerEvent('drp_clothing:setclothes',{},nil,true)
    end
end)

exports('inMenu', function() return currentMenu ~= "" end)
exports('nearClothing', function() return nearClothing end)

local peds = {
	{
	  	coords = vector3(211.5664, -1379.2432, 29.5875),
	  	heading = 320.5612,
	  	pedModel = "a_f_y_fitness_02",
        scenario = "",
	},
    {
        coords = vector3(214.8360, -1386.9246, 29.5875),
        heading = 320.5612,
        pedModel = "CSB_DJBlaMadon",
        scenario = "",
    },
    {
        coords = vector3(218.7580, -1390.8319, 29.5875),
        heading = 320.5612,
        pedModel = "A_M_Y_Beach_03",
        scenario = "PROP_HUMAN_SEAT_CHAIR",
    },
    {
        coords = vector3(218.7580, -1390.8319, 29.5875),
        heading = 320.5612,
        pedModel = "A_C_Boar",
        scenario = "",
    },
}
  
function CreatePeds(pedsData)
	for _, pedData in pairs(pedsData) do
		local pedCoords = pedData.coords
  
		RequestModel(pedData.pedModel)
		
		while not HasModelLoaded(pedData.pedModel) do
			Wait(1)
		end
		
		local ped = CreatePed(4, pedData.pedModel, pedCoords, pedData.heading, false, false)
		SetEntityInvincible(ped, true)
		SetPedFleeAttributes(ped, 0, false)
		SetBlockingOfNonTemporaryEvents(ped, true)
		
		TaskStartScenarioInPlace(ped, pedData.scenario, -1)
		
		FreezeEntityPosition(ped, true)
        if pedData.pedModel == "A_M_Y_Beach_03" then
            SetPedDefaultComponentVariation(ped)
        end
	end
end
  
CreatePeds(peds)