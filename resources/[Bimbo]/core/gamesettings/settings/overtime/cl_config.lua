Config = {
	CheckInjuryDistance = 2.5,
	RespawnTime = 300,
	Effects = {
		Hunger = { Min = -0.5, Max = 1.5, Passive = 1.0 / 3600.0, Afflict = 0.8, DamageAt = 1.25, Damage = { 100, 24817, "WEAPON_DEHYDRATION" }, Notify = "You feel hungry.", Modifier = "BasicEffectModifier" },
		Thirst = { Min = -0.5, Max = 1.5, Passive = 1.0 / 4900.0, Afflict = 0.8, DamageAt = 1.25, Damage = { 50, 24817, "WEAPON_DEHYDRATION" }, Notify = "You feel thirsty.", Modifier = "BasicEffectModifier" },
		Bac = { Min = 0.0, Passive = -1.0 / 300.0, Max = 1.0, DamageAt = 0.9, Damage = { 1, 24817, "WEAPON_DEHYDRATION" }, Notify = "You feel smashed." },
		Drug = { Min = 0.0, Passive = -1.0 / 120.0, Max = 2.0, DamageAt = 0.75, Damage = { 100, 31086, "WEAPON_OPIOIDS" }, Notify = "Your consciousness fades away." },
		Poison = { Min = 0.0, Passive = -1.0 / 300.0, Max = 1.0, DamageAt = 0.25, Damage = { 100, 31086, "WEAPON_POISON" }, Notify = "Your skin feels like it's melting off." },
		Comfort = { Min = 0.0, Passive = -1.0 / 600.0, Max = 1.0 },
		Armor = { Min = 0.0, Passive = -1.0 / 60.0, Max = 1.0 },
		Oxygen = { Min = 0.0, Passive = -1.0 / 60.0, Max = 1.0, DamageAt = 0.95, Damage = { 10, 24818, "WEAPON_DROWNING" }, Notify = "Your lungs start to give out." },
		Scuba = { Min = 0.0, Passive = -1.0 / 600, Max = 1.5 },
	},
	Modifiers = {
		Resistance = { 0.85, 0.975 },
		Healing = { 2.0, 6.0 },
	},
	Healing = {
		MaxDamage = 0.95,
		Amount = 1.0 / 3600.0,
	},
	Bleeding = {
		HealRate = 1.0 / 3600.0,
		ClotRate = 1.0 / 1800.0,
		UnclotRate = 1.0 / 300.0,
	},
	Bandaging = {
		InstantHealth = {0.0, 0.5},
		Action = {
			duration = 6000,
			label = "Using Bandage...",
			anim = {
				flag = 48,
				dict = "clothingshirt",
				clip = "try_shirt_neutral_d",
				disable = {
					combat = true,
				},
			}
		}
	},
	Gauzing = {
		InstantHealth = {0.0, 0.1},
		Action = {
			duration = 3000,
			label = "Using Gauze...",
			anim = {
				flag = 48,
				dict = "clothingshirt",
				clip = "try_shirt_neutral_d",
				disable = {
					combat = true,
				},
			}
		}
	},
	IFAK = {
		Action = {
			duration = 30000,
			label = "Using IFAK...",
			anim = {
				flag = 49,
				dict = "misslsdhsclipboard@idle_a",
				clip = "idle_b",
				disable = {
					combat = true,
				},
			}
		}
	},
	IcePacking = {
		InstantHealth = {0.0, 0.1},
		Action = {
			duration = 6000,
			label = "Using Ice Pack...",
			anim = {
				flag = 48,
				dict = "clothingshirt",
				clip = "try_shirt_neutral_d",
				disable = {
					combat = true,
				},
			}
		}
	},
	Badge = {
		Action = {
			duration = 3500,
			label = "Showing Badge...",
			anim = {
				flag = 48,
				dict = "paper_1_rcm_alt1-9",
				clip = "player_one_dual-9",
				disable = {
					combat = true,
				},
				prop = {
					{ model = "prop_fib_badge", bone = 58866, offsetX = 0.12, offsetY = 0.01, offsetZ = 0.01, rotX = 93.0, rotY = -10.0, rotZ = 0.0 },
				},
			}
		}
	},
	Armoring = {
		Action = {
			duration = 8000,
			label = "Armoring Up...",
			anim = {
				flag = 48,
				dict = "clothingtie",
				clip = "try_tie_neutral_c",
				disable = {
					combat = true,
				},
			}
		}
	},
	Rebreather = {
		Action = {
			duration = 1200,
			label = "Equipping...",
			anim = {
				flag = 49,
				dict = "mp_masks@on_foot",
				clip = "put_on_mask",
				disable = {
					combat = true,
				},
			}
		}
	},
	Scubaing = {
		Action = {
			duration = 5000,
			label = "Equipping...",
			anim = {
				flag = 49,
				dict = "mp_masks@on_foot",
				clip = "put_on_mask",
				disable = {
					combat = true,
				},
			}
		}
	},
	Medical = {
		Distance = 2.5,
		Action = {
			duration = 4000,
			label = "Performing Medical...",
			anim = {
				flag = 48,
				dict = "missexile3",
				clip = "ex03_dingy_search_case_base_michael",
				disable = {
					combat = true,
				},
			}
		}
	},
	Pills = {
		Action = {
			duration = 4800,
			label = "Taking Pill...",
			anim = {
				dict = "mp_suicide",
				clip = "pill",
				flag = 48,
				duration = 2800,
				disable = {
					combat = true,
				},
				prop = {
					{ model = "prop_cs_pills", bone = 58866, offsetX = 0.1, offsetY = 0.0, offsetZ = 0.001, rotX = 0.0, rotY = 0.0, rotZ = 0.0 },
				},
			},
		},
	},
	Joint = {
		Action = {
			duration = 12000,
			label = "Getting high...",
			anim = {
				scenario = "WORLD_HUMAN_SMOKING_POT",
				flag = 49,
				disable = {
					combat = true,
				},
			}
		},
	},
	Blunt = {
		Action = {
			duration = 26000,
			label = "Hitting Blunt...",
			anim = {
				scenario = "WORLD_HUMAN_SMOKING_POT",
				flag = 48,
				disable = {
					combat = true,
				},
			}
		},
	},
	Edible = {
		Action = {
			duration = 4800,
			label = "Chewing...",
			anim = {
				dict = "mp_suicide",
				clip = "pill",
				flag = 48,
				duration = 2800,
				disable = {
					combat = true,
				},
			},
		},
	},
	Dab = {
		Action = {
			duration = 35000,
			label = "Dabbing...",
			anim = {
				dict = "anim@safehouse@bong",
				clip = "bong_stage4",
				flag = 49,
				disable = {
					combat = true,
				},
				prop = {
					{ model = "sf_prop_sf_bong_01a", bone = 18905, offsetX = 0.10, offsetY = -0.25, offsetZ = 0.0, rotX = 95.0, rotY = 190.0, rotZ = 180.0 },
				},
			},
		},
	},
	Hash = {
		Action = {
			duration = 35000,
			label = "Smokin Some Hash...",
			anim = {
				dict = "timetable@gardener@smoking_joint",
				clip = "smoke_idle",
				flag = 49,
				disable = {
					combat = true,
				},
				prop = {
					{ model = "prop_cs_meth_pipe", bone = 57005, offsetX = 0.12, offsetY = -0.06, offsetZ = -0.05, rotX = 8.0, rotY = 50.0, rotZ = 0.0 },
				},
			},
		},
	},
	Limping = {
		SprintingDamage = 1.0 / 180.0,
		JumpingDamage = 0.5,
		StaggerChance = 0.4,
		InjuredDamage = 0.5,
	},
	Down = {
		Delay = 1000,
		MaxSpeed = 0.1,
		FadeTime = 1000,
		BlendSpeed = 2.0,
		Anim = {
			dict = "Dead",
			clip = "dead_%s",
			random = { "a", "b", "c", "d", "e", "f", "g", "h" },
		},
		Water = {
			Anim = {
				dict = "dam_ko",
				clip = "drown",
			},
			Buoyancy = 1.2,
		},
		Vehicles = {
			Anim = {
				-- dict = "veh@std@ps@idle_duck", -- Floating hands
				dict = "veh@std@rps@idle_duck", -- Tucked hands
				clip = "sit",
				flag = 16,
			},
		},
		Controls = { 8, 9, 21, 22, 23, 24, 25, 30, 31, 55, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 86, 90, 137, 143, 346, 347 }
	},
	Concussions = {
		-- Multiplied by the concussion value (0.0 - 1.0).
		DamageAmount = 0.1,
		PassoutChance = 0.4,
		-- Constants.
		PassoutThreshold = 0.2,
		HealChance = 0.4,
		HealAmount = 0.1,
	},
	Intensities = {
		{ 0.9, "Extreme %s" },
		{ 0.6, "Heavy %s" },
		{ 0.4, "Medium %s" },
		{ 0.0, "Light %s" },
	},
	Injuries = {
		["blunt"] = {
			Name = "Bruising",
			MinSpread = 0.2, Spread = 0.5,
			Concussion = 1.0,
			UseIntensity = true,
		},
		-- ["fracture"] = {
		-- 	Name = "Bruising",
		-- 	MinSpread = 20, Spread = 0.5,
		-- 	Concussion = 1.0,
		-- 	UseIntensity = true,
		-- },
		["burn2"] = {
			Name = "2nd-Degree Burns",
			Spread = 0.4,
			UseIntensity = true,
		},
		["burn3"] = {
			Name = "3rd-Degree Burns",
			Spread = 1.0,
			Bleed = 1.0 / 120.0,
			HemorrhagingChance = 1.0,
			Hemorrhaging = 1.0 / 90.0,
			UseIntensity = true,
		},
		["gas"] = {},
		["gsw"] = {
			Name = "GSW",
			Bleed = 1.0 / 1200.0,
			DamageMultiplier = 1.5,
			HemorrhagingChance = 0.6,
			Hemorrhaging = 1.0 / 900.0
		},
		["scrapes"] = {
			Name = "Scrapes",
			Bleed = 1.0 / 900.0
		},
		["stab"] = {
			Name = "Stab",
			Bleed = 1.0 / 60.0,
			HemorrhagingChance = 0.9,
			Hemorrhaging = 1.0 / 600.0
		},
		["glass"] = {
			Name = "Glass",
			Bleed = 1.0 / 300.0,
			HemorrhagingChance = 0.1,
			Hemorrhaging = 1.0 / 900.0
		},
		["dehydration"] = {
			Name = "Dehydration",
		},
		["malnourishment"] = {
			Name = "Malnourishment",
		},
		["opioids"] = {
			Name = "Opioids",
		},
		["poison"] = {
			Name = "Poison",
		},
	},
	BodyParts = {
		-- Fallbacks.
		[0] = { Name = "SKEL_ROOT", Fallback = 11816 },
		[39317] = { Name = "SKEL_Neck_1", Type = 4103, Fallback = 31086 },
		[24816] = { Name = "SKEL_Spine1", Type = 4103, Fallback = 11816 },
		[23553] = { Name = "SKEL_Spine0", Type = 4103, Fallback = 11816 },
		[57597] = { Name = "SKEL_Spine_Root", Type = 4103, Fallback = 11816 },
		-- Center upper.
		[31086] = { Name = "SKEL_Head", Type = 4103, Nearby = { 10706, 64729 }, Fatal = 0.3, Concussion = true, MaxArmor = 0.1 },
		[24818] = { Name = "SKEL_Spine3", Type = 4103, Nearby = { 10706, 64729, 24817, 45509, 40269 }, Fatal = 0.175 },
		[24817] = { Name = "SKEL_Spine2", Type = 4103, Nearby = { 24818, 24816 }, Fatal = 0.15 },
		[11816] = { Name = "SKEL_Pelvis", Type = 4103, Nearby = { 24817, 51826, 58271 }, Fatal = 0.125, Limp = 0.5, MaxArmor = 0.1 },
		-- Right upper.
		[10706] = { Name = "SKEL_R_Clavicle", Type = 4103, Nearby = { 40269, 31086, 24818 }, Fatal = 0.1 },
		[40269] = { Name = "SKEL_R_UpperArm", Type = 4103, Nearby = { 10706, 28252, 24818 }, Fatal = 0.1, MaxArmor = 0.1 },
		[28252] = { Name = "SKEL_R_Forearm", Type = 4215, Nearby = { 40269, 57005 }, Fatal = 0.08 },
		[57005] = { Name = "SKEL_R_Hand", Type = 4215, Nearby = { 28252 }, Fatal = 0.05 },
		-- Right lower.
		[51826] = { Name = "SKEL_R_Thigh", Type = 4103, Nearby = { 11816, 36864 }, Fatal = 0.12, Limp = 0.4 },
		[36864] = { Name = "SKEL_R_Calf", Type = 4103, Nearby = { 51826, 52301 }, Fatal = 0.08, Limp = 0.4 },
		[52301] = { Name = "SKEL_R_Foot", Type = 4103, Nearby = { 36864 }, Fatal = 0.05, Limp = 0.25 },
		-- Left upper.
		[64729] = { Name = "SKEL_L_Clavicle", Type = 4103, Nearby = { 45509, 31086, 24818 }, Fatal = 0.12 },
		[45509] = { Name = "SKEL_L_UpperArm", Type = 4103, Nearby = { 64729, 61163, 24818 }, Fatal = 0.1, MaxArmor = 0.1 },
		[61163] = { Name = "SKEL_L_Forearm", Type = 4215, Nearby = { 45509, 18905 }, Fatal = 0.08 },
		[18905] = { Name = "SKEL_L_Hand", Type = 4215, Nearby = { 61163 }, Fatal = 0.05 },
		-- Left lower.
		[58271] = { Name = "SKEL_L_Thigh", Type = 4103, Nearby = { 11816, 63931 }, Fatal = 0.12, Limp = 0.5 },
		[63931] = { Name = "SKEL_L_Calf", Type = 4103, Nearby = { 58271, 14201 }, Fatal = 0.08, Limp = 0.5 },
		[14201] = { Name = "SKEL_L_Foot", Type = 4103, Nearby = { 63931 }, Fatal = 0.05, Limp = 0.25 },
	},
	Watercoolers = {
		{ Model = -742198632 },
		{ Model = -1691644768 },
		{ Model = 339851415 },
		{ Model = 2059009409 },
		{ Model = -1859213599 },
	},
}
