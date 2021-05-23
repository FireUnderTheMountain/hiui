--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Minimap", 0.12
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version

--[[ Imports --]]


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
        clean_misc_minimap_icons = true,
    },
    char = {
        initialized = 0, -- used for first time load
        set_basicminimap_pos = 0,
        clean_misc_minimap_icons = 0,
    },
}


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
    clean_misc_minimap_icons = function()
        local l = LibStub("LibDBIcon-1.0")

        local sc = _G["LibDBIcon10_SimulationCraft"]
        if sc and sc:IsShown() then
            if global.debug then mod:Print("Hiding Simcraft Minimap Button.") end

			--DEFAULT_CHAT_FRAME.editBox:SetText("/simc minimap")
			--ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
			RunSlashCmd("/simc minimap")
		end

        local d = _G["LibDBIcon10_Details"]
        if d and d:IsShown() then
            if global.debug then mod:Print("Hiding Details Minimap Button.") end

            if _G["DetailsOptionsWindowTab11Label3"]:GetText() == "Show Icon: " then
                _G["DetailsOptionsWindowTab11Widget3"]:Click("LeftButton")
            else
                l:Hide("Details")
            end
        end

        local m = _G["LibDBIcon10_Myslot"]
        if m and m:IsShown() then
            if global.debug then mod:Print("Hiding Myslot Minimap Button.") end

            -- Myslot keeps all their buttons anonymous. The only true way to fix this is iterate through the addon options pages looking for unique information, like the Myslot guy's email address, and get the button relative to there.
            -- Heuristically delay?
            C_Timer.After(0.5, function() l:Hide("Myslot") end)
        end

        local b = _G["LibDBIcon10_BugSack"]
        if b and b:IsShown() then
            if global.debug then mod:Print("Hiding BugSack Minimap Button.") end

            local bcb = _G["BugSackCheckMinimap icon"]
            if bcb then bcb:Click("LeftButton") else l:Hide("BugSack") end
        end

        local p = _G["LibDBIcon10_Plater"]
        if p and p:IsShown() then
            if global.debug then mod:Print("Hiding Plater Minimap Button.") end
            RunSlashCmd("/plater minimap")
        end
    end,

    set_basicminimap_pos = function()
        local bm = _G["BasicMinimap"]

        if bm then
            -- TODO: Check profile is not hiui, set it.
            local m = _G["Minimap"]

            local desired = {
                bitt = "BOTTOMRIGHT",
                anchor = "BOTTOMRIGHT",
                xOffset = -280,
                yOffset = 55,

                height = 200,
                width = 200,
            }
            --EnableAddOn("BasicMinimap_Options")
            --LoadAddOn("BasicMinimap_Options")

            --[[ Replicate BM's ace options .set() command as much as we need
            Make it movable, set its position, then lock it.
            --]]
            bm.db.profile.lock = false
            bm.SetMovable(m, true) -- this is truly a bizarre way to do this, but the Minimap.SetMovable func points to one address, and all other .SetMovable's point to a different, shared address. Big sus.
            m:StartMoving()

            bm.db.profile.position = {
                [1] = desired.bitt,
                [2] = desired.anchor,
                [3] = desired.xOffset,
                [4] = desired.yOffset,
            }
            m:ClearAllPoints()
            m:SetPoint(desired.bitt, UIParent, desired.anchor, desired.xOffset, desired.yOffset)
            m:SetSize(desired.width, desired.height)

            m:StopMovingOrSizing()
            bm.SetMovable(m, false)
            bm.db.profile.lock = true
        end
    end,
}

--[[    GUI Options Menu
    Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
    The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
]]
local options = {
    name = name,
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
        clean_misc_minimap_icons = {
            order = 3,
            name = "Clean minimap of icons",
            desc = "Some addons have troublesome minimap icons, we can just hide them all.",
            type = "toggle",
            set = function(_, value)
                profile.clean_misc_minimap_icons = value
                if value then features.clean_misc_minimap_icons() end
            end,
            get = function() return profile.clean_misc_minimap_icons end,
        },
        set_basicminimap_pos = {
            order = 4,
			name = "Move Minimap",
			type = "execute",
			func = features.set_basicminimap_pos,
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
    for feature, ver in pairs(char) do
        if ver < mod.version and type(features[feature]) == "function" then
            if global.debug then self:Print("Running " .. feature .. " for update.") end
            features[feature]()
            char.feature = mod.version
        end
    end

    --[[ Module specific on-run routines go here. --]]
    if profile.clean_misc_minimap_icons then features.clean_misc_minimap_icons() end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
