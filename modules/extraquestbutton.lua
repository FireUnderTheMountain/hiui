--[[    Header
    In this opening block, only the name of the addon, version, info and dependencies needs to be changed.
    Dependencies are mod names that you require to be enabled for this mod to load. You should use the folder name exactly.
    Module information will be displayed on the main hiui page.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Extra Quest Button", 0.1
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "Module information."
mod.depends = { "ExtraQuestButton" }

--[[ Imports --]]
-- local GlobalUIElement = _G["GlobalUIElement"]
local ExtraQuestButtonAnchor = _G["ExtraQuestButtonAnchor"]
local DominosFrameextra = _G["DominosFrameextra"]

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global - mod.db.profile - mod.db.char
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
        move_eqb_to_default_pos = false,
        set_item_range_to_max = false,
    },
    char = {
    },
}


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
	move_eqb_to_default_pos = function()
        RunSlashCmd("/eqb lock")
        ExtraQuestButtonAnchor:StartMoving()
        ExtraQuestButtonAnchor:ClearAllPoints()
        ExtraQuestButtonAnchor:SetPoint("BOTTOM", DominosFrameextra, "TOP")
        ExtraQuestButtonAnchor:StopMovingOrSizing()
        RunSlashCmd("/eqb lock")
    	if global.debug then mod:Print("Moved extra quest button anchor.") end
	end,

    set_item_range_to_max = function()

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
        move_eqb_to_default_pos = {
            order = 3,
			name = "Align extra quest button.",
			desc = "Put the quest item button directly beneath the extra action button.",
			type = "execute",
			func = features.move_eqb_to_default_pos,
		},
        set_item_range_to_max = {
            order = 4,
            name = "Show EQB at long range.",
            desc = "These settings can be fine tuned from EQBs options page.",
            type = "execute",
            func = features.set_item_range_to_max,
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
    global, profile, char = self.db.global, self.db.profile, self.db.char

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
	if not profile.move_eqb_to_default_pos then
        features.move_eqb_to_default_pos()
        profile.move_eqb_to_default_pos = true
    end

    if not profile.set_item_range_to_max then
        features.set_item_range_to_max()
        profile.set_item_range_to_max = true
    end

    --[[ Module specific on-run routines go here. --]]
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end