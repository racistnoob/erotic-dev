
WEAPON_TINTS = {
    [1] = { --[[@normal_weapons]]
    [1] = { label = "None", price = 0 },
    [2] = { label = "Green", price = 2000 },
    [3] = { label = "Gold", price = 2000 },
    [4] = { label = "Pink", price = 2000 },
    [5] = { label = "Army", price = 2000 },
    [6] = { label = "LSPD", price = 2000 },
    [7] = { label = "Orange", price = 2000 },
    [8] = { label = "Platinum", price = 2000 },
},
[2] = { --[[@mk2_weapons]]
[1] = { label = "None", price = 0 },
[2] = { label = "Gray", price = 2000 },
[3] = { label = "Two-Tone", price = 2000 },
[4] = { label = "White", price = 2000 },
[5] = { label = "Beige", price = 2000 },
[6] = { label = "Green", price = 2000 },
[7] = { label = "Blue", price = 2000 },
[8] = { label = "Earth", price = 2000 },
[9] = { label = "Brown & Black", price = 3000 },
[10] = { label = "Red Contrast", price = 2000 },
[11] = { label = "Blue Contrast", price = 2000 },
[12] = { label = "Yellow Contrast", price = 2000 },
[13] = { label = "Orange Contrast", price = 2000 },
[14] = { label = "Pink", price = 2000 },
[15] = { label = "Purple & Yellow", price = 3000 },
[16] = { label = "Orange", price = 2000 },
[17] = { label = "Green & Purple", price = 2500 },
[18] = { label = "Red Features", price = 2000 },
[19] = { label = "Green Features", price = 2000 },
[20] = { label = "Cyan Features", price = 2000 },
[21] = { label = "Yellow Features", price = 2000 },
[22] = { label = "Red & White", price = 3000 },
[23] = { label = "Blue & White", price = 3000 },
[24] = { label = "Gold", price = 2000 },
[25] = { label = "Platinum", price = 2000 },
[26] = { label = "Gray & Lilac", price = 3000 },
[27] = { label = "Purple & Lime", price = 3000 },
[28] = { label = "Red", price = 2000 },
[29] = { label = "Green", price = 2000 },
[30] = { label = "Blue", price = 2000 },
[31] = { label = "White & Aqua", price = 3000 },
[32] = { label = "Orange & Yellow", price = 3000 },
[33] = { label = "Red & Yellow", price = 3000 },
}

}

WEAPON_LIST = {
    --[[@PISTOLS]]
    [`WEAPON_PISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_PISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_PISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 5000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOL_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 3500
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SNSPISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_SNSPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_SNSPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 6000
        --         },
        --     },
        -- },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_COMBATPISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_COMBATPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_COMBATPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 7000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
                    label = "Deluxe",
                    price = 1000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_1911`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH_02",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
    },
    [`WEAPON_REVOLVER`] = {
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_REVOLVER_VARMOD_BOSS",
                    label = "Boss",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_REVOLVER_VARMOD_GOON",
                    label = "Goon",
                    price = 4000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_CERAMICPISTOL`] = {
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CERAMICPISTOL_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_FNX45`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH_02",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
    },
    [`WEAPON_SP45`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH_02",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 8000
                },
            },
        },
    },
    [`WEAPON_PISTOLXM3`] = {
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOLXM3_SUPP",
                    label = "Suppressor",
                    price = 7000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_PISTOL50`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_PISTOL50_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_PISTOL50_CLIP_02",
        --             label = "Extended Mag",
        --             price = 20000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 10000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_PISTOL50_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_DEAGLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_deserteagle_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_deserteagle_CLIP_02",
        --             label = "Extended Mag",
        --             price = 20000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_VINTAGEPISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_VINTAGEPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_VINTAGEPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 6000
        --         },
        --     },
        -- },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_APPISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_APPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_APPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 15000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 10000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_APPISTOL_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_M45A1`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_HEAVYPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_HEAVYPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 100
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_M45A1_FLSH_01",
                    label = "Flashlight",
                    price = 100
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_M45A1_SUPP_01",
                    label = "Suppressor",
                    price = 100
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_HEAVYPISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_HEAVYPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_HEAVYPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 100
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 100
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 100
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYPISTOL_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 10000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@SMG]]
    [`WEAPON_MACHINEPISTOL`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_MACHINEPISTOL_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_MACHINEPISTOL_CLIP_02",
        --             label = "Extended Mag",
        --             price = 12000
        --         },
        --         {
        --             attachment = "COMPONENT_MACHINEPISTOL_CLIP_03",
        --             label = "Drum Mag",
        --             price = 100000
        --         },
        --     },
        -- },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_MINISMG`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_MINISMG_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_MINISMG_CLIP_02",
        --             label = "Extended Mag",
        --             price = 15000
        --         },
        --     },
        -- },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_MICROSMG`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_MICROSMG_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_MICROSMG_CLIP_02",
        --             label = "Extended Mag",
        --             price = 20000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO",
                    label = "Red Dot",
                    price = 2500
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MICROSMG_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SMG_MK2`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_SMG_MK2_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_SMG_MK2_CLIP_02",
        --             label = "Extended Mag",
        --             price = 20000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_PI_SUPP",
                    label = "Suppressor",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_01",
                    label = "Flat Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_02",
                    label = "Tactical Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_03",
                    label = "Fat Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_04",
                    label = "Precision Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_05",
                    label = "Heavy Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_06",
                    label = "Slanted Muzzle",
                    price = 15000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_07",
                    label = "Split Muzzle",
                    price = 15000
                },
            },
        },
        -- {
        --     label = "Barrel",
        --     bone = "WAPBarrel",
        --     options = {
        --         {
        --             attachment = "COMPONENT_AT_SB_BARREL_01",
        --             label = "Standard Barrel",
        --             price = 0
        --         },
        --         -- {
        --         --     attachment = "COMPONENT_AT_SB_BARREL_02",
        --         --     label = "Heavy Barrel",
        --         --     price = 20000
        --         -- },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SIGHTS_SMG",
                    label = "Reflex Sight",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
                    label = "Red Dot",
                    price = 3000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
                    label = "ACOG Scope",
                    price = 3000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO",
                    label = "Digital",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_02",
                    label = "Brushstroke",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_03",
                    label = "Woodland",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_04",
                    label = "Skull",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_05",
                    label = "Sessanta",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_06",
                    label = "Perseus",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_07",
                    label = "Leopard",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_08",
                    label = "Zebra",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_09",
                    label = "Geometric",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_10",
                    label = "Boom!",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SMG_MK2_CAMO_IND_01",
                    label = "Patriotic",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_ASSAULTSMG`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_ASSAULTSMG_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_ASSAULTSMG_CLIP_02",
        --             label = "Extended Mag",
        --             price = 20000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 1500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 15000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO",
                    label = "Red Dot",
                    price = 2500
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@SHOTGUNS]]
    [`WEAPON_DBSHOTGUN`] = {
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SAWNOFFSHOTGUN`] = {
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
    },
    --[[@RIFLES]]
    [`WEAPON_BULLPUPRIFLE`] = {
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 2500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_SMALL",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 12000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_BULLPUPRIFLE_VARMOD_LOW",
                    label = "Deluxe",
                    price = 5000
                },
            }
        }
    },
    [`WEAPON_CARBINERIFLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_CARBINERIFLE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_CARBINERIFLE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 30000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 2500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 12000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_GUSENBERG`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_GUSENBERG_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_GUSENBERG_CLIP_02",
        --             label = "Drum Mag",
        --             price = 100000
        --         },
        --     },
        -- },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_COMBATPDW`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip_2",
        --     options = {
        --         {
        --             attachment = "COMPONENT_COMBATPDW_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_COMBATPDW_CLIP_02",
        --             label = "Drum Mag",
        --             price = 100000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 20000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 12000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_COMPACTRIFLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip_2",
        --     options = {
        --         {
        --             attachment = "COMPONENT_COMPACTRIFLE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_COMPACTRIFLE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 30000
        --         },
        --         {
        --             attachment = "COMPONENT_COMPACTRIFLE_CLIP_03",
        --             label = "Drum Mag",
        --             price = 100000
        --         },
        --     },
        -- },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SPECIALCARBINE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_SPECIALCARBINE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_SPECIALCARBINE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_HEAVYRIFLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip_2",
        --     options = {
        --         {
        --             attachment = "COMPONENT_HEAVYRIFLE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_HEAVYRIFLE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYRIFLE_SIGHT_01",
                    label = "Iron Sights",
                    price = 100
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip_3",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_HEAVYRIFLE_CAMO1",
                    label = "GSF",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_ASSAULTRIFLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_ASSAULTRIFLE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_ASSAULTRIFLE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 40000
        --         },
        --         {
        --             attachment = "COMPONENT_ASSAULTRIFLE_CLIP_03",
        --             label = "Drum Mag",
        --             price = 100000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO",
                    label = "Red Dot",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_TACTICALRIFLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_TACTICALRIFLE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_TACTICALRIFLE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH_REH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 15000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_ADVANCEDRIFLE`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_ADVANCEDRIFLE_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_ADVANCEDRIFLE_CLIP_02",
        --             label = "Extended Mag",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
            },
        },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_SMALL",
                    label = "Red Dot",
                    price = 3500
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },

    },
    [`WEAPON_762`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
        --             label = "Extended Mag",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Flashlight",
            bone = "WAPFlshLasr",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_FLSH",
                    label = "Flashlight",
                    price = 3500
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP",
                    label = "Suppressor",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_01",
                    label = "Flat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_02",
                    label = "Tactical Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_03",
                    label = "Fat Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_04",
                    label = "Precision Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_05",
                    label = "Heavy Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_06",
                    label = "Slanted Muzzle",
                    price = 25000
                },
                {
                    attachment = "COMPONENT_AT_MUZZLE_07",
                    label = "Split Muzzle",
                    price = 25000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP_02",
                    label = "Foregrip",
                    price = 40000
                },
            },
        },
        -- {
        --     label = "Barrel",
        --     bone = "WAPBarrel",
        --     options = {
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_01",
        --             label = "Standard Barrel",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_AT_CR_BARREL_02",
        --             label = "Heavy Barrel",
        --             price = 40000
        --         },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SIGHTS",
                    label = "Holographic Sight",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MACRO_MK2",
                    label = "Red Dot",
                    price = 4000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
                    label = "Acog Scope",
                    price = 4000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO",
                    label = "Digital",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_02",
                    label = "Brushstroke",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_03",
                    label = "Woodland",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_04",
                    label = "Skull",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_05",
                    label = "Sessanta",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_06",
                    label = "Perseus",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_07",
                    label = "Leopard",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_08",
                    label = "Zebra",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_09",
                    label = "Geometric",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_10",
                    label = "Boom!",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01",
                    label = "Patriotic",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_MK18`] = {
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_MK18_SCOPE_05",
                    label = "Black Holo",
                    price = 2500
                },
            },
        },
    },
    --[[@MGs]]
    [`WEAPON_COMBATMG`] = {
        -- {
        --     label = "Mag",
        --     bone = "WAPClip",
        --     options = {
        --         {
        --             attachment = "COMPONENT_COMBATMG_CLIP_01",
        --             label = "Standard Mag",
        --             price = 0
        --         },
        --         {
        --             attachment = "COMPONENT_COMBATMG_CLIP_02",
        --             label = "Extended Mag",
        --             price = 50000
        --         },
        --     },
        -- },
        {
            label = "Optic",
            bone = "WAPScop_2",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MEDIUM",
                    label = "Acog Scope",
                    price = 4000
                },
            },
        },
        {
            label = "Grip",
            bone = "WAPGrip",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_AFGRIP",
                    label = "Foregrip",
                    price = 14000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_COMBATMG_VARMOD_LOWRIDER",
                    label = "Deluxe",
                    price = 10000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@SNIPERS]]
    [`WEAPON_SNIPERRIFLE`] = {
        {
            label = "Optic",
            bone = "WAPScop",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_LARGE",
                    label = "Large Scope",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_AT_SCOPE_MAX",
                    label = "Max Scope",
                    price = 15000
                },
            },
        },
        {
            label = "Suppressor",
            bone = "WAPSupp",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_AT_AR_SUPP_02",
                    label = "Suppressor",
                    price = 50000
                },
            },
        },
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SNIPERRIFLE_VARMOD_LUXE",
                    label = "Deluxe",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    --[[@Melee]]
    [`WEAPON_KNUCKLE`] = {
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    label = "None",
                    price = 0
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_PIMP",
                    label = "The Pimp",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_BALLAS",
                    label = "The Ballas",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_DOLLAR",
                    label = "The Hustler",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_HATE",
                    label = "The Hater",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_LOVE",
                    label = "The Lover",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_PLAYER",
                    label = "The Player",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_KING",
                    label = "The King",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_KNUCKLE_VARMOD_VAGOS",
                    label = "The Vagos",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
    [`WEAPON_SWITCHBLADE`] = {
        {
            label = "Variation",
            bone = "gun_root",
            options = {
                {
                    attachment = "COMPONENT_SWITCHBLADE_VARMOD_BASE",
                    label = "Base",
                    price = 0
                },
                {
                    attachment = "COMPONENT_SWITCHBLADE_VARMOD_VAR1",
                    label = "VIP",
                    price = 5000
                },
                {
                    attachment = "COMPONENT_SWITCHBLADE_VARMOD_VAR2",
                    label = "Bodyguard",
                    price = 5000
                },
            },
        },
        {
            label = "Tint",
            bone = "gun_root",
            options = {},
        },
    },
}
