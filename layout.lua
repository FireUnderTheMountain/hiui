## Layout

local layout = {
    -- Action bar1 = bottom center uiparent,
    -- Action bar2 = bottom center action bar 1,
    -- action bar3 = bottom center action bar 2,
    -- Capping

    --                                                                          Magic Pretty Numbers
    ChatFrame1 =            { "BOTTOMLEFT",     "WorldFrame",   "BOTTOMLEFT",   2,      2,      },

    --                                                                   Right Magic Margin, Bottom Magic Margin
    DetailsBaseFrame1 =     { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -40,    55,     },

    --                                                                          1 px border from BasicMinimap.
    DominosFrameencounter = { "BOTTOMRIGHT",    "Minimap",      "TOPRIGHT",     0,      1,      },
    -- Height: 36

    -- Grid2 frames
    DominosFramequests =    { "RIGHT",          "UIParent",     "RIGHT",        0,      45,     },
    -- Height: DominosFrame3:GetBottom() - DetailsBaseFrame1:GetTop()
    -- Width: 

    --                         Right Magic Margin + Details Width + Right Magic Margin,  Bottom Magic Margin
    Minimap =               { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -280,   55,     },
    -- hiui focus frame
    -- pet frame?
    -- ToT frame?

    --                                                                          Magic Numbers
    oUF_HiuiplayerFrame =   { "TOPLEFT",        "UIParent",     "TOPLEFT",      269,    -20,    },
    oUF_HiuitargetFrame =   { "TOPRIGHT",       "UIParent",     "TOPRIGHT",     -269,   -20,    },

    --                                                                              Minimap + magic height
    --GameTooltip =           { "BOTTOMRIGHT",    "UIParent",     "BOTTOMRIGHT",  -280,   280,    },
    GameTooltip =           { "BOTTOMRIGHT", "DominosFrameencounter", "TOPRIGHT", 0,    0,      },
}
