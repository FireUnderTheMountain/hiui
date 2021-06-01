--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "XLoot Positioning", 0.1
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "XLoot temporary loot display to free your chat log from spam."
mod.depends = { "XLoot", "XLoot_Monitor" }

--[[ Imports --]]
local xl, xlm

-- These are hardcoded, xloot/stacks.lua lines 48 and 50
local xlaH = 20
local xlaW = 175

--[[    Layout
    This bs is why we need a layout file :<
    We're messing with the top left corner, so adjust for height and width when necessary.
--]]
-- uiparent width - details margin - details width - minimap margin - anchor width
local minimapX = _G.UIParent:GetWidth() - 40 - 200 - 40 - xlaW
-- bottom of ui + minimap margin + minimap height + tooltip margin + anchor height
local minimapY = 0 + 55 + 200 + 25 + xlaH

-- uiparent width - details margin - details width + offset
local detailsX = _G.UIParent:GetWidth() - 40 - 200 + 1
-- bottom of ui + details margin + offset + anchor height
local detailsY = 0 + 55 + 1 + xlaH

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global
    mod.db.profile
    mod.db.char
--]]
local global, profile, char


local anchorTable = {
    direction = "up",
    alignment = "left",
    visible = false,
    scale = 1.0,
    draggable = false,
    x = 0,
    y = 0,
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
        enabled = false, -- have root addon enable?
        align_loot_above_minimap = false,
        align_loot_on_details = true,
    },
    char = {
        initialized = 0, -- used for first time load
    },
}


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
    align_loot_above_minimap = function()
        local m = mod.db.parent:GetCurrentProfile()
        if xl.db:GetCurrentProfile() ~= m then
            mod:Print("XLoot is set to a personal profile. Please open XLoot options and set your profile to \"" .. m .. "\".")
            return
        end

        anchorTable.alignment = "right"
        anchorTable.x = minimapX
        anchorTable.y = minimapY

        xlm.db.profile.anchor = anchorTable

        profile.align_loot_above_minimap = true
        profile.align_loot_on_details = false
    end,

    align_loot_on_details = function()
        local m = mod.db.parent:GetCurrentProfile()
        if xl.db:GetCurrentProfile() ~= m then
            mod:Print("XLoot is set to a personal profile. Please open XLoot options and set your profile to \"" .. m .. "\".")
            return
        end

        anchorTable.alignment = "left"
        anchorTable.x = detailsX
        anchorTable.y = detailsY

        xlm.db.profile.anchor = anchorTable

        profile.align_loot_above_minimap = false
        profile.align_loot_on_details = true
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
        align_loot_above_minimap = {
			name = "Above minimap",
			desc = "Make loot grow upwards from the top of the minimap. Requires a UI reload.",
			type = "execute",
			confirm = false,
			func = features.align_loot_above_minimap,
		},
        align_loot_on_details = {
			name = "Right of minimap",
			desc = "Loot will grow up from beside the minimap. Reuires a UI reload.",
			type = "execute",
			confirm = false,
			func = features.align_loot_on_details,
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

    --[[ Module specific on-run routines go here. --]]
    xl = LibStub("AceAddon-3.0"):GetAddon("XLoot")
    if xl then
        xlm = xl:GetModule("Monitor")
        if not xlm then
            mod:Print("Disabling xloot mod because xloot monitor not detected.")
            mod:Disable()
            return
        end
    end

    if profile.align_loot_above_minimap then
        features.align_loot_above_minimap()
    elseif profile.align_loot_on_details then
        features.align_loot_on_details()
    end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
