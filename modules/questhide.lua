-- On login...
-- Collapse quest tracker in major city (and show when leaving)
-- Hide quests not in zone.

--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Quest Hiding", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version

--[[ Imports --]]
-- local GlobalUIElement = _G["GlobalUIElement"]
local ObjectiveTracker_Collapse = _G["ObjectiveTracker_Collapse"]

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global
    mod.db.profile
    mod.db.char
--]]
local global, profile, char

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
        collapse_on_resting_area = false,
        hide_irrelevant_quests_during_combat = true,
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
    collapse_on_resting_area = function(_, value)
        if value then
            profile.collapse_on_resting_area = value
            mod:RegisterEvent("PLAYER_UPDATE_RESTING")
        else
            mod:UnregisterEvent("PLAYER_UPDATE_RESTING")
            -- don't unregister PLAYER_REGEN_ENABLED - if its enabled then we need it to restore default state.
        end
    end,

    hide_irrelevant_quests_during_combat = function(_, value)
        --mod:RegisterEvent()
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
        collapse_on_resting_area = {
            order = 3,
            name = "Collapse Quest Tracker when entering a rested area.",
            type = "toggle",
            set = features.collapse_on_resting_area,
            get = function() return profile.collapse_on_resting_area end,
        }
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
    if features.collapse_on_resting_area then self:RegisterEvent("PLAYER_UPDATE_RESTING") end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    self:UnregisterEvent("PLAYER_UPDATE_RESTING")
end

function mod:PLAYER_UPDATE_RESTING()
    if IsResting() then
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED", "PLAYER_UPDATE_RESTING")
            if global.debug then self:Print("Delaying quest log hide because in combat while resting.") end
        else
            ObjectiveTracker_Collapse()
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            if global.debug then self:Print("Left combat and collapsed quest log.") end
        end
    end
end