--[[    Header
    In this opening block, only the name of the addon, version, info and dependencies needs to be changed.
    Dependencies are mod names that you require to be enabled for this mod to load. You should use the folder name exactly.
    Module information will be displayed on the main hiui page.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Extra Quest Button", 0.7
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "Positions the quest item button automatically."
mod.depends = { "ExtraQuestButton" }

--[[ Imports --]]
-- local GlobalUIElement = _G["GlobalUIElement"]

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
        initialized = 0,
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
        local ExtraQuestButtonAnchor = _G["ExtraQuestButtonAnchor"]
        local DominosFrameextra = _G["DominosFrameextra"]

        if not ExtraQuestButtonAnchor:IsShown() then ExtraQuestButtonAnchor:Toggle() end

        C_Timer.After(0.04, function()
            ExtraQuestButtonAnchor:OnDragStart() -- :StartMoving()
            ExtraQuestButtonAnchor:ClearAllPoints()

            if DominosFrameextra then
                if global.debug then mod:Print("Using dominos position.") end

                local scale = DominosFrameextra:GetScale()

                local h, w = DominosFrameextra:GetBottom(), select(1, DominosFrameextra:GetCenter())
                if global.debug then mod:Print(w, h) end

                --ExtraQuestButtonAnchor:SetPoint("TOP", DominosFrameextra, "BOTTOM")
                ExtraQuestButtonAnchor:SetPoint("TOP", UIParent, "BOTTOMLEFT", w*scale, h*scale)
            else
                if global.debug then mod:Print("Using best guess positioning.") end
                -- Best Guess It MAGIC NUMBER
                ExtraQuestButtonAnchor:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", UIParent:GetWidth()*2/3, UIParent:GetHeight()/3)
            end

            ExtraQuestButtonAnchor:OnDragStop()

            if ExtraQuestButtonAnchor:IsShown() then ExtraQuestButtonAnchor:Toggle() end

            if global.debug then mod:Print("Moved extra quest button anchor.") end
        end)
	end,

    set_item_range_to_max = function()
        -- ExtraQuestButton prohibits modifying its settings.
        InterfaceOptionsFrame_OpenToCategory("ExtraQuestButton")
        InterfaceOptionsFrame_OpenToCategory("ExtraQuestButton")
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
            name = "EQB Settings",
            desc = "EQB prohibits other addons from modifying it. We recommend setting item distance to maximum and enabling \"Only show in zone\", and optionally hiding the art, as it may overlap other frames.",
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
    if profile.initialized < mod.version then
        if global.debug then mod:Print("Update.") end
        features.move_eqb_to_default_pos()
        profile.initialized = mod.version
    end

    --[[ Module specific on-run routines go here. --]]
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
