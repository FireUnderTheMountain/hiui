--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Minimap", 0.12
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "Minimap button hiding and BasicMinimap positioning and customizations."
mod.depends = { "BasicMinimap" }

--[[ Imports --]]
local bm = _G["BasicMinimap"]

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global
    mod.db.profile
    mod.db.char
--]]
local global, profile, char

--[[ Locals --]]
local function setHiuiProfile(p)
    p = mod.db.parent:GetCurrentProfile() or p or "Hiui"

    if bm.db:GetCurrentProfile() ~= p then
        if global.debug then mod:Print("Candy profile isn't " .. p .. ", changing that so we can preserve your past settings.") end
        bm.db:SetProfile(p)
    end

    return bm.db:GetCurrentProfile() == p
end

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
        set_basicminimap_pos = 0, -- first time load
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

        if IsAddOnLoaded("SimulationCraft") then
            local sc = _G["LibDBIcon10_SimulationCraft"]
            if sc and sc:IsShown() then
                if global.debug then mod:Print("Hiding Simcraft Minimap Button.") end

                --DEFAULT_CHAT_FRAME.editBox:SetText("/simc minimap")
                --ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
                RunSlashCmd("/simc minimap")
            end
        end

        if IsAddOnLoaded("Details") then
            local d = _G["LibDBIcon10_Details"]
            if d and d:IsShown() then
                if global.debug then mod:Print("Hiding Details Minimap Button.") end

                if _G.Details.db.profile.Minimap then
                    if global.debug then mod:Print("Hiding details minimap button by changing LDBI .hide variable.") end
                    _G.Details.db.profile.Minimap.hide = true
                elseif _G.DetailsOptionsWindowTab11Label3:GetText() == "Show Icon: " then
                    if global.debug then mod:Print("Found details window button, clicking it.") end
                    _G.DetailsOptionsWindowTab11Widget3:Click("LeftButton")
                else
                    if global.debug then mod:Print("Hiding details minimap button as a temporary measure.") end
                    l:Hide("Details")
                end
            end
        end

        if IsAddOnLoaded("Myslot") then
            local m = _G["LibDBIcon10_Myslot"]

            local MyslotSettings = _G["MyslotSettings"]
            MyslotSettings = MyslotSettings or {}
            MyslotSettings.minimap = MyslotSettings.minimap or { hide = true }
            MyslotSettings.minimap.hide = true

            if global.debug then mod:Print("Hiding Myslot Minimap Button.") end

            l:Hide("Myslot")
        end

        if IsAddOnLoaded("BugSack") then
            C_Timer.After(1, function() -- BugSack delays this stuff until player login.
                local b = _G["LibDBIcon10_BugSack"]
                if b and b:IsShown() then
                    if global.debug then mod:Print("Hiding BugSack Minimap Button.") end

                    _G["BugSackLDBIconDB"].hide = true -- this is all we should need.
                    l:Hide("BugSack")

                    -- Hook a more permanent hiding solution
                    -- local bsf = _G["BugSack"].frame
                    -- bsf:HookScript("OnShow", function()
                    --     local bcb = _G["BugSackCheckMinimap icon"]
                    --     if not bcb then
                    --         if global.debug then mod:Print("Opened bugsack frame but minimap checkbox still isn't present. Need modificiations to hook.") end
                    --     elseif bcb:GetChecked() then
                    --         bcb:Click("LeftButton")
                    --     end
                    -- end)
                end
            end)
        end

        if IsAddOnLoaded("Plater") then
            local p = _G["LibDBIcon10_Plater"]
            if p and p:IsShown() then
                if global.debug then mod:Print("Hiding Plater Minimap Button.") end
                RunSlashCmd("/plater minimap")
            end
        end

        local bobConfigExists = bobSatchelsSaved and bobSatchelsSaved[UnitName("player").."-"..GetRealmName()] and (bobSatchelsSaved[UnitName("player").."-"..GetRealmName()]["minimap"] == true)
        if IsAddOnLoaded("bobSatchels") and bobConfigExists then
            bobSatchelsSaved[UnitName("player").."-"..GetRealmName()]["minimap"] = false;
        end
    end,

    set_basicminimap_pos = function()
        if bm then
            if not setHiuiProfile() then
                mod:Print("Hiui only operates on addons that use the same profile as it. Please type /bm and set your BasicMinimap profile to \"" .. mod.db.parent:GetCurrentProfile() .. "\".")
                return
            end

            local m = _G["Minimap"]

            local desired = {
                bitt = "BOTTOMRIGHT",
                anchor = "BOTTOMRIGHT",
                xOffset = -280,
                yOffset = 55,

                height = 200, -- unused
                width = 200, -- unused
            }
            --EnableAddOn("BasicMinimap_Options")
            --LoadAddOn("BasicMinimap_Options")

            --[[ Replicate BM's ace options .set() command as much as we need
            Make it movable, set its position, then lock it.
            --]]
            bm.db.profile.lock = false
            bm.SetMovable(m, true) -- this is truly a bizarre way to do this: the Minimap.SetMovable func points to one address, and all other .SetMovable's point to a different, shared address. Big sus.
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

            mod:Print("Minimap modified. Reload the UI to apply changes.")
        end
    end,
}

--[[    GUI Options Menu
    Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
    The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
]]
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
            char[feature] = mod.version
        end
    end

    --[[ Module specific on-run routines go here. --]]
    if profile.clean_misc_minimap_icons then features.clean_misc_minimap_icons() end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
