--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Quest Log", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version

local otf = _G["ObjectiveTrackerFrame"]
--local Minimap = _G["Minimap"]
local STANDARD_TEXT_FONT = _G["STANDARD_TEXT_FONT"]
local heightNormal, heightCollapsed = 521, 25
local moving

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
        position_quest_tracker_on_login = true,
        skin_quest_frame = true,
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
    position_quest_tracker = function()
        hooksecurefunc(otf, "SetPoint", function(self)
            if moving then return end
            moving = true
            self:SetMovable(true)
            self:SetUserPlaced(true)
            self:ClearAllPoints()
            --self:SetPoint("TOPLEFT", questWrapper)
            --self:SetPoint("TOPRIGHT", questWrapper)
            --self:SetParent(questWrapper)
            --self:SetPoint('TOPRIGHT', UIParent, -45, -200)
            --self:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", -40, 8)
            --self:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 40, 8)
            self:SetPoint("BOTTOM", UIParent, "BOTTOMRIGHT", -140, 255)
            --[[ This sets otfBlocksFrame.QuestHeader left and right to 1456.66 and 1691.66
                while minimap left and right is 1466.66 and 1666.66 --]]

            --self:SetPoint("TOP", UIParent, "BOTTOMRIGHT", -140, 255+heightNormal)
            self:SetHeight(heightNormal)
            self:SetMovable(false)
            moving = nil

            mod:Print("Quest frame position update.")
        end)

        -- otf.HeaderMenu.MinimizeButton:HookScript("OnClick", function()
        --     mod:Print("Minimize clicked.")
        --     if otf:GetHeight() > heightCollapsed+1 then
        --         --otf:SetPoint("TOP", UIParent, "BOTTOMRIGHT", -140, 255+heightCollapsed)
        --         otf:SetHeight(heightCollapsed)
        --     else
        --         --otf:SetPoint("TOP", UIParent, "BOTTOMRIGHT", -140, 255+heightNormal)
        --         otf:SetHeight(heightNormal)
        --     end
        -- end)
    end,
    skin_quest_frame = function()
        local btnMinimize = otf.HeaderMenu.MinimizeButton
        btnMinimize:SetSize(15, 15)
        btnMinimize:ClearAllPoints()
        btnMinimize:SetPoint('TOPRIGHT', otf, 0, -4)
        btnMinimize:SetNormalTexture('')
        btnMinimize:SetPushedTexture('')

        btnMinimize.minus = btnMinimize:CreateFontString(nil, 'OVERLAY')
        btnMinimize.minus:SetFont(STANDARD_TEXT_FONT, 15)
        btnMinimize.minus:SetText('>')
        --btnMinimize.minus:SetText' '
        btnMinimize.minus:SetPoint('CENTER')
        btnMinimize.minus:SetTextColor(1, 1, 1)
        btnMinimize.minus:SetShadowOffset(1, -1)
        btnMinimize.minus:SetShadowColor(0, 0, 0, 1)

        btnMinimize.plus = btnMinimize:CreateFontString(nil, 'OVERLAY')
        btnMinimize.plus:SetFont(STANDARD_TEXT_FONT, 15)
        btnMinimize.plus:SetText('<')
        --btnMinimize.plus:SetText' '
        btnMinimize.plus:SetPoint('CENTER')
        btnMinimize.plus:SetTextColor(1, 1, 1)
        btnMinimize.plus:SetShadowOffset(1, -1)
        btnMinimize.plus:SetShadowColor(0, 0, 0, 1)
        btnMinimize.plus:Hide()

        btnMinimize:HookScript('OnEnter', function() btnMinimize.minus:SetTextColor(.7, .5, 0) btnMinimize.plus:SetTextColor(.7, .5, 0) end)
        btnMinimize:HookScript('OnLeave', function() btnMinimize.minus:SetTextColor(1, 1, 1) btnMinimize.plus:SetTextColor(1, 1, 1) end)

        hooksecurefunc('ObjectiveTracker_Collapse', function() btnMinimize.plus:Show() btnMinimize.minus:Hide() end)
        hooksecurefunc('ObjectiveTracker_Expand',   function() btnMinimize.plus:Hide() btnMinimize.minus:Show() end)

        -- local title = otf.HeaderMenu.Title
        -- title:SetFont([[Fonts\skurri.ttf]], 13)
        -- title:ClearAllPoints()
        -- title:SetPoint('RIGHT', btnMinimize, 'LEFT', -8, 0)


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
        position_quest_tracker_on_login = {
            order = 3,
            name = "Custom Quest Tracker Position",
            desc = "Quest tracker is controlled by blizzard Ui, so may want to leave this checked.",
            width = "double",
            type = "toggle",
            set = function(_, val) profile.position_quest_tracker_on_login = val or false end,
            get = function(_) return profile.position_quest_tracker_on_login end,
        },
        skin_quest_frame = {
            order = 3,
            name = "Skin the quest frame",
            desc = "Use cool Hiui skinning based on Quest Tracker for Modernists! (Requires reload)",
            type = "toggle",
            set = function(_, val) profile.skin_quest_frame = val or false end,
            get = function(_) return profile.skin_quest_frame end,
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
	-- if char.initialized < mod.version then
	-- 	for _, feature in pairs(features) do
	-- 		feature()
	-- 	end
	-- 	char.initialized = mod.version
	-- end

    --[[ Module specific on-run routines go here. --]]
    if profile.position_quest_tracker_on_login then features.position_quest_tracker() end
    if profile.skin_quest_frame then features.skin_quest_frame() end

    -- Hook otf.HeaderMenu.MinimizeButton to collapse height.
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
