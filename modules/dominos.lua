--[[    Header
    In this opening block, only the name of the addon, version, and dependencies needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Hiui Dominos Tweaks", 0.2
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "General interface positioning using Dominos."
mod.depends = { "Dominos", "Dominos_Config" }

--[[ Imports --]]
-- local GlobalUIElement = _G["GlobalUIElement"]
local Dominos

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global
    mod.db.profile
    mod.db.char
--]]
local global, profile, char


mod.storage = {
	["showgrid"] = false,
	["frames"] = {
		{
			["point"] = "BOTTOM",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[combat]100;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
				},
				["WARRIOR"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
				},
				["ROGUE"] = {
					["page2"] = 1,
					["shadowdance"] = 6,
					["page5"] = 4,
					["page4"] = 3,
					["stealth"] = 6,
					["page3"] = 2,
					["page6"] = 5,
				},
				["MAGE"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
				},
				["PRIEST"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
				},
				["DRUID"] = {
					["page2"] = 1,
					["moonkin"] = 7,
					["cat"] = 6,
					["bear"] = 8,
				},
				["MONK"] = {
					["page2"] = 1,
				},
				["PALADIN"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
				},
			},
			["displayLayer"] = "MEDIUM",
			["showInPetBattleUI"] = false,
			["showInOverrideUI"] = true,
			["fadeOutDelay"] = false,
			["x"] = -0.238274531124727,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["displayLevel"] = 7,
		}, -- [1]
		{
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMLEFT",
			["scale"] = 0.5,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["y"] = 172.0000610351563,
			["relPoint"] = "LEFT",
			["spacing"] = 0,
			["numButtons"] = 12,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
		}, -- [2]
		{
			["point"] = "TOPRIGHT",
			["scale"] = 0.9,
			["padW"] = 2,
			["fadeAlpha"] = 0,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["displayLayer"] = "MEDIUM",
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["y"] = -27.56043610750754,
			["x"] = -0.0002535910580964351,
			["displayLevel"] = 1,
			["fadeOutDelay"] = false,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["showstates"] = "[resting,mod:alt][nocombat,mod:alt]100;[resting]hide;show",
		}, -- [3]
		{
			["point"] = "TOPRIGHT",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[resting,mod:shift][resting,mod:alt]100;[resting]hide;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["y"] = -27.56080231844506,
			["x"] = -120.0003756613706,
			["fadeAlpha"] = 0,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["fadeOutDelay"] = false,
		}, -- [4]
		{
			["point"] = "BOTTOM",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[combat]100;[mod:ctrl,noresting][mod:alt]100;[resting]hide;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["displayLayer"] = "MEDIUM",
			["showInPetBattleUI"] = false,
			["showInOverrideUI"] = false,
			["fadeOutDelay"] = false,
			["x"] = -0.238274531124727,
			["fadeAlpha"] = 0,
			["numButtons"] = 12,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["y"] = 80,
			["displayLevel"] = 1,
		}, -- [5]
		{
			["point"] = "BOTTOM",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[combat]100;[mod:shift,noresting][mod:alt]100;[resting]hide;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["showInOverrideUI"] = false,
			["y"] = 40,
			["x"] = -0.238274531124727,
			["fadeAlpha"] = 0,
			["fadeOutDelay"] = false,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["displayLevel"] = 1,
		}, -- [6]
		{
			["point"] = "TOPLEFT",
			["scale"] = 1,
			["padW"] = 2,
			["showstates"] = "",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["numButtons"] = 12,
			["displayLayer"] = "MEDIUM",
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["fadeOutDelay"] = false,
			["x"] = 282.514404296875,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["padH"] = 2,
			["fadeInDelay"] = false,
			["y"] = -19.20010375976563,
			["displayLevel"] = 1,
		}, -- [7]
		{
			["point"] = "TOPRIGHT",
			["scale"] = 1,
			["padW"] = 2,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["fadeOutDelay"] = false,
			["x"] = -355.2000427246094,
			["numButtons"] = 12,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["y"] = -19.20010375976563,
			["relPoint"] = "TOP",
		}, -- [8]
		{
			["point"] = "TOPRIGHT",
			["scale"] = 1,
			["padW"] = 2,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["fadeOutDelay"] = false,
			["x"] = -235.2001266479492,
			["relPoint"] = "TOP",
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["y"] = -19.20010375976563,
		}, -- [9]
		{
			["point"] = "TOP",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[combat]100;[resting]show;25",
			["fadeOutDuration"] = 1,
			["spacing"] = 4,
			["fadeInDuration"] = 0.1000000014901161,
			["pages"] = {
				["HUNTER"] = {
				},
				["WARRIOR"] = {
				},
				["ROGUE"] = {
				},
				["MAGE"] = {
				},
				["PRIEST"] = {
				},
				["DEATHKNIGHT"] = {
				},
				["WARLOCK"] = {
				},
				["DEMONHUNTER"] = {
				},
				["SHAMAN"] = {
				},
				["DRUID"] = {
				},
				["MONK"] = {
				},
				["PALADIN"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 6,
			["showInOverrideUI"] = false,
			["fadeOutDelay"] = 3,
			["x"] = -0.0001840159880325928,
			["fadeAlpha"] = 0,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["y"] = -2.656160908852014e-05,
		}, -- [10]
		["zone"] = {
			["showInPetBattleUI"] = true,
			["x"] = -272,
			["point"] = "BOTTOM",
			["anchor"] = "6LT",
			["showInOverrideUI"] = true,
			["y"] = 38,
		},
		["encounter"] = {
			["showInPetBattleUI"] = true,
			["showstates"] = "",
			["point"] = "TOPRIGHT",
			["y"] = -188.4713325500488,
			["scale"] = 1,
			["showInOverrideUI"] = true,
			["fadeInDelay"] = false,
			["fadeOutDelay"] = false,
			["x"] = -278.4522705078125,
			["fadeOutDuration"] = 0.1000000014901161,
			["clickThrough"] = true,
			["relPoint"] = "RIGHT",
			["fadeInDuration"] = 0.1000000014901161,
			["displayLevel"] = 1,
			["displayLayer"] = "MEDIUM",
		},
		["bags"] = {
			["showInPetBattleUI"] = false,
			["scale"] = 0.8,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["y"] = 66.00020599365234,
			["x"] = -0.0003630320118238232,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 3,
			["showstates"] = "show;[combat,mod:alt]50;[mod:alt]show;hide",
			["fadeInDelay"] = false,
			["fadeOutDelay"] = false,
			["fadeInDuration"] = 0.1000000014901161,
		},
		["mirrorTimer2"] = {
			["showInPetBattleUI"] = false,
			["point"] = "TOP",
			["showInOverrideUI"] = false,
			["w"] = 206,
			["y"] = -184.0668106079102,
			["x"] = -9.918212890625e-05,
			["h"] = 26,
			["padW"] = 1,
			["display"] = {
				["border"] = true,
				["time"] = false,
				["spark"] = false,
				["label"] = true,
			},
			["font"] = "Friz Quadrata TT",
			["padH"] = 1,
			["texture"] = "Blizzard",
		},
		["alerts"] = {
			["y"] = 2.6702880859375e-05,
			["columns"] = 1,
			["spacing"] = 2,
			["point"] = "LEFT",
			["showInOverrideUI"] = true,
			["showInPetBattleUI"] = true,
		},
		["roll"] = {
			["y"] = 2.6702880859375e-05,
			["columns"] = 1,
			["spacing"] = 2,
			["point"] = "LEFT",
			["showInOverrideUI"] = true,
			["showInPetBattleUI"] = true,
		},
		["vehicle"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMLEFT",
			["scale"] = 1,
			["showInOverrideUI"] = false,
			["fadeOutDelay"] = false,
			["relPoint"] = "BOTTOM",
			["fadeOutDuration"] = 0.1000000014901161,
			["x"] = 215.9999389648438,
			["fadeInDelay"] = false,
			["fadeInDuration"] = 0.1000000014901161,
			["showstates"] = "",
			["y"] = 38.40000152587891,
		},
		["artifact"] = {
			["point"] = "BOTTOMLEFT",
			["scale"] = 1,
			["lockMode"] = true,
			["padW"] = 2,
			["spacing"] = 1,
			["anchor"] = {
				["relFrame"] = 2,
				["point"] = "BOTTOMLEFT",
				["relPoint"] = "TOPLEFT",
			},
			["alwaysShowText"] = true,
			["texture"] = "blizzard",
			["showInPetBattleUI"] = false,
			["columns"] = 20,
			["numButtons"] = 20,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["width"] = 300,
			["y"] = 103.9999694824219,
			["font"] = "Open Sans Regular",
			["height"] = 12,
			["padH"] = 2,
			["display"] = {
				["remaining"] = true,
				["label"] = true,
				["max"] = true,
				["value"] = true,
				["percent"] = true,
				["bonus"] = true,
			},
			["relPoint"] = "LEFT",
			["displayLayer"] = "MEDIUM",
			["displayLevel"] = 1,
		},
		["extra"] = {
			["showInPetBattleUI"] = false,
			["relPoint"] = "CENTER",
			["point"] = "TOPLEFT",
			["y"] = -181.1865596064882,
			["scale"] = 0.9,
			["showInOverrideUI"] = false,
			["x"] = 73.48070435071119,
		},
		["mirrorTimer3"] = {
			["showInPetBattleUI"] = false,
			["point"] = "TOP",
			["showInOverrideUI"] = false,
			["w"] = 206,
			["y"] = -210.0667495727539,
			["x"] = -9.918212890625e-05,
			["font"] = "Friz Quadrata TT",
			["padW"] = 1,
			["padH"] = 1,
			["h"] = 26,
			["display"] = {
				["border"] = true,
				["time"] = false,
				["spark"] = false,
				["label"] = true,
			},
			["texture"] = "Blizzard",
		},
		["pet"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMLEFT",
			["y"] = 6.473688125610352,
			["scale"] = 0.95,
			["showInOverrideUI"] = false,
			["x"] = 227.3681423085049,
			["fadeOutDelay"] = false,
			["relPoint"] = "BOTTOM",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 0,
			["fadeInDuration"] = 0.1000000014901161,
			["fadeInDelay"] = false,
			["displayLevel"] = 1,
			["displayLayer"] = "MEDIUM",
		},
		["talk"] = {
			["showInPetBattleUI"] = true,
			["point"] = "BOTTOM",
			["scale"] = 0.9,
			["showInOverrideUI"] = true,
			["fadeInDuration"] = 0.1000000014901161,
			["fadeOutDelay"] = false,
			["x"] = -0.1272668406950391,
			["fadeOutDuration"] = 0.1000000014901161,
			["showstates"] = "",
			["y"] = 173.3333129882813,
			["fadeInDelay"] = false,
			["displayLevel"] = 1,
			["displayLayer"] = "MEDIUM",
		},
		["cast"] = {
			["point"] = "BOTTOM",
			["scale"] = 1.2,
			["latencyPadding"] = 40,
			["h"] = 24,
			["displayLevel"] = 1,
			["texture"] = "Grid2 Flat",
			["showInPetBattleUI"] = true,
			["showInOverrideUI"] = true,
			["w"] = 240,
			["y"] = 106,
			["x"] = -0.1111007266537375,
			["padH"] = -4,
			["padW"] = -4,
			["display"] = {
				["time"] = true,
				["spark"] = true,
				["icon"] = true,
				["border"] = true,
				["latency"] = false,
			},
			["useSpellReactionColors"] = true,
			["displayLayer"] = "HIGH",
			["font"] = "DejaVuSansCondensed",
		},
		["menu"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["showstates"] = "[nocombat] 100; show",
			["fadeOutDelay"] = false,
			["fadeAlpha"] = 0,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 0,
			["x"] = 3.0517578125e-05,
			["fadeInDelay"] = false,
			["fadeInDuration"] = 0.1000000014901161,
			["y"] = 81.6001968383789,
		},
		["exp"] = {
			["compressValues"] = false,
			["point"] = "BOTTOMLEFT",
			["scale"] = 1,
			["lockMode"] = true,
			["showstates"] = "",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 0,
			["fadeInDuration"] = 0.1000000014901161,
			["numButtons"] = 1,
			["texture"] = "Charcoal",
			["showInPetBattleUI"] = false,
			["columns"] = 20,
			["showInOverrideUI"] = false,
			["width"] = 638,
			["fadeOutDelay"] = false,
			["font"] = "2002",
			["displayLevel"] = 1,
			["display"] = {
				["remaining"] = true,
				["label"] = true,
				["max"] = true,
				["value"] = true,
				["percent"] = true,
				["bonus"] = true,
			},
			["height"] = 37,
			["fadeInDelay"] = false,
			["displayLayer"] = "BACKGROUND",
			["alwaysShowText"] = false,
		},
		["mirrorTimer1"] = {
			["showInPetBattleUI"] = false,
			["point"] = "TOP",
			["showInOverrideUI"] = false,
			["w"] = 206,
			["y"] = -158.0666885375977,
			["x"] = 8.392333984375e-05,
			["h"] = 26,
			["padW"] = 1,
			["display"] = {
				["border"] = true,
				["time"] = false,
				["spark"] = false,
				["label"] = true,
			},
			["font"] = "Friz Quadrata TT",
			["padH"] = 1,
			["texture"] = "Blizzard",
		},
		["class"] = {
			["point"] = "BOTTOMLEFT",
			["scale"] = 1,
			["padW"] = 3,
			["showstates"] = "",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 8,
			["fadeInDuration"] = 0.1000000014901161,
			["displayLevel"] = 1,
			["isBottomToTop"] = true,
			["showInPetBattleUI"] = false,
			["showInOverrideUI"] = false,
			["fadeOutDelay"] = false,
			["relPoint"] = "BOTTOM",
			["padH"] = 3,
			["fadeInDelay"] = false,
			["displayLayer"] = "MEDIUM",
			["x"] = 279.7334594726563,
		},
		["quests"] = {
			["showInPetBattleUI"] = true,
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["showInOverrideUI"] = true,
			["fadeOutDelay"] = false,
			["x"] = 9.1552734375e-05,
			["fadeOutDuration"] = 0.1000000014901161,
			["y"] = -66.49993896484375,
			["height"] = 375,
			["fadeInDuration"] = 0.1000000014901161,
			["fadeInDelay"] = false,
			["relPoint"] = "RIGHT",
		},
		["possess"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["showInOverrideUI"] = false,
			["y"] = 110.4000091552734,
			["x"] = -148.000129699707,
			["spacing"] = 4,
			["padH"] = 2,
			["relPoint"] = "BOTTOM",
			["padW"] = 2,
		},
	},
	["minimap"] = {
		["hide"] = true,
	},
	["ab"] = {
		["rightClickUnit"] = "none",
	},
	["useOverrideUI"] = false,
	["applyButtonTheme"] = false,
	["linkedOpacity"] = true,
	["alignmentGrid"] = {
		["size"] = 25,
	},
	["sticky"] = false,
}
--[[    Default Values
    You should include at least the following:
    defaults.global.debug = false
    defaults.profile.enabled = false
    defaults.char.initialized = false
--]]
local defaults = {
    global = {
        debug = true, -- noisy debugging
    },
    profile = {
        initialized = 0,
        enabled = false, -- have root addon enable?
        storage = {},
    },
    char = {
        initialized = 0, -- used for first time load
    },
}


local function queueUiWarning()
    C_Timer.After(2, function()
        mod:Print("Your dominos frame positions have been updated, but you have to reload your UI to put it into effect.")
    end)
    C_Timer.After(7, function()
        mod:Print("You have to reload your UI at the soonest convenience, or you will start getting interface errors.")
    end)
    C_Timer.After(12, function()
        mod:Print("You NEED to reload your UI to apply changes and to avoid interface errors.")
    end)
end


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
    set_hiui_profile = function(p)
        p = mod.db.parent:GetCurrentProfile() or p or "Hiui"

        if Dominos.db:GetCurrentProfile() ~= p then
            if global.debug then mod:Print("Dominos profile isn't " .. p .. ", changing that.") end
            Dominos.db:SetProfile(p)
        end

		return Dominos.db:GetCurrentProfile() == p
    end,

	save_dominos_positions = function(info)
        profile.frames = {}
        for k, v in pairs(Dominos.db.profile) do
            profile[k] = v
        end
	end,

    restore_dominos_positions = function(_, dontReloadUI)
		if Dominos.db:GetCurrentProfile() ~= mod.db.parent:GetCurrentProfile() then
			mod:Print("Please set Dominos profile to the same as the Hiui profile. We won't apply any changes to protect your other bar layouts.")
			return
		end

		local s = next(profile.storage) and profile.storage or mod.storage

		if global.debug then
			if s == profile.storage then
				mod:Print("Selected profile to restore dominos frames from.")
			else
				mod:Print("Selected defaults to restore dominos frames from.")
			end
		end

        for k, v in pairs(s) do
            Dominos.db.profile[k] = v
        end

        if dontReloadUI then
            queueUiWarning()
        else
            C_UI.Reload()
        end
    end,

    reset_dominos_positions_to_default = function(_, dontReloadUI)
		if Dominos.db:GetCurrentProfile() ~= mod.db.parent:GetCurrentProfile() then
			mod:Print("Please set Dominos profile to the same as the Hiui profile. We won't apply any changes to protect your other bar layouts.")
			return
		end

        for k, v in pairs(mod.storage) do
            Dominos.db.profile[k] = v
        end

        if dontReloadUI then
            queueUiWarning()
        else
            C_UI.Reload()
        end
    end,
}

--[[    GUI Options Menu
    Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
    The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
--]]
local options = {
    name = " Dominos",
    type = "group",
    args = {
        enable = {
            order = 0,
            name = "Enable " .. name,
            desc = "Check to enable this module.",
            type = "toggle",
            set = function(_, value)
                profile.enabled = value
                if value then
                    mod:Enable()
                else
                    mod:Disable()
                end
            end,
            get = function() return profile.enabled end,
        },
        debug = {
            order = 1,
            name = "Noisy debugging",
            desc = "Print lots of text to the chatbox.",
            type = "toggle",
            set = function(_, value) global.debug = value end,
            get = function() return global.debug end,
        },
        disabledWarning = {
            order = 2,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        save_dominos_positions = {
			name = "Save Dominos Frames Positions",
			type = "execute",
			confirm = true,
			func = features.save_dominos_positions,
		},
        restore_dominos_positions = {
            name = "Restore Dominos Frames Positions",
            desc = "This will reload the UI!",
            type = "execute",
            confirm = true,
            func = features.restore_dominos_positions,
        },
        reset_dominos_positions_to_default = {
            name = "Reset Dominos Frames Positions",
            desc = "This will reset positions to hiui default and reload the UI!",
            type = "execute",
            confirm = true,
            func = features.reset_dominos_positions_to_default,
        },
    },
}

--[[    Option Page Show
    Removes the disabled state of each option. Also hides the disabled warning. Do not modify.
--]]
local function enableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if v.disabled then v.disabled = false end
    end
    optionsTable.args.disabledWarning.hidden = true
end

--[[    Option Page Hide
    Grays out the options when you disable the addon. Also hides the disabled warning. Do not modify.
--]]
local function disableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if k ~= "enable" and k ~= "disabledWarning" then
            v.disabled = true
        end
    end
    optionsTable.args.disabledWarning.hidden = false
end

function mod:OnInitialize()
    --[[ data initialization. do not modify. --]]
    self.db = Hiui.db:RegisterNamespace(name, defaults)
    global = self.db.global
    profile = self.db.profile
    char = self.db.char

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ Gray out args. do not modify. --]]
    if not profile.enabled then disableArgs(options) end

    --[[ Module specific on-load routines go here. --]]
end

function mod:OnEnable()
    --[[ For combat-unsafe mods. --]]
    if InCombatLockdown() then
        return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
    end
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")

    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]

    --[[ Module specific on-run routines go here. --]]
    Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")

	if profile.initialized < mod.version and features.set_hiui_profile() then
		if Dominos.db:GetCurrentProfile() == mod.db.parent:GetCurrentProfile() then
			if global.debug then self:Print("Update running, resetting dominos frame positions.") end
			features.reset_dominos_positions_to_default(nil, "Provide Warning for UI Reload")
		end
        profile.initialized = mod.version
    end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
