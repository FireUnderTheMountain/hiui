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
	["linkedOpacity"] = true,
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
				["PALADIN"] = {
					["page2"] = 1,
					["page5"] = 4,
					["page4"] = 3,
					["page3"] = 2,
					["page6"] = 5,
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
					["moonkin"] = 7,
					["page2"] = 1,
					["cat"] = 6,
					["bear"] = 8,
				},
				["MONK"] = {
					["page2"] = 1,
				},
				["DEATHKNIGHT"] = {
				},
			},
			["displayLayer"] = "MEDIUM",
			["showInPetBattleUI"] = true,
			["showInOverrideUI"] = true,
			["fadeOutDelay"] = false,
			["x"] = -0.0001153514371755513,
			["displayLevel"] = 1,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["y"] = 2.666673183441162,
		}, -- [1]
		{
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMLEFT",
			["scale"] = 0.5,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["y"] = 171.9999389648438,
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["displayLayer"] = "MEDIUM",
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["y"] = -27.56075654207782,
			["x"] = -7.068294470756856e-05,
			["showstates"] = "[resting,mod:alt][nocombat,mod:alt]100;[resting]hide;show",
			["numButtons"] = 12,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["fadeOutDelay"] = false,
			["displayLevel"] = 1,
		}, -- [3]
		{
			["point"] = "TOPRIGHT",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[resting,mod:shift][resting,mod:alt]100;[resting]hide;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["anchor"] = {
				["relFrame"] = 3,
				["point"] = "TOPRIGHT",
				["relPoint"] = "TOPLEFT",
			},
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["y"] = -122.0369375723514,
			["x"] = -120.000009450433,
			["fadeOutDelay"] = false,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["fadeAlpha"] = 0,
		}, -- [4]
		{
			["point"] = "BOTTOM",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[combat]100;[mod:ctrl,noresting][mod:alt]100;[resting]hide;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["anchor"] = {
				["relPoint"] = "TOPRIGHT",
				["point"] = "BOTTOMRIGHT",
				["relFrame"] = 6,
			},
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["showInOverrideUI"] = false,
			["fadeOutDelay"] = false,
			["x"] = -16.00034433195081,
			["y"] = 91.8013229370117,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["fadeAlpha"] = 0,
		}, -- [5]
		{
			["point"] = "BOTTOM",
			["scale"] = 0.9,
			["padW"] = 2,
			["showstates"] = "[combat]100;[mod:shift,noresting][mod:alt]100;[resting]hide;show",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["anchor"] = {
				["relPoint"] = "TOPRIGHT",
				["point"] = "BOTTOMRIGHT",
				["relFrame"] = 1,
			},
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["showInOverrideUI"] = false,
			["y"] = 51.80132675170898,
			["x"] = -16.00034433195081,
			["numButtons"] = 12,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["fadeOutDelay"] = false,
			["fadeAlpha"] = 0,
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
			["displayLevel"] = 1,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["y"] = -19.20013427734375,
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
		}, -- [7]
		{
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["padW"] = 2,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["anchor"] = {
				["relFrame"] = 7,
				["point"] = "TOPLEFT",
				["relPoint"] = "TOPRIGHT",
			},
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["fadeOutDelay"] = false,
			["x"] = -86.40023803710938,
			["relPoint"] = "CENTER",
			["padH"] = 2,
			["fadeInDelay"] = false,
			["y"] = 57.59994506835938,
			["numButtons"] = 12,
		}, -- [8]
		{
			["point"] = "BOTTOM",
			["scale"] = 1,
			["padW"] = 2,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 4,
			["anchor"] = {
				["relFrame"] = 8,
				["point"] = "BOTTOMLEFT",
				["relPoint"] = "BOTTOMRIGHT",
			},
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 3,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["fadeOutDelay"] = false,
			["x"] = -26.40022277832031,
			["y"] = 57.59994506835938,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["relPoint"] = "CENTER",
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
				["PALADIN"] = {
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
				["DEATHKNIGHT"] = {
				},
			},
			["showInPetBattleUI"] = false,
			["columns"] = 6,
			["showInOverrideUI"] = false,
			["fadeOutDelay"] = 3,
			["x"] = -9.105192068008165e-07,
			["y"] = -2.656160908852014e-05,
			["padH"] = 2,
			["fadeInDelay"] = false,
			["numButtons"] = 12,
			["fadeAlpha"] = 0,
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
			["fadeOutDelay"] = false,
			["scale"] = 1,
			["showInOverrideUI"] = true,
			["fadeInDuration"] = 0.1000000014901161,
			["y"] = -188.471363067627,
			["x"] = -278.4522399902344,
			["fadeOutDuration"] = 0.1000000014901161,
			["clickThrough"] = true,
			["relPoint"] = "RIGHT",
			["fadeInDelay"] = false,
			["displayLevel"] = 1,
			["displayLayer"] = "MEDIUM",
		},
		["bags"] = {
			["showInPetBattleUI"] = false,
			["scale"] = 0.8,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["fadeInDelay"] = false,
			["fadeOutDelay"] = false,
			["showstates"] = "show;[combat,mod:alt]50;[mod:alt]show;hide",
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 3,
			["anchor"] = {
				["relFrame"] = "menu",
				["point"] = "TOPRIGHT",
				["relPoint"] = "BOTTOMRIGHT",
			},
			["fadeInDuration"] = 0.1000000014901161,
			["x"] = -29.89353397912949,
			["y"] = 275.9999694824219,
		},
		["mirrorTimer2"] = {
			["showInPetBattleUI"] = false,
			["point"] = "TOP",
			["showInOverrideUI"] = false,
			["w"] = 206,
			["y"] = -184.0668106079102,
			["x"] = 2.288818359375e-05,
			["h"] = 26,
			["padH"] = 1,
			["display"] = {
				["spark"] = false,
				["border"] = true,
				["time"] = false,
				["label"] = true,
			},
			["font"] = "Friz Quadrata TT",
			["padW"] = 1,
			["texture"] = "Blizzard",
		},
		["alerts"] = {
			["showInPetBattleUI"] = true,
			["columns"] = 1,
			["spacing"] = 2,
			["point"] = "LEFT",
			["showInOverrideUI"] = true,
			["y"] = 2.6702880859375e-05,
		},
		["roll"] = {
			["showInPetBattleUI"] = true,
			["columns"] = 1,
			["spacing"] = 2,
			["point"] = "LEFT",
			["showInOverrideUI"] = true,
			["y"] = 2.6702880859375e-05,
		},
		["vehicle"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMLEFT",
			["scale"] = 1,
			["showInOverrideUI"] = false,
			["relPoint"] = "BOTTOM",
			["y"] = 38.40000534057617,
			["showstates"] = "",
			["fadeOutDuration"] = 0.1000000014901161,
			["fadeOutDelay"] = false,
			["anchor"] = {
				["relFrame"] = 6,
				["point"] = "BOTTOMLEFT",
				["relPoint"] = "BOTTOMRIGHT",
			},
			["fadeInDelay"] = false,
			["fadeInDuration"] = 0.1000000014901161,
			["x"] = 215.9999389648438,
		},
		["artifact"] = {
			["point"] = "LEFT",
			["scale"] = 1,
			["lockMode"] = true,
			["padW"] = 2,
			["spacing"] = 1,
			["alwaysShowText"] = true,
			["texture"] = "blizzard",
			["showInPetBattleUI"] = false,
			["columns"] = 20,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["width"] = 300,
			["y"] = 112,
			["font"] = "Friz Quadrata TT",
			["height"] = 12,
			["display"] = {
				["value"] = true,
				["bonus"] = true,
				["max"] = true,
				["label"] = true,
			},
			["numButtons"] = 20,
			["padH"] = 2,
		},
		["extra"] = {
			["showInPetBattleUI"] = false,
			["relPoint"] = "CENTER",
			["point"] = "TOPLEFT",
			["y"] = 15.85157210737906,
			["scale"] = 0.9,
			["showInOverrideUI"] = false,
			["x"] = 110.5190344288362,
		},
		["mirrorTimer3"] = {
			["showInPetBattleUI"] = false,
			["point"] = "TOP",
			["showInOverrideUI"] = false,
			["w"] = 206,
			["x"] = -0.0001220703125,
			["y"] = -210.0668334960938,
			["font"] = "Friz Quadrata TT",
			["display"] = {
				["spark"] = false,
				["border"] = true,
				["time"] = false,
				["label"] = true,
			},
			["anchor"] = {
				["relFrame"] = "mirrorTimer2",
				["point"] = "TOPLEFT",
				["relPoint"] = "BOTTOMLEFT",
			},
			["padH"] = 1,
			["h"] = 26,
			["padW"] = 1,
			["texture"] = "Blizzard",
		},
		["pet"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMLEFT",
			["fadeOutDelay"] = false,
			["scale"] = 0.95,
			["showInOverrideUI"] = false,
			["relPoint"] = "BOTTOM",
			["y"] = 4.999999523162843,
			["x"] = 231.0899368364562,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 0,
			["fadeInDelay"] = false,
			["fadeInDuration"] = 0.1000000014901161,
			["displayLevel"] = 1,
			["displayLayer"] = "MEDIUM",
		},
		["talk"] = {
			["showInPetBattleUI"] = true,
			["point"] = "BOTTOM",
			["scale"] = 0.8,
			["showInOverrideUI"] = true,
			["x"] = -0.1429492405413714,
			["y"] = 194.9999847412109,
			["showstates"] = "",
			["fadeOutDuration"] = 0.1000000014901161,
			["fadeOutDelay"] = false,
			["fadeInDelay"] = false,
			["fadeInDuration"] = 0.1000000014901161,
			["displayLevel"] = 1,
			["displayLayer"] = "MEDIUM",
		},
		["possess"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["showInOverrideUI"] = false,
			["y"] = 107.9999771118164,
			["x"] = -148.0000915527344,
			["spacing"] = 4,
			["padH"] = 2,
			["padW"] = 2,
			["relPoint"] = "BOTTOM",
			["anchor"] = {
				["relFrame"] = 5,
				["point"] = "BOTTOMLEFT",
				["relPoint"] = "TOPLEFT",
			},
		},
		["menu"] = {
			["showInPetBattleUI"] = false,
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["showInOverrideUI"] = false,
			["hidden"] = true,
			["y"] = 81.60017395019531,
			["fadeOutDelay"] = false,
			["fadeAlpha"] = 0,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 0,
			["fadeInDuration"] = 0.1000000014901161,
			["fadeInDelay"] = false,
			["showstates"] = "[nocombat] 100; show",
			["x"] = -3.0517578125e-05,
		},
		["exp"] = {
			["compressValues"] = false,
			["point"] = "BOTTOMRIGHT",
			["scale"] = 1,
			["lockMode"] = true,
			["fadeOutDuration"] = 0.1000000014901161,
			["spacing"] = 0,
			["fadeInDuration"] = 0.1000000014901161,
			["displayLevel"] = 1,
			["texture"] = "Details Flat",
			["showInPetBattleUI"] = false,
			["columns"] = 20,
			["font"] = "2002 Bold",
			["fadeOutDelay"] = false,
			["showInOverrideUI"] = false,
			["width"] = 300,
			["y"] = 21.14231681823731,
			["x"] = -3.0517578125e-05,
			["numButtons"] = 20,
			["display"] = {
				["label"] = true,
				["max"] = true,
				["value"] = true,
				["percent"] = true,
				["bonus"] = true,
			},
			["height"] = 10,
			["fadeInDelay"] = false,
			["alwaysShowText"] = false,
			["displayLayer"] = "MEDIUM",
		},
		["mirrorTimer1"] = {
			["showInPetBattleUI"] = false,
			["point"] = "TOP",
			["showInOverrideUI"] = false,
			["w"] = 206,
			["x"] = -9.1552734375e-05,
			["y"] = -95.9998779296875,
			["h"] = 26,
			["padH"] = 1,
			["anchor"] = {
				["relFrame"] = "mirrorTimer2",
				["point"] = "BOTTOMRIGHT",
				["relPoint"] = "TOPRIGHT",
			},
			["display"] = {
				["spark"] = false,
				["border"] = true,
				["time"] = false,
				["label"] = true,
			},
			["font"] = "Friz Quadrata TT",
			["padW"] = 1,
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
			["x"] = 336.1712036132813,
			["displayLayer"] = "MEDIUM",
		},
		["quests"] = {
			["showInPetBattleUI"] = true,
			["point"] = "RIGHT",
			["scale"] = 1,
			["showInOverrideUI"] = true,
			["fadeOutDelay"] = false,
			["fadeOutDuration"] = 0.1000000014901161,
			["height"] = 524,
			["fadeInDuration"] = 0.1000000014901161,
			["fadeInDelay"] = false,
			["y"] = 45.00003051757813,
		},
		["cast"] = {
			["point"] = "TOP",
			["scale"] = 2,
			["latencyPadding"] = 40,
			["h"] = 20,
			["displayLevel"] = 1,
			["displayLayer"] = "HIGH",
			["showInPetBattleUI"] = true,
			["showInOverrideUI"] = true,
			["w"] = 216,
			["y"] = -71.66670989990234,
			["x"] = 6.866455078125e-05,
			["texture"] = "Grid2 Flat",
			["display"] = {
				["time"] = true,
				["spark"] = false,
				["border"] = false,
				["icon"] = true,
				["latency"] = false,
			},
			["useSpellReactionColors"] = true,
			["font"] = "DejaVuSansCondensed",
			["relPoint"] = "CENTER",
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
	["showgrid"] = false,
	["alignmentGrid"] = {
		["enabled"] = false,
		["size"] = 25,
	},
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

	if char.initialized < mod.version then
		features.set_hiui_profile()
		char.initialized = mod.version
	end

    if profile.initialized < mod.version then
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
