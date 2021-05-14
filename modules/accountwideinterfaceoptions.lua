--[[    Header
    In this opening block, only the name of the addon needs to be changed.
--]]
local Hiui = Hiui
local name = "Account-wide Interface Options & Tracking"
local mod = Hiui:NewModule(name)
mod.modName = name --unnecessary?
mod.version = 1
local you
local db, options

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    Hiui.db.global.modules[name]
    Hiui.db.profile.modules[name]
    Hiui.db.char.modules[name]
]]
local global, profile, char

--[[    Default Values
    In each module, you can begin editing defaults for this module by using defaults.global|profile|char.modules.MyModule
    Variables set in init.lua default table don't need to be set unless you want them set differently. They are:
    Hiui.defaults.global.modules[name].debug = false
    Hiui.defaults.profile.modules[name].enabled = false
    Hiui.defaults.char.modules[name].initialized = false
--]]
local defaults = Hiui.defaults
defaults.global.modules[name] = {
    debug = true, -- noisy debugging information.
}
defaults.profile.modules[name] = {
    enabled = true,

    interfaceOptionsStorage = { [0] = false, buttons = { }, dropdowns = { }, },
    trackingStorage = { [0] = false, },
    autotrack = false,
}
defaults.char.modules[name] = {
}

--[[    INTERFACE OPTIONS DECLARATIONS --]]
local panels = {
    "InterfaceOptionsControlsPanel",
    "InterfaceOptionsCombatPanel",
    "InterfaceOptionsDisplayPanel",
    "InterfaceOptionsSocialPanel",
    "InterfaceOptionsActionBarsPanel",
    "InterfaceOptionsNamesPanel",
}
local knownUnhandledFrames = {
    InterfaceOptionsDisplayPanelResetTutorials = true,
    InterfaceOptionsSocialPanelTwitterLoginButton = true,
    InterfaceOptionsSocialPanelRedockChat = true,
}
local ios, mainTracking -- profile.interfaceOptionsStorage, profile.TrackingStorage

-- Ref: FrameXML/InterfaceOptionsPanels.lua
local function InterfaceOptionsStorage_ReadAndSaveInterfacePanel()
    for _, p in ipairs(panels) do
        --msg("Frame " .. p .. " got!", DEBUG_INTERFACE_SAVING)
        for _, child in ipairs({_G[p]:GetChildren()}) do
            local cName = child:GetName()
            if cName then
                --msg("Handling frame " .. cName, DEBUG_INTERFACE_SAVING)

                local cType = child:GetObjectType()
                --msg(cName .. " is a " .. tostring(cType), DEBUG_INTERFACE_SAVING)
                if cType == "CheckButton" then
                    ios.buttons[cName] = child:GetChecked()
                elseif cType == "Slider" then
                    ios.dropdowns[cName] = child:GetValue()
                elseif cType == "Frame" then
                    if child.cvar then -- Dropdown with cvar
                        ios.dropdowns[cName] = child:GetValue()
                        --msg(cName .. " has associated CVar.", DEBUG_INTERFACE_SAVING)
                    elseif child.value then -- sliders & toggles
                        ios.dropdowns[cName] = child:GetValue()
                        --msg(cName .. " has associated value.", DEBUG_INTERFACE_SAVING)
                    end
                elseif not knownUnhandledFrames[cName] then
                    --msg("Frame " .. cName .. " on panel " .. p .. " is an unhandled frame type: " .. tostring(cType) .. ". Please report this.", WARN_UNHANDLED_FRAME_TYPE)
                end
            end
        end
    end
    return "Saved"
end

local timerCloseInterfaceOptions -- only useful for debugging
function InterfaceOptionsStorage_Save()
    if InCombatLockdown() then
        Hiui:Print("Please wait until combat ends to try to save your variables.")
        return
    end

    local InterfaceOptionsFrame = _G["InterfaceOptionsFrame"]
    InterfaceOptionsFrame_Show()
    local function closeIOF(self)
        -- Have to check combat lockdown again because this is being run in a separate thread.
        if InCombatLockdown() then return end

        local did = InterfaceOptionsStorage_ReadAndSaveInterfacePanel()
        if did == "Saved" then
            ios[0] = true
            Hiui:Print("HIUI ACE DEBUG: DID THE INTERFACE SAVING!")
        else
            Hiui:Print("HIUI ACE DEBUG: For some resaon didn't save interface settings. Unexpected.")
        end
        --InterfaceOptionsFrameCancel:Click() -- replace with :hide()
        InterfaceOptionsFrame:Hide()
        --msg("Saving interface options. Please relead to prevent miscellaneous errors in combat.", WARN_NEED_RELOAD)
        self:Cancel()
    end
    timerCloseInterfaceOptions = C_Timer.NewTicker(0.17, closeIOF)
end

local seenIosMessage = false
function InterfaceOptionsStorage_Load()
    if InCombatLockdown() then
        if not seenIosMessage then
            Hiui:Print("Restoring cvars not support in combat. Will apply once you leave combat.")
            seenIosMessage = true
        end
        C_Timer.After(1.5, InterfaceOptionsStorage_Load())
        return
    end
    seenIosMessage = false

    --[[ Click all the buttons. --]]
    for b, desiredState in pairs(ios.buttons) do
        local button = _G[b]
        local checkState = button:GetChecked()
        if button:IsEnabled() and checkState ~= desiredState then
            Hiui:Print("Adjusted interface option " .. b .. ".")
            button:SetChecked(not checkState)
            button:GetScript("OnClick")(button) -- Fizzie said to do this.
        end
    end

    --[[ Set all dropdown menus, toggles, and sliders. --]]
    for dd, desiredState in pairs(ios.dropdowns) do
        local dropdown = _G[dd]
        if dropdown:GetValue() ~= desiredState then
            Hiui:Print("Adjusted interface option " .. dd .. ".")
            dropdown:SetValue(desiredState)
        end
    end
    return "Loaded"
    --msg("You changed your interface settings. You should /reload to avoid awful lua errors in combat!")
end

function TrackingStorage_Save(sparse)
    sparse = (sparse and true or false)
    for i=1, GetNumTrackingTypes() do
        local t, _, active, _ = GetTrackingInfo(i)
        active = (active or false) -- these shenanigans seem unnecessary in modern wow
        local different = mainTracking[t] ~= nil and mainTracking[t] ~= active
        --Hiui:Print(t, " is ", different, "different from ", mainTracking[t], ".")
        if mainTracking[t] == nil then -- for some reason this never runs.
        --if not mainTracking[t] and mainTracking[t] ~= false then
            mainTracking[t] = active
            Hiui:Print("Found new tracking \"" .. t .. "\".")
        elseif different and not sparse then
            mainTracking[t] = active
            local m = active and ("Tracking \"" .. t .. "\".") or ("Setting \"" .. t .. "\" tracking inactive.")
            Hiui:Print(m)
        end
    end
    Hiui:Print("Your current character's tracking has been saved.")
    return "Saved"
end

local seenTrackingMessage = false
function TrackingStorage_Load()
    if InCombatLockdown() then
        if not seenTrackingMessage then
            Hiui:Print("Changing tracking settings not support in combat. Will apply once you leave combat.")
            seenTrackingMessage = true
        end
        C_Timer.After(1.5, TrackingStorage_Load())
        return
    end
    seenTrackingMessage = false

    if not next(mainTracking) then
        Hiui:Print("Can't load your tracking settings because you haven't saved any!")
        return
    end

    for i=1, GetNumTrackingTypes() do
        local name, _, active, _ = GetTrackingInfo(i)
        active = (active or false)

        --if category ~= "other" and active then
        --	msg("Tracking-type " .. name .. " is a spell/ability and must be manually used to track it.", true)
        --elseif not mainTracking[name] then
        if mainTracking[name] == nil then
            --msg(name .. " isn't tracked account wide so we won't change it. Maybe you want to run a sparse save to add it?", INFO_TRACKING_RESTORE_NOT_ACCOUNT_WIDE)
        elseif active ~= mainTracking[name] then
            --msg("Toggling " .. name .. " because you want it " .. (mainTracking[name] and "enabled." or "disabled."), INFO_TRACKING_RESTORE_CHANGES)
            SetTracking(i, (mainTracking[name] and true))
        end
    end

    return "Loaded"
end


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
	getInterfaceStatus = function(info)
        local s = options.args.save
        if profile.interfaceOptionsStorage[0] == true then
            s.confirm = true
            return true
        else
            s.confirm = false
            return false
        end
	end,

    saveInterfaceOptions = InterfaceOptionsStorage_Save,
    loadInterfaceOptions = function(info)
        local did = InterfaceOptionsStorage_Load()
        if did == "Loaded" then
            profile.interfaceOptionsStorage[0] = true
            C_UI.Reload()
        end
    end,

--[[ Tracking --]]
    getTrackingStatus = function(info)
        local s = options.args.saveTracking
        if profile.trackingStorage[0] == true then
            s.confirm = true
            return true
        else
            s.confirm = false
            return false
        end
	end,

    saveTracking = function(info)
        local did = TrackingStorage_Save()
        if did == "Saved" then
            profile.interfaceOptionsStorage[0] = true
        else
            Hiui:Print("Updating minimap tracking failed.")
        end
    end,

    saveTrackingSparse = function(info)
        local did = TrackingStorage_Save(true)
        if did == "Saved" then
            profile.interfaceOptionsStorage[0] = true
        else
            Hiui:Print("Sparse minimap tracking update failed.")
        end
    end,

    loadTracking = function(info)
        -- verify structure, then run:
        local did = TrackingStorage_Load()
        if did == "Loaded" then
            profile.trackingStorage[0] = true
        end
    end,

    automaticTrack = function(info, val)
        profile.autotrack = val
        return val
    end,

}

--[[    GUI Options Menu
    Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
    The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
]]
local options = {
    name = name .. " Options",
    type = "group",
    args = {
        disabledWarning = {
            order = 1,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        enable = {
            order = 0,
            name = "Enable " .. name,
            desc = "Check to enable this module.",
			width = "full",
            type = "toggle",
            set = function(info, value)
                profile.enabled = value
                if value then
                    mod:Enable()
                else
                    mod:Disable()
                end
            end,
            get = function(info)
                return profile.enabled
            end,
        },
        header = {
            order = 2,
            name = "Interface Options",
            type = "header",
            width = "half",
        },
        getInterfaceStatus = {
            order = 99,
            name = "",
            hidden = true,
            type = "toggle",
            get = features.getInterfaceStatus,
            set = function() return end,
        },
        save = {
            order = 3,
            name = "Save",
            desc = "Save this characters interface options for use by your other characters. This will reload your UI.",
            confirmText = "You have interface options already saved for loading on other characters. This will overwrite that data and reload your UI.",
            type = "execute",
            confirm = true,
            func = features.saveInterfaceOptions,
        },
        load = {
            order = 4,
            name = "Load",
            desc = "Loading interface options saved by this addon will overwrite this character's current interface options settings and reload the UI.",
            type = "execute",
            confirm = true,
            func = features.loadInterfaceOptions,
        },
        trackingHeader = {
            order = 5,
            name = "Tracking",
            type = "header",
            width = "half",
        },
        getTrackingStatus = {
            order = 98,
            name = "",
            hidden = true,
            type = "toggle",
            get = features.getTrackingStatus,
            set = function() return end,
        },
        saveTracking = {
            order = 6,
            name = "Store",
            desc = "Save this characters minimap tracking for quickly loading on other characters",
            confirmText = "You have tracking from another character already saved. This will overwrite that data and reload your UI. If you only meant to add new tracking (like track beasts or find treature) use 'Save only new tracking'.",
            type = "execute",
            confirm = true,
            func = features.saveTracking,
        },
        sparse = {
            order = 7,
            name = "Sparse Store",
            desc = "Add unique tracking to the saved pool. Previously saved tracking settings won't be overwritten. Useful for adding hunter/druid and treasure tracking without completely overwriting.",
            type = "execute",
            func = features.saveTrackingSparse,
        },
        loadTracking = {
            order = 8,
            name = "Load",
            desc = "Overwrite your current tracking with the saved one",
            type = "execute",
            func = features.loadTracking,
        },
        automaticLoad = {
            order = 9,
            name = "Automatically load saved minimap tracking at each login",
            width = "full",
            type = "toggle",
            set = features.automaticTrack,
            get = function(info) return profile.autotrack end,
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
    db = Hiui.db
    db.profile.modules[name] = db.profile.modules[name] or {}
    db.char.modules[name] = db.char.modules[name] or {}
    global = db.global.modules[name]
    profile = db.profile.modules[name]
    char = db.char.modules[name]

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ Module specific on-load routines go here. --]]
    ios = profile.interfaceOptionsStorage
    mainTracking = profile.trackingStorage
    --you = UnitName("player") -- unused
end

function mod:OnEnable()
    Hiui:Print(name .. " enabled.")
    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]
    --[[if char.initialized < mod.version then
		for _, feature in pairs(features) do
			feature()
		end
		char.initialized = mod.version
	end --]]

    --[[ Module specific on-run routines go here. --]]
    if profile.autoload then
        features.loadTrackingOptions()
    end
end

function mod:OnDisable()
    Hiui:Print(name .. " disabled.")
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
