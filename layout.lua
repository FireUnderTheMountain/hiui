## Layout

local paradigms = {
    ["Mouse-over Interact"] = "You can keybind interact with target and interact with mouseover, so that you can spam the key faster than clicking with a mouse.",
    ["oPie"] = "Non-combat panels and interactions like quest items and profession panels/commands should be put on oPie rings to free up action bar space.",
    ["Neuron"] = "If you use neuron, you can create an infinite number of action bars.",
    ["Focus"] = "Focus targeting and focus macros can increase target interactability/visibility."

}

local layout = {
    -- Action bar1 = bottom center uiparent,
    -- Action bar2 = bottom center action bar 1,
    -- action bar3 = bottom center action bar 2,
    -- Capping

    --                                                    Magic Pretty Numbers
    ChatFrame1 = {
        point = { "BOTTOMLEFT",     "WorldFrame",   "BOTTOMLEFT",   2,      2,      },
        size = { width = nil, height = nil, },
    },

    --                                        Right Magic Margin, Bottom Magic Margin
    DetailsBaseFrame1 = {
        point = { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -40,    55,     },
        size = { width = nil, height = nil, },
    },

    DominosFrame1 = {
        point = { "BOTTOM", "UIParent", "BOTTOM", 0, 0, },
        size = { width = nil, height = nil, }, scale = 0.9,
    },

    DominosFrame6 = {
        point = { "BOTTOM", "DominosFrame1", "TOP", 0, 0, },
        size = { width = nil, height = nil, }, scale = 0.9,
    },

    DominosFrame5 = {
        point = { "BOTTOM", "DominosFrame6", "TOP", 0, 0, },
        size = { width = nil, height = nil, }, scale = 0.9,
    },

    DominosFrame3 = {
        point = { "TOPRIGHT", "UIParent", "TOP", 0, -25, },
        size = { width = nil, height = nil, }, scale = 0.9,
         -- frameOffset/frameScale = frameoffset according to UIParent
    },

    DominosFrame4 = {
        point = { "TOPRIGHT", "DominosFrame3", "TOPLEFT", 0, 0, },
        size = { width = nil, height = nil, }, scale = 0.9,
    },

    --                                               1 px border from BasicMinimap.
    DominosFrameencounter = {
        point = { "BOTTOMRIGHT",    "Minimap",      "TOPRIGHT",     0,      1,      },
        size = { width = nil, height = 36 },
    },

    DominosFrameextra = {
        point = {}, -- undefined in specification or layout
        size = {}, -- undefined in specificaiton or layout
    },

    -- Grid2 frames

    DominosFramequests = {
        point = { "RIGHT",          "UIParent",     "RIGHT",        0,      45,     },
        size = { width = nil, height = "DominosFrame3:GetBottom() - DetailsBaseFrame1:GetTop()", },
    },

    --   Right Magic Margin + Details Width + Right Magic Margin,  Bottom Magic Margin
    Minimap = {
        point = { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -280,   55,     },
        size = { width = nil, height = nil, },
    },

    -- hiui focus frame
    -- pet frame?
    -- ToT frame?

    --                                                           Magic Numbers
    oUF_HiuiplayerFrame = {
        point = { "TOPLEFT",        "UIParent",     "TOPLEFT",      269,    -20,    },
        size = { width = nil, height = nil, },
    },

    oUF_HiuitargetFrame = {
        point = { "TOPRIGHT",       "UIParent",     "TOPRIGHT",     -269,   -20,    },
        size = { width = nil, height = nil, },
    },

    GameTooltip = {
        --                                                 280 = Minimap + magic height
        -- point = { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -280,   280, },
        point = { "BOTTOMRIGHT", "DominosFrameencounter", "TOPRIGHT", 0,    0,      },
        size = { width = nil, height = nil, },
    },

}

--[[    layer levels
Having well-defined layering makes adding new widgets easier.
Layer levels: BACKGROUND, BORDER, ARTWORK, OVERLAY, HIGHLIGHT(only mouseover)
Sub levels: -8 to 7 (Higher = Top, Lower = Bottom)
https://wowpedia.fandom.com/wiki/Layer
--]]



UnitFrames = {
    splitlevel = {
        Health = { layer = nil, level = nil },
        HealthArt = { layer = "ARTWORK", level = 2, },
        ClassHighlight = { layer = "ARTWORK", level = 3, },
        SelectionHighlight = { layer = "ARTWORK", level = 3, },
        ["Health:GetStatusBarTexture"] = { layer = "BACKGROUND", level = -8, },
        VisibleHealthBar = { layer = "ARTWORK", level = 1, },
        ["Health.bg"] = { layer = "ARTWORK", level = -1, },
        ["Power:GetStatusBarTexture"] = { layer = nil, level = nil, }, -- undefined in code
        ["Power.bg"] = { layer = "ARTWORK", level = nil, },
        ["Health.perc"] = { layer = "ARTWORK", level = nil, },
        ["Health.value"] = { layer = "ARTWORK", level = nil, },
        Level = { layer = "ARTWORK", level = nil, },
        Name = { "ARTWORK", level = nil, },
        DispelHighlight = { layer = "ARTWORK", level = 4, },
        --ClassPower - a structure of bars with icons. Each bar its own frame.
        ["ClassPower[i]"] = { layer = nil, level = nil, }, -- own frame
            ["ClassPower[i].icon"] = { layer = "ARTWORK", level = 3, },
        DruidMana = { layer = "ARTWORK", level = nil, },
        RaidTargetIndicator = { layer = "OVERLAY", level = 0, },
        PvPIndicator = { layer = "ARTWORK", level = nil, },
            ["PvPIndicator.Badge"] = { layer = "ARTWORK", level = nil, },
        RestingIndicator = { layer = nil, level = nil, }, -- own frame
            ["RestingIndicator.restIconBg"] = { layer = "OVERLAY", level = 0, },
            ["RestingIndicator.restIcon"] = { layer = "OVERLAY", level = 1, },
        CombatIndicator = { layer = nil, level = nil, }, -- own frame
            ["CombatIndicator.combatIconBg"] = { layer = "OVERLAY", level = 2, },
            ["CombatIndicator.combatIcon"] = { layer = "OVERLAY", level = 3, },
        LeaderIndicator = { layer = "ARTWORK", level = 2, },
        RaidRoleIndicator = { layer = "ARTWORK", level = 2, },
        AssistantIndicator = { layer = "ARTWORK", level = 2, },
        QuestIndicator = { layer = "ARTWORK", level = nil, },
        Castbar = { layer = nil, level = parent.Health:GetFrameLevel() + 1}
        ["Castbar.bg"] = { layer = "OVERLAY", level = nil, },
        ["Castbar.Spark"] = { layer = "OVERLAY", level = nil, },
        ["Castbar.Time"] = { layer = "OVERLAY", level = nil, },
        ["Castbar.Text"] = { layer = "OVERLAY", level = nil, },
        ["Castbar.Icon"] = { layer = "OVERLAY", level = nil, },
        ["Castbar.Shield"] = { layer = "OVERLAY", level = select(2, shield:GetDrawLayer()) + 1}
    },
}

CandyBars = {
    --[[ Top Bar
    --]]
    CandyDetailsFrame = { -- Details
        broker = "Details",
        point = "TOPLEFT",
        relativeTo = "UIParent",
        relativePoint = "TOPLEFT",
        x = 0, y = 0,
    },

    CandyWoWTokenFrame = { -- Broker Everything
        broker = "WoWToken",
    },
    CandyMythicDungeonToolsFrame = { -- MythicDungeonTools
        broker = "MythicDungeonTools",
    },
    CandySimulationCraftFrame = { -- SimulationCraft
        broker = "SimulationCraft",
    },
    CandyBugSackFrame = { --BugSack
        broker = "BugSack",
    },

    ["CandyTRP3—Characterstatus(IC/OOC)Frame"] = { -- TotalRP3
        broker = "TRP3 — Character status (IC/OOC)",
        point = "TOPRIGHT",
        relativeTo = "CandyTRP3—Playerstatus(AFK/DND)Frame",
        relativePoint = "TOPLEFT",
        x = 0, y = 0,
    },
    ["CandyTRP3—Playerstatus(AFK/DND)Frame"] = { -- TotalRP3
        broker = "TRP3 — Player status (AFK/DND)",
        point = "TOPRIGHT",
        relativeTo = "CandyTotalRP3Frame",
        relativePoint = "TOPLEFT",
        x = 0, y = 0,
    },
    CandyTotalRP3Frame = { -- TotalRP3
        broker = "Total RP 3",
        point = "TOPLEFT",
        relativeTo = "UIParent",
        relativePoint = "TOP",
        x = 0, y = 0,
    },
    ["CandyTRP3—LanguageFrame"] = { -- TotalRP3
        broker = "TRP3 — Language",
        point = "TOPLEFT",
        relativeTo = "CandyTotalRP3Frame",
        relativePoint = "TOPRIGHT",
        x = 0, y = 0,
    },

    CandyGPSFrame = { -- Broker Everything
        broker = "GPS",
        point = "TOPRIGHT",
        relativeTo = "UIParent",
        relativePoint = "TOPRIGHT",
        x = 0, y = 0,
    },
    CandyMailFrame = { -- Broker Everything
        broker = "Mail",
        point = "TOPRIGHT",
        relativeTo = "CandyGPSFrame",
        relativePoint = "BOTTOMRIGHT",
        x = 0, y = 0,
    },

    --[[ Bottom Bar
    --]]
    CandyGuildFrame = { -- Broker Everything
        broker = "Guild",
        point = "TOPLEFT",
        relativeTo = "QuickJoinToastButton",
        relativePoint = "RIGHT",
        x = 2, y = 0 -- TODO: magic number
    },
    CandyFriendsFrame = { -- Broker Everything
        broker = "Friends",
        point = "BOTTOMLEFT",
        relativeTo = "CandyGuildFrame", -- optionally QuickJoinToastButton
        relativePoint = "TOPLEFT",
        x = 0, y = 0,
    },

    CandyIDsFrame = { -- Broker Everything
        broker = "IDs",
        point = "TOPRIGHT",
        relativeTo = "DominosFrame1",
        relativePoint = "LEFT",
        x = -2, y = 0, -- TODO: magic number
    },
    CandyDifficultyFrame = {
        broker = "Difficulty",
        point = "BOTTOMRIGHT",
        relativeTo = "CandyIDsFrame",
        relativePoint = "TOPRIGHT",
        x = 0, y = 0,
    },

    CandyXPFrame = {
        broker = "XP",
        point = "TOP",
        relativeTo = "Minimap",
        relativePoint = "BOTTOM",
        x = 0, y = 0,
    },

    CandyNotesFrame = {
        broker = "Notes",
        point = "",
        relativeTo = "",
        relativePoint = "",
        x = 0, y = 0,
    },
    CandybobSatchelsFrame = {
        broker = "bobSatchels",
        point = "",
        relativeTo = "",
        relativePoint = "",
        x = 0, y = 0,
    },

    CandyGoldFrame = { -- Broker Everything
        broker = "Gold",
        point = "BOTTOMRIGHT",
        relativeTo = "UIParent",
        relativePoint = "BOTTOMRIGHT",
        x = 0, y = 0,
    },
    CandyBagsFrame = { -- Broker Evertyhing
        broker = "Bags",
        point = "BOTTOMRIGHT",
        relativeTo = "CandyGoldFrame",
        relativePoint = "TOPRIGHT",
        x = 0, y = 0,
    },
}
