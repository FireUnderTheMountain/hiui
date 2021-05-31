--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
--local Hiui = Hiui
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Chat Frame", 0.5
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version

--[[ Imports --]]
local ChatFrame1 = _G["ChatFrame1"]
local ChatFrame1Tab = _G["ChatFrame1Tab"]
local ChatFrame1Background = _G["ChatFrame1Background"]
local ChatFrame1ButtonFrame = _G["ChatFrame1ButtonFrame"]
local QuickJoinToastButton = _G["QuickJoinToastButton"]
local BNToastFrame = _G["BNToastFrame"]
local ChatFrameChannelButton = _G["ChatFrameChannelButton"]
local ChatFrameToggleVoiceDeafenButton = _G["ChatFrameToggleVoiceDeafenButton"]
local ChatFrameToggleVoiceMuteButton = _G["ChatFrameToggleVoiceMuteButton"]
local ChatFrameMenuButton = _G["ChatFrameMenuButton"]

local uiWidth = UIParent:GetWidth()

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global.modules[name]
    mod.db.profile.modules[name]
    mod.db.char.modules[name]
--]]
local global, profile, char

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
            ooc = uiWidth*35/100, -- magic number
            ic = uiWidth*23/100, -- magic number
        },
        bottomOffset = 2, -- magic number, make user config
        leftOffset = 2, -- magic number, make user config
        corner_chat_every_login = false,
        size_chat_for_combat = true,
        hide_chat_buttons = true,
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
    hide_chat_bg = function()
        if global.debug then
            SetChatWindowColor(1, 0, 100, 0)
            SetChatWindowAlpha(1, 128)
        else
            SetChatWindowColor(1, 0, 0, 0)
            SetChatWindowAlpha(1, 0)
        end
    end,

    corner_chat = function()
        --[[ Pre-move debugging --]]
        if global.debug then
            local _, _, _, left, bot = ChatFrame1:GetPoint(1)
            if (not (left or bot)) or
              left > (profile.leftOffset + 0.1) or
              left < (profile.leftOffset - 0.1) or
              bot > (39.5 + 0.1) or
              bot < (39.5 - 0.1) then
                mod:Print("Pre-move debug message. Chat frame not cornered. We will do that!")
                mod:Print(ChatFrame1:GetPoint(1))
              else
                mod:Print("Even before attempting to move it, the chat is positioned correctly.")
            end
        end

        --[[ ChatFrame1Background correction
        The background goes 6 px below the frame, interesting.
        -2 horizontal adjustment is the default blizzard ui.
        --]]
        ChatFrame1Background:SetPoint("BOTTOMLEFT", ChatFrame1, "BOTTOMLEFT", 0, -profile.bottomOffset)
        ChatFrame1Background:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 0, -profile.bottomOffset)

        if global.debug then
            hooksecurefunc(ChatFrame1Background, "SetPoint", function(self)
            mod:Print("Uh oh, ChatFrame1Background moved. Report this for hooking!")
            end)
        end


        --[[ Primary Chat Frame
        Offsets from WorldFrame may not be correct as WorldFrame isn't affected by UI scaling.
        --]]
        ChatFrame1:StartMoving()
        ChatFrame1:ClearAllPoints()
        --ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", profile.leftOffset, profile.bottomOffset)
        ChatFrame1:SetPoint("BOTTOMLEFT", _G["WorldFrame"], "BOTTOMLEFT", profile.leftOffset, profile.bottomOffset)
        ChatFrame1:SetWidth(profile.width.ooc)
        ChatFrame1:StopMovingOrSizing()

        ChatFrame1:SetPoint("BOTTOMLEFT", _G["WorldFrame"], "BOTTOMLEFT", profile.leftOffset, profile.bottomOffset)

        --[[ Post-move debugging --]]
        if global.debug then
            local _, _, _, left, bot = ChatFrame1:GetPoint(1)
            if (not (left or bot)) or
              left > (profile.leftOffset + 0.1) or
              left < (profile.leftOffset - 0.1) or
              bot > (profile.bottomOffset + 0.1) or
              bot < (profile.bottomOffset - 0.1) then
                mod:Print("Debug message. Chat frame not cornered. But it should be!")
                mod:Print(ChatFrame1:GetPoint(1))
              else
                mod:Print("Chat is positioned correctly.")
            end
        end
    end,

    size_chat_for_combat = function(combat)
        if combat == nil then
            combat = InCombatLockdown()
        end

        --[[ We don't want the chat to grow when quicly coming in and out of combat. So any time we enter combat,  --]]
        local safeToGrowChatSize = true

        if combat then
            ChatFrame1:SetWidth(profile.width.ic)
            ChatFrame1.timeVisibleSecs = 10

            safeToGrowChatSize = false
        else
            C_Timer.After(2, function()
                if not InCombatLockdown() then safeToGrowChatSize = true end
            end)

            C_Timer.After(3, function()
                if safeToGrowChatSize and not InCombatLockdown() then
                    ChatFrame1:SetWidth(profile.width.ooc)
                    ChatFrame1.timeVisibleSecs = 120
                end
            end)
        end
    end,

    hide_chat_buttons = function()
        local anchor, frame, bitt, offsetX, offsetY = "LEFT", UIParent, "BOTTOMLEFT", 15, 2

        --[[ Friends Button & Toast Frames
        Toast and Toast2 are distractions; use BNToastFrame to manipulate the toast.
        --]]
        local movin
        hooksecurefunc(QuickJoinToastButton, "SetPoint", function(self)
            if movin then return end
            movin = true
            self:ClearAllPoints()
            self:SetPoint("LEFT", ChatFrameMenuButton, "RIGHT")
            movin = false
        end)

        -- hooksecurefunc(QuickJoinToastButton, "OnEvent", function(self)
        --     if movin then return end
        --     movin = true
        --     self:ClearAllPoints()
        --     self:SetPoint("LEFT", ChatFrameMenuButton, "RIGHT")
        --     movin = false
        -- end)

        -- QuickJoinToastButton:HookScript("OnShow", function(self)
        --     if movin then return end
        --     movin = true
        --     self:ClearAllPoints()
        --     self:SetPoint("LEFT", ChatFrameMenuButton, "RIGHT")
        --     movin = false
        -- end)

        --[[ Hooking the mysterious BNToastFrame that doesn't seem to exist anymore and doesn't change anything --]]
        BNToastFrame:HookScript("OnEvent", function(self)
            self:ClearAllPoints();
            self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 1)
        end);

        QuickJoinToastButton:ClearAllPoints()
        QuickJoinToastButton:SetPoint("LEFT", ChatFrameMenuButton, "RIGHT")


        --[[ ChatFrame1ButtonFrame
        Orphan the children, keep them in order.
        --]]
        ChatFrameChannelButton:ClearAllPoints()
        ChatFrameChannelButton:SetPoint(anchor, frame, bitt, offsetY, offsetX)
        --ChatFrameChannelButton:SetSize(26,25)

        -- TODO: change once Enum implemented.
        ChatFrameToggleVoiceDeafenButton:ClearAllPoints()
        ChatFrameToggleVoiceDeafenButton:SetPoint("LEFT", ChatFrameChannelButton, "RIGHT")
        --ChatFrameToggleVoiceDeafenButton:SetSize(26,25)

        ChatFrameToggleVoiceMuteButton:ClearAllPoints()
        ChatFrameToggleVoiceMuteButton:SetPoint("LEFT", ChatFrameToggleVoiceDeafenButton, "RIGHT")
        --ChatFrameToggleVoiceMuteButton:SetSize(26,25)

        ChatFrameMenuButton:ClearAllPoints()
        ChatFrameMenuButton:SetPoint("LEFT", ChatFrameToggleVoiceMuteButton, "RIGHT")
        --ChatFrameMenuButton:SetSize(29,29)

        ChatFrame1ButtonFrame:ClearAllPoints()
        ChatFrame1ButtonFrame:Hide()
        ChatFrame1ButtonFrame:SetSize(0,0)
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
        header = {
            order = 4,
            name = "Settings",
            type = "header",
            width = "half",
        },
        corner_chat = {
            order = 5,
			name = "Move Chat To Corner",
			type = "execute",
			func = features.corner_chat,
		},
        corner_chat_every_login = {
            order = 6,
            name = "Corner Chat Every Login",
            desc = "Reposition chat window in the corner at every single login. Useful if you move the chat around a lot.",
            type = "toggle",
            set = function(_, val) profile.corner_chat_every_login = val or false end,
            get = function(_) return profile.corner_chat_every_login end,
        },
        size_chat_for_combat = {
            order = 7,
            name = "Shrink Chat During Combat",
            desc = "Compress the width of the chatframe during combat to keep your screen clean.",
            type = "toggle",
            set = function(_, val)
                profile.size_chat_for_combat = val or false
                features.size_chat_for_combat()
            end,
            get = function() return profile.size_chat_for_combat end,
        },
        hide_chat_buttons = {
            order = 8,
            name = "Move Chat Buttons",
            desc = "",
            type = "toggle",
            set = function(_, val)
                profile.hide_chat_buttons = val or false
                features.hide_chat_buttons()
            end,
            get = function() return profile.hide_chat_buttons end,
        },
        normal_chat_width = {
            order = 9,
            name = "Out-of-combat chat width",
            type = "input",
            width = "half",
            set = function(_, value)
                if global.debug then
                    mod:Print("New width attempt:", value)
                end

                local n
                value = tonumber(value)
                if not value or value == "" or value < 150 or value > GetScreenWidth()/2 then
                    mod:Print("Won't accept more than half of screen width, or less than 150.")
                    n = defaults.profile.width.ooc
                else
                    n = value
                end

                profile.width.ooc = n
                features.size_chat_for_combat(false)
            end,
            get = function() return tostring(profile.width.ooc) end,
        },
    },
}

function mod:PLAYER_REGEN_DISABLED()
    if profile.size_chat_for_combat then
        features.size_chat_for_combat(true)
    end
end

function mod:PLAYER_REGEN_ENABLED()
    if profile.size_chat_for_combat then
        features.size_chat_for_combat(false)
    end
end

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
    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]
	if char.initialized < mod.version then
		    features.corner_chat()
		char.initialized = mod.version
	end

    --[[ Module specific on-run routines go here. --]]
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")

    if profile.corner_chat_every_login then features.corner_chat() end
    if profile.hide_chat_buttons then features.hide_chat_buttons() end

    -- Chat frame menu button and undock toaste
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end
