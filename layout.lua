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
        size = { width = "", height = "", },
    },

    --                                        Right Magic Margin, Bottom Magic Margin
    DetailsBaseFrame1 = {
        point = { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -40,    55,     },
        size = { width = "", height = "", },
    },

    --                                               1 px border from BasicMinimap.
    DominosFrameencounter = {
        point = { "BOTTOMRIGHT",    "Minimap",      "TOPRIGHT",     0,      1,      },
        size = { width = "", height = "36" },
    },

    DominosFrameextra = {
        point = {}, -- undefined in specification or layout
        size = {}, -- undefined in specificaiton or layout
    },

    -- Grid2 frames

    DominosFramequests = {
        point = { "RIGHT",          "UIParent",     "RIGHT",        0,      45,     },
        size = { width = "", height = "DominosFrame3:GetBottom() - DetailsBaseFrame1:GetTop()", },
    },

    --   Right Magic Margin + Details Width + Right Magic Margin,  Bottom Magic Margin
    Minimap = {
        point = { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -280,   55,     },
        size = { width = "", height = "", },
    },

    -- hiui focus frame
    -- pet frame?
    -- ToT frame?

    --                                                           Magic Numbers
    oUF_HiuiplayerFrame = {
        point = { "TOPLEFT",        "UIParent",     "TOPLEFT",      269,    -20,    },
        size = { width = "", height = "", },
    },

    oUF_HiuitargetFrame = {
        point = { "TOPRIGHT",       "UIParent",     "TOPRIGHT",     -269,   -20,    },
        size = { width = "", height = "", },
    },

    GameTooltip = {
        --                                                 280 = Minimap + magic height
        -- point = { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -280,   280, },
        point = { "BOTTOMRIGHT", "DominosFrameencounter", "TOPRIGHT", 0,    0,      },
        size = { width = "", height = "", },
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
        HealthArt = { layer = "ARTWORK", level = 2, },
        ClassHighlight = { layer = "ARTWORK", level = 3, },
        SelectionHighlight = { layer = "ARTWORK", level = 3, },
        ["Health:GetStatusBarTexture"] = { layer = "BACKGROUND", level = -8, },
        VisibleHealthBar = { layer = "ARTWORK", level = 1, },
        ["Health.bg"] = { layer = "ARTWORK", level = -1, },
        ["Power:GetStatusBarTexture"] = { layer = nil, level = nil, }, -- undefined in code
        ["Power.bg"] = { layer = "ARTWORK", level = nil, },
        ["Health.perc"] = { layer = "OVERLAY", level = nil, },
        ["Health.value"] = { layer = "OVERLAY", level = nil, },
        Level = { layer = "OVERLAY", level = nil, },
        Name = { "OVERLAY", level = nil, },
        DispelHighlight = { layer = "OVERLAY", level = nil, },
        --ClassPower - a structure of bars with icons. Each bar its own frame.
        ["ClassPower[i]"] = { layer = nil, level = nil, }, -- own frame
            ["ClassPower[i].icon"] = { layer = "ARTWORK", level = 3, },
        DruidMana = { layer = "OVERLAY", level = nil, },
        PvPIndicator = { layer = "OVERLAY", level = -1, },
        RestingIndicator = { layer = nil, level = nil, }, -- own frame
            ["RestingIndicator.restIconBg"] = { layer = "OVERLAY", level = 0, },
            ["RestingIndicator.restIcon"] = { layer = "OVERLAY", level = 1, },
        CombatIndicator = { layer = nil, level = nil, }, -- own frame
            ["CombatIndicator.combatIconBg"] = { layer = "OVERLAY", level = 2, },
            ["CombatIndicator.combatIcon"] = { layer = "OVERLAY", level = 3, },
    },
}
