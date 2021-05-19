--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
--local Hiui = Hiui
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Chat Frame Mods", 0.1
local mod = Hiui:NewModule(name, "AceEvent-3.0")
mod.modName, mod.version = name, version

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global.modules[name]
    mod.db.profile.modules[name]
    mod.db.char.modules[name]
]]
local db, global, profile, char


local uiWidth = UIParent:GetWidth()
local MCF = _G["ChatFrame1"]

function mod:PLAYER_REGEN_DISABLED()
    if profile.shrink_chat_during_combat then
        MCF:SetWidth(profile.width.ic)
        MCF.timeVisibleSecs = 10
    end
end

function mod:PLAYER_REGEN_ENABLED()
    if profile.shrink_chat_during_combat then
        MCF:SetWidth(profile.width.ooc)
        MCF.timeVisibleSecs = 120
    end
end


--[[    Default Values
    In each module, you can begin editing defaults for this module by using defaults.global|profile|char
    You should include at least the following:
    mod.defaults.global.debug = false
    mod.defaults.profile.enabled = false
    mod.defaults.char.initialized = false
--]]
local defaults = {
    global = {
        debug = true, -- noisy debugging information.
    },
    profile = {
        enabled = false,
        width = {
            ooc = uiWidth/4, -- magic number
            ic = uiWidth*10/54.352, -- magic number
        },
        --height = UIParent:GetHeight()*10/36, -- mostly irrelevant.
        bottomOffset = 32, -- magic number, make user config
        leftOffset = 32, -- magic number, make user config
        corner_chat_every_login = false,
        shrink_chat_during_combat = true,
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
	sample_function = function(info)
        char.sample_function_run = true
        return
	end,
    sample_func_two = function(info, value)
        if value then -- running as "set"
            char.sample_func_two_run = value
        else -- running as "get"
            return char.sample_func_two_run
        end
    end,
    hide_chat_bg = function(_)
        SetChatWindowColor(1, 0, 0, 0)
		SetChatWindowAlpha(1, 0)
    end,
    corner_chat = function(_)
        MCF:StartMoving()
        MCF:ClearAllPoints()
        MCF:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", profile.leftOffset, profile.bottomOffset)
        MCF:SetWidth(profile.width.ooc)
        MCF:StopMovingOrSizing()
        if global.debug then
            local bitt, target, anchor, left, bot = MCF:GetPoint(1)
            if (not (left or bot)) or (left > (profile.leftOffset + 0.1) or left < (profile.leftOffset - 0.1)) or (bot > (profile.bottomOffset + 0.1) or bot < (profile.bottomOffset - 0.1)) then
                Hiui:Print("Debug message. Chat frame not cornered. It probably should be!")
                Hiui:Print("Debug: " .. (bitt or "No point") .. " to " .. (target and target:GetName() or "no frame") .. " " .. (anchor or "no anchor"))
            end
        end
    end,
    toggle_chat_slimming = function(_, val)
        if val ~= nil then 
            profile.shrink_chat_during_combat = val
        end

        if profile.shrink_chat_during_combat then
        else
        end
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
        disabledWarning = {
            order = 1,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        corner_chat = {
            order = 2,
			name = "Move Chat To Corner",
            descStyle = "hidden",
			type = "execute",
			func = features.corner_chat,
		},
        always_corner_chat = {
            order = 3,
            name = "Corner Chat Every Login",
            desc = "Reposition chat window in the corner at every single login. Useful if you move the chat around a lot.",
            type = "toggle",
            set = function(_, val) profile.corner_chat_every_login = val or false end,
            get = function(_) return profile.corner_chat_every_login end,
        },
        small_chat = {
            order = 4,
            name = "Shrink Chat During Combat",
            desc = "Compress the width of the chatframe during combat to keep your screen clean.",
            type = "toggle",
            set = function(_, val)
                profile.shrink_chat_during_combat = val or false
                if not val then
                    MCF:SetWidth(profile.width.ooc)
                end
            end,
            get = function() return profile.shrink_chat_during_combat end,
        },
        header = {
            name = "Profile Settings",
            type = "header",
            width = "half",
            order = 4,
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
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")

    if profile.corner_chat_every_login then
        features.corner_chat()
    end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end
