--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Viewport", 0.1
local mod = Hiui:NewModule(name, "AceEvent-3.0")
mod.modName, mod.version = name, version

local UIParent = _G["UIParent"]
local WorldFrame = _G["WorldFrame"]
local uiScale = 768 / UIParent:GetHeight()
local seenWFerror = false
local seenICLerror = false

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    Hiui.db.global.modules[name]
    Hiui.db.profile.modules[name]
    Hiui.db.char.modules[name]
]]
local db, global, profile, char

--[[    Default Values
    In each module, you can begin editing defaults for this module by using defaults.global|profile|char.modules.MyModule
    Variables set in init.lua default table don't need to be set unless you want them set differently. They are:
    Hiui.defaults.global.modules[name].debug = false
    Hiui.defaults.profile.modules[name].enabled = false
    Hiui.defaults.char.modules[name].initialized = false
--]]
local defaults = {
    global = {
        debug = true, -- noisy debugging information.
    },
    profile = {
        enabled = true,
        top_inset = 0, -- unused
        bottom_inset = 20,
        left_inset = 0, --unused
        right_inset = 0,
    },
    char = {
        initialized = 0, -- used for first time load
    },
}

local function wfResize(top, left, bottom, right)
    -- pass nil for any arguments you don't want overwritten
    local t, l = top or profile.top_inset or 0, left or profile.left_inset or 0
    local r, b = right or profile.right_inset or 0, bottom or profile.bottom_inset or 0
    -- Offsets relative to UIParent (which is your screen, I guess)
    WorldFrame:ClearAllPoints()
    WorldFrame:SetPoint("TOPLEFT", l or 0, -t or 0)
    WorldFrame:SetPoint("BOTTOMRIGHT", -r or 0, b or 0)
    WorldFrame:SetUserPlaced(true)
    --Hiui:Print("Frame resized.")
end

--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {}
features.apply_viewport = function(event, ...)
    if global.debug then
        Hiui:Print("Event:", event, "Bot inset:", profile.bottom_inset)
    end
    if not WorldFrame or GetScreenWidth() < 1 then
        if not seenWFerror then
            Hiui:Print("Skipping viewport change because addon loaded before WorldFrame. This is an unusual error!")
            seenWFerror = true
        end
        return C_Timer.After(1, features.apply_viewport)
    end

    local uiw = UIParent:GetWidth() * uiScale
    local uih = UIParent:GetHeight() * uiScale
    local wfwEsti = WorldFrame:GetWidth() + profile.left_inset + profile.right_inset
    local wfhEsti = WorldFrame:GetHeight() + profile.top_inset + profile.bottom_inset
    if uiw - wfwEsti > 1 then
        if InCombatLockdown() then
            if not seenICLerror then
                Hiui:Print("In combat during WorldFrame resize, will try later.")
                seenICLerror = true
            end
            return C_Timer.After(1, features.apply_viewport)
        end
        if global.debug then
            Hiui:Print("Resizing viewport because width bad.")
        end
        wfResize()
        seenWFerror, seenICLerror = false, false
        return C_Timer.After(2, features.apply_viewport)
    elseif uih - wfhEsti > 1 then
        if InCombatLockdown() then
            if not seenICLerror then
                Hiui:Print("In combat during WorldFrame resize, will try later.")
                seenICLerror = true
            end
            return C_Timer.After(1, features.apply_viewport)
        end
        if global.debug then
            Hiui:Print("Resizing viewport because height bad.")
        end
        wfResize()
        return C_Timer.After(2, features.apply_viewport)
    elseif global.debug then
        Hiui:Print("Skipping WorldFrame resize because it should be fine already.")
    end
end

--[[    GUI Options Menu
    Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
    The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
]]
local options = {
    name = name .. " Options",
    type = "group",
    args = {
        enable = {
            order = 0,
            name = "Enable " .. name,
            desc = "Check to enable this module.",
            type = "toggle",
            set = function(info, value)
                profile.enabled = value
                if value then
                    mod:Enable()
                else
                    mod:Disable()
                end
            end,
            get = function(info) return profile.enabled end,
        },
        debug = {
            order = 1,
            name = "Noisy debugging",
            desc = "Print lots of text to the chatbox.",
            type = "toggle",
            set = function(_, value) global.debug = value end,
            get = function() return global.debug end,
        },
        emptyHeader = {
            order = 2,
            name = "",
            type = "description",
            width = "full",
        },
        disabledWarning = {
            order = 2,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        top_inset = {
            order = 3,
            name = "Top Inset",
            desc = "World distance from top of screen.",
            type = "input",
            width = "half",
            validate = function(info, data)
                if global.debug then
                    Hiui:Print(info, data)
                end
                local e
                data = tonumber(data*uiScale)
                if not data then
                    e = "You must enter a number."
                elseif data == "" then
                    e = "You must enter something."
                elseif data < 0 then
                    e = "Can't be less than zero!"
                elseif data > GetScreenHeight()*uiScale/2 then
                    e =  "Won't accept more than half of screen height."
                end
                info.option.get()
                if e then
                    return e
                else
                    return data
                end
            end,
            set = function(_, value)
                profile.top_inset = tonumber(value)
                wfResize()
                features.apply_viewport()
            end,
            get = function() return tostring(profile.top_inset) end,
        },
        bottom_inset = {
            order = 3,
            name = "Bottom Inset",
            desc = "World distance from bottom of screen.",
            type = "input",
            width = "half",
            validate = function(info, data)
                if global.debug then
                    Hiui:Print(info, data)
                end
                local e
                data = tonumber(data*uiScale)
                if not data then
                    e = "You must enter a number."
                elseif data == "" then
                    e = "You must enter something."
                elseif data < 0 then
                    e = "Can't be less than zero!"
                elseif data > GetScreenHeight()*uiScale/2 then
                    e =  "Won't accept more than half of screen height."
                end
                info.option.get()
                if e then
                    return e
                else
                    return data
                end
            end,
            set = function(_, value)
                profile.bottom_inset = tonumber(value)
                wfResize()
                features.apply_viewport()
            end,
            get = function() return tostring(profile.bottom_inset) end,
        },
        left_inset = {
            order = 3,
            name = "Left Inset",
            desc = "World distance from left side of screen.",
            type = "input",
            width = "half",
            validate = function(info, data)
                if global.debug then
                    Hiui:Print(info, data)
                end
                local e
                data = tonumber(data*uiScale)
                if not data then
                    e = "You must enter a number."
                elseif data == "" then
                    e = "You must enter something."
                elseif data < 0 then
                    e = "Can't be less than zero!"
                elseif data > GetScreenWidth()*uiScale/2 then
                    e =  "Won't accept more than half of screen width."
                end
                info.option.get()
                if e then
                    return e
                else
                    return data
                end
            end,
            set = function(_, value)
                profile.left_inset = tonumber(value)
                wfResize()
                features.apply_viewport()
            end,
            get = function() return tostring(profile.left_inset) end,
        },
        right_inset = {
            order = 3,
            name = "Right Inset",
            desc = "World distance from right side of screen.",
            type = "input",
            width = "half",
            validate = function(info, data)
                if global.debug then
                    Hiui:Print(info, data)
                end
                local e
                data = tonumber(data*uiScale)
                if not data then
                    e = "You must enter a number."
                elseif data == "" then
                    e = "You must enter something."
                elseif data < 0 then
                    e = "Can't be less than zero!"
                elseif data > GetScreenWidth()*uiScale/2 then
                    e =  "Won't accept more than half of screen width."
                end
                info.option.get()
                if e then
                    return e
                else
                    return data
                end
            end,
            set = function(_, value)
                profile.right_inset = tonumber(value)
                wfResize()
                features.apply_viewport()
            end,
            get = function() return tostring(profile.right_inset) end,
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
    db = self.db
    global = db.global
    profile = db.profile
    char = db.char

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ Module specific on-load routines go here. --]]
end

function mod:OnEnable()
    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]
	if char.initialized < mod.version then
		for _, feature in pairs(features) do
			feature()
		end
		char.initialized = mod.version
	end

    --[[ Module specific on-run routines go here. --]]
    mod:RegisterEvent("PLAYER_ENTERING_WORLD", features.apply_viewport)
    mod:RegisterEvent("CINEMATIC_STOP", features.apply_viewport)
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
    mod:UnregisterEvent("CINEMATIC_STOP")
end
