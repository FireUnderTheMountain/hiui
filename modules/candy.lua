--[[    Header
In this opening block, only the name of the addon, version, info and dependencies needs to be changed.
Dependencies are mod names that you require to be enabled for this mod to load. You should use the folder name exactly.
Module information will be displayed on the main hiui page.
The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Candy Bars", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "Module information."
mod.depends = { "Candy", "Broker_Everything" }

--[[ Imports --]]
local Candy
-- Candy:UpdateCandyBars() -- Candy/core.lua:218
-- Candy:AddCandy(broker) -- Candy/core.lua:380
-- Candy:RemoveCandy(broker) -- Candy/core.lua:401
-- Candy:UpdateCandyAnchors() -- Candy/core.lua:488
-- Candy:LockBars() -- Candy/core.lua:645
-- Candy:SetGlobalFontSize(newSize) -- Candy/options.lua:479
-- Candy:SetGlobalFontOutline(newOutline) -- Candy/options.lua:488
-- Candy:SetGlobalBackgroundColor(r, g, b, a) -- Candy/options.lua:519

--addon:UpdateCandyBars();

--[[    Database Access
Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
mod.db.global, mod.db.profile, mod.db.char
--]]
local global, profile, char

--[[ Local Use
--]]
local function setPoint(broker, point, relativeTo, relativePoint, x, y)
	Candy.db.global.bars[broker]["anchors"][1]["point"] = point
	Candy.db.global.bars[broker]["anchors"][1]["relativeTo"] = relativeTo
	Candy.db.global.bars[broker]["anchors"][1]["relativePoint"] = relativePoint
	Candy.db.global.bars[broker]["anchors"][1]["x"] = x
	Candy.db.global.bars[broker]["anchors"][1]["y"] = y
end

local candyGlobal = {
    ["fontFace"] = "2002",
    ["fontSize"] = 13,
    ["fontOutline"] = "OUTLINE",
    ["locked"] = true,

}

local controlledBars = {
    ["Details"] = {
        anchors = {
            {
                point = "TOPLEFT",
                relativeTo = "UIParent",
                relativePoint = "TOPLEFT",
                x = 0, y = 0,
            }, -- [1]
        },
    },
    ["WoWToken"] = {
        anchors = {
            {
                ["relativeTo"] = "CandyDetailsFrame",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPRIGHT",
            }, -- [1]
        },
        showIcon = true,
        visibility = {
            instanceMode = 3,
        },
    },

    ["TRP3 — Language"] = {
        anchors = {
            {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPRIGHT",
            }, -- [1]
        },
        justify = "CENTER",
        showIcon = true,
        showText = false,
    },
    ["Total RP 3"] = {
        anchors = {
            {
                ["relativeTo"] = "CandyTRP3—LanguageFrame",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPLEFT",
            }, -- [1]
        },
        justify = "CENTER",
        showIcon = true,
        showText = false,
    },
    ["TRP3 — Player status (AFK/DND)"] = {
        anchors = {
            {
                ["relativeTo"] = "CandyTotalRP3Frame",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPLEFT",
            }, -- [1]
        },
        justify = "CENTER",
        showIcon = true,
        showText = false,
    },
    ["TRP3 — Character status (IC/OOC)"] = {
        anchors = {
            {
                ["relativeTo"] = "CandyTRP3—Playerstatus(AFK/DND)Frame",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPLEFT",
            }, -- [1]
        },
        justify = "CENTER",
        showIcon = true,
        showText = false,
    },

    ["Mail"] = {
        ["anchors"] = {
            {
                ["relativeTo"] = "Minimap",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPLEFT",
                x = 2, y = 6,
            }, -- [1]
        },
        luaTextFilter = "return text:gsub(\"Stored mails\", \"\")",
        showIcon = true,
        visibility = {
            customLua = "return not text:match(\"No Mail\")",
            instanceMode = 3,
        },
    },
    ["GPS"] = {
        ["anchors"] = {
            {
                ["relativeTo"] = "Minimap",
                ["point"] = "TOP",
                ["relativePoint"] = "BOTTOM",
                x = 0, y = -4,
            }, -- [1]
        },
        justify = "CENTER",
        fontOutline = "THICKOUTLINE",
        fontSize = 12,
        --fixedWidth= 202, -- causes issues, and names don't normally run this wide anyways.
        -- visibility = { -- don't use this because we use GPS for access to hearthstones.
        --     instanceMode = 3,
        -- },
    },

    ["Difficulty"] = {
        anchors = {
            {
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
                ["relativeTo"] = "DominosFrame1",
            }, -- [1]
        },
        justify = "RIGHT",
        fixedWidth = 100,
    },
    ["IDs"] = {
        ["anchors"] = {
            {
                relativeTo = "CandyDifficultyFrame",
                point = "BOTTOMRIGHT",
                relativePoint = "TOPRIGHT",
            }, -- [1]
        },
        justify = "RIGHT",
        fixedWidth = 100,
        showIcon = true,
    },

    ["bobSatchels"] = {
        ["luaTextFilter"] = "return text:gsub(\"Done!\", \"\")",
        ["fontSize"] = 13,
        ["anchors"] = {
            {
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
                ["relativeTo"] = "CandyVolumeFrame",
            }, -- [1]
        },
        justify = "RIGHT",
        fixedWidth = 100,
        showIcon = true,
    },
    ["Notes"] = {
        ["anchors"] = {
            {
                ["relativeTo"] = "CandybobSatchelsFrame",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "TOPRIGHT",
            }, -- [1]
        },
        justify = "RIGHT",
        fixedWidth = 100,
        showIcon = true,
    },
    ["MythicDungeonTools"] = {
        anchors = {
            {
                ["relativeTo"] = "CandyNotesFrame",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
            }, -- [1]
        },
        justify = "RIGHT",
        showText = false,
        showIcon = true,
    },
    ["SimulationCraft"] = {
        ["anchors"] = {
            {
                ["relativeTo"] = "CandyMythicDungeonToolsFrame",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
            }, -- [1]
        },
        ["visibility"] = {
            instanceMode = 3,
            mode = 3,
        },
        justify = "RIGHT",
        showText = false,
        showIcon = true,
    },
    ["BugSack"] = {
        anchors = {
            {
                ["relativeTo"] = "CandySimulationCraftFrame",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
            }, -- [1]
        },
        justify = "RIGHT",
        showText = false,
        showIcon = true,
    },

    ["Gold"] = {
        anchors = {
            {
                relativeTo = "UIParent",
                point = "BOTTOMRIGHT",
                relativePoint = "BOTTOMRIGHT",
            }, -- [1]
        },
        fixedWidth = 100, -- same as Bags
        justify = "RIGHT",
        showIcon = true,
    },
    ["Volume"] = {
        ["anchors"] = {
            {
                ["relativeTo"] = "CandyGoldFrame",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
            }, -- [1]
        },
        fixedWidth = 100,
        justify = "RIGHT",
        showIcon = true,
    },
    ["Bags"] = {
        anchors = {
            {
                relativeTo = "CandyGoldFrame",
                point = "BOTTOMRIGHT",
                relativePoint = "TOPRIGHT",
            }, -- [1]
        },
        fixedWidth = 100, -- same as Gold
        justify = "RIGHT",
        showIcon = true,
    },
    ["System"] = {
        ["anchors"] = {
            {
                ["relativeTo"] = "CandyBagsFrame",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
            }, -- [1]
        },
        fixedWidth = 100,
        justify = "RIGHT",
    },

    ["Guild"] = {
        ["anchors"] = {
            {
                relativeTo = "QuickJoinToastButton",
                point = "BOTTOMLEFT",
                relativePoint = "BOTTOMRIGHT",
            }, -- [1]
        },
        showIcon = true,
    },
    ["Friends"] = {
        ["anchors"] = {
            {
                relativeTo = "CandyGuildFrame",
                point = "BOTTOMLEFT",
                relativePoint = "TOPLEFT",
            }, -- [1]
        },
        showIcon = true,
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
        initialized = 0, -- candy uses global bar placement.
        readyForInit = false,
    },
    profile = {
        enabled = false, -- have root addon enable?
    },
    char = {
    },
}


--[[    "Features" local variable
Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
Remember to set/change db values during these functions.
--]]
local features = {
    -- This actually only resets VISIBLE frames, otherwise :RemoveCandy() errors on `addon.ActiveBars[broker]:Hide()`
    reset_all_frames = function()
        --for k,_ in pairs(Candy.db.global.bars) do
        --    if Candy.ActiveBars[k] then Candy:RemoveCandy(k) end
        for b,_ in pairs(Candy.ActiveBars) do
            Candy:RemoveCandy(b)
        end

        global.readyForInit = true
        C_UI.Reload()
    end,

    place_controlled_bars = function()
        if global.debug then mod:Print("Placing bars from Hiui structure into candy.") end
        -- Using both AddCandy or CreateCandyBar needs an icon and the text because that's how they do it in their drop down menu. God i hate mixing UI and code...
        -- local brokerNames = Candy:GetAddableBrokers()
        -- for nameWithIcon,_ in pairs(brokerNames) do
        --     for plainName,_ in pairs(controlledBars) do
        --         if strmatch(nameWithIcon, plainName .. "$") then
        --             if global.debug then mod:Print(nameWithIcon .. " matched " .. plainName .. ".") end
        --             brokerNames[nameWithIcon] = controlledBars[plainName]
        --             break
        --         else
        --             --if global.debug then mod:Print(nameWithIcon .. " didn't match " .. plainName .. ".") end
        --         end
        --         brokerNames[nameWithIcon] = nil -- didn't break so got here.
        --     end
        -- end

        for broker,settings in pairs(controlledBars) do
            Candy:AddCandy(broker)
            local frame = Candy.ActiveBars[broker]
            frame.data = Candy.db.global.bars[broker] -- posterity
            --mod:Print(frame, frame:GetName())

            for k,v in pairs(settings) do
                Candy.db.global.bars[broker][k] = v
            end

            -- Frame background creation from Candy:AddCandy()
            -- frame.data.backgroundColor = { unpack(Candy.db.global.backgroundColor) }
            -- frame.background:SetVertexColor(unpack(frame.data.backgroundColor))
            -- frame.background:Hide()
            frame.configBackground:Hide()

            -- local a = Candy.db.global.bars[broker].anchors[1]
            -- frame:ClearAllPoints()
            -- frame:SetPoint(a.point, a.relativeTo, a.relativePoint, a.x, a.y)
        end

        Candy:UpdateCandyAnchors()
        Candy:LockBars()
    end,

    hide_uncontrolled_bars = function()
        if global.debug then mod:Print("Hiding any shown bars that aren't supposed to be there.") end
        for k,_ in pairs(Candy.ActiveBars) do
            if not controlledBars[k] then
                Candy:RemoveCandy(k)
            end
        end
    end,

    apply_candy_globals = function()
        if global.debug then mod:Print("Applying globals to candy structure.") end
        Candy:SetGlobalBackgroundColor(0, 0, 0, 0)
        Candy:SetGlobalFontSize(candyGlobal.fontSize)
        Candy:SetGlobalFontOutline(candyGlobal.fontOutline)
        -- There is no :SetGlobalFontFace(), they just...
        -- Candy/options.lua:339
        Candy.db.global.fontFace = candyGlobal.fontFace
        Candy.db.global.locked = candyGlobal.locked
    end,
}

--[[    GUI Options Menu
Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
--]]
local options = {
    name = " " .. name,
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
        reset_all_frames = {
            order = 3,
			name = "Clear All Candy Bars",
			desc = "Reset the size and position of all LibDataBroker bars. Useful for first-time setup or UI refresh. Do not use otherwise.",
            confirmText = "This will wipe all LDB bar positions, even ones you manually positioned! This will reload your UI.",
			type = "execute",
			confirm = true,
			func = features.reset_all_frames,
		},
        place_controlled_bars = {
            order = 5,
			name = "Place Hiui Candy Bars",
			desc = "Move all LibDataBroker bars into the spots preferred by Hiui.",
			type = "execute",
			func = features.place_controlled_bars,
		},
        hide_uncontrolled_bars = {
            order = 6,
			name = "Hide Unused Candy Bars",
			desc = "Hide all LibDataBroker bars that aren't used by Hiui. Use this to get rid of floating bars in the middle of your screen.",
            confirmText = "This will remove customizations you may have made to your LDB bars.",
			type = "execute",
			confirm = true,
			func = features.hide_uncontrolled_bars,
		},
        apply_candy_globals = {
            order = 4,
			name = "Apply default font settings.",
			desc = "apply the Hiui recommended font and outline settings for LDB bars.",
			type = "execute",
			func = features.apply_candy_globals,
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
    global, profile, char = self.db.global, self.db.profile, self.db.char

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ Gray out args. do not modify. --]]
    if not profile.enabled then disableArgs(options) end

    --[[ Module specific on-load routines go here. --]]
    Candy = LibStub("AceAddon-3.0"):GetAddon("Candy")
end

function mod:OnEnable()
    --[[ For combat-unsafe mods. --]]
    if InCombatLockdown() then
        return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
    end
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")

    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. You can modify this according to the module's needs. --]]
	if global.readyForInit then
        C_Timer.After(0.06, features.apply_candy_globals)
        -- Heuristically determined this delay:
        C_Timer.After(0.1, features.place_controlled_bars)
        C_Timer.After(0.3, features.hide_uncontrolled_bars)

        --Candy:UpdateCandyBars();

        C_Timer.After(5, function() mod:Print("You may need to reload the UI one more time after creating all these candy bars if they show too much text!") end)

        global.readyForInit = nil
    end

    --[[ Module specific on-run routines go here. --]]
    C_Timer.After(0.5, function() Candy:UpdateVisibility() end)
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
