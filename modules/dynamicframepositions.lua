--[[    Header
In this opening block, only the name of the addon, version, info and dependencies needs to be changed.
Dependencies are mod names that you require to be enabled for this mod to load. You should use the folder name exactly.
Module information will be displayed on the main hiui page.
The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Frame Positions", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
mod.modName, mod.version = name, version
mod.info = "Module information."
mod.depends = {}

--[[ Imports --]]
local DurabilityFrame = _G["DurabilityFrame"]
local VehicleSeatIndicator = _G["VehicleSeatIndicator"]
local UIWidgetBelowMinimapContainerFrame = _G["UIWidgetBelowMinimapContainerFrame"]
local UIWidgetTopCenterContainerFrame = _G["UIWidgetTopCenterContainerFrame"]

local MoveAnythingData = {
    ["UIWidgetBelowMinimapContainerFrame"] = {
        ["orgPos"] = {
            "TOPRIGHT", -- [1]
            "MinimapCluster", -- [2]
            "BOTTOMRIGHT", -- [3]
            0, -- [4]
            0, -- [5]
        },
        ["pos"] = {
            "BOTTOM", -- [1]
            "Minimap", -- [2]
            "TOP", -- [3]
            0, -- [4]
            6, -- [5]
        },
    },
    ["UIWidgetTopCenterContainerFrame"] = {
        ["orgPos"] = {
            "TOP", -- [1]
            "UIParent", -- [2]
            "TOP", -- [3]
            0, -- [4]
            -15, -- [5]
        },
        ["pos"] = {
            "BOTTOM", -- [1]
            "UIWidgetBelowMinimapContainerFrame", -- [2]
            "TOP", -- [3]
            0, -- [4]
            0, -- [5]
        },
    },

    ["VehicleSeatIndicator"] = {
        ["orgPos"] = {
            "TOPRIGHT", -- [1]
            "MinimapCluster", -- [2]
            "BOTTOMRIGHT", -- [3]
            40, -- [4]
            15, -- [5]
        },
        ["pos"] = {
            "BOTTOMRIGHT", -- [1]
            "Minimap", -- [2]
            "BOTTOMLEFT", -- [3]
            -15, -- [4]
            0, -- [5]
        },
    },
    ["DurabilityFrame"] = {
        ["orgPos"] = {
            "TOPRIGHT", -- [1]
            "MinimapCluster", -- [2]
            "BOTTOMRIGHT", -- [3]
            -82.00003051757812, -- [4]
            0, -- [5]
        },
        --["disableLayerHighlight"] = false,
        --["disableLayerOverlay"] = false,
        ["pos"] = {
            "BOTTOMRIGHT", -- [1]
            "Minimap", -- [2]
            "BOTTOMLEFT", -- [3]
            -50, -- [4]
            0, -- [5]
        },
    },
}

--[[    Database Access
Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
mod.db.global, mod.db.profile, mod.db.char
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
        debug = false, -- noisy debugging
    },
    profile = {
        enabled = false, -- have root addon enable?
        run_each_login = true,
        frames = {
        },
    },
    char = {
        -- initialized = 0, -- used for first time load
    },
}

function mod:DurabilityFrame_SetPoint(...)
    local p = MoveAnythingData["DurabilityFrame"].pos

    DurabilityFrame:ClearAllPoints()
    if p and not DurabilityFrame.isMoving then
        if global.debug then mod:Print("Running hooked DurabilityFrame_SetPoint.") end
		self.hooks[DurabilityFrame]["SetPoint"](DurabilityFrame, p[1], p[2], p[3], p[4], p[5])
	else
        if global.debug then mod:Print("Running original DurabilityFrame_SetPoint.") end
		self.hooks[DurabilityFrame]["SetPoint"](...)
	end
end

function mod:VehicleSeatIndicator_SetPoint(...)
    local p = MoveAnythingData["VehicleSeatIndicator"].pos

    VehicleSeatIndicator:ClearAllPoints()
    if p and not VehicleSeatIndicator.isMoving then
        if global.debug then mod:Print("Running hooked VehicleSeatIndicator_SetPoint.") end
		self.hooks[VehicleSeatIndicator]["SetPoint"](VehicleSeatIndicator, p[1], p[2], p[3], p[4], p[5])
	else
        if global.debug then mod:Print("Running original VehicleSeatIndicator_SetPoint.") end
		self.hooks[VehicleSeatIndicator]["SetPoint"](...)
	end
end

function mod:UIWidgetBelowMinimapContainerFrame_SetPoint(...)
    local p = MoveAnythingData["UIWidgetBelowMinimapContainerFrame"].pos

    UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
    if p and not UIWidgetBelowMinimapContainerFrame.isMoving then
        if global.debug then mod:Print("Running hooked UIWidgetBelowMinimapContainerFrame_SetPoint.") end
		self.hooks[UIWidgetBelowMinimapContainerFrame]["SetPoint"](UIWidgetBelowMinimapContainerFrame, p[1], p[2], p[3], p[4], p[5])
	else
        if global.debug then mod:Print("Running original UIWidgetBelowMinimapContainerFrame_SetPoint.") end
		self.hooks[UIWidgetBelowMinimapContainerFrame]["SetPoint"](...)
	end
end

function mod:UIWidgetTopCenterContainerFrame_SetPoint(...)
    local p = MoveAnythingData["UIWidgetTopCenterContainerFrame"].pos

    UIWidgetTopCenterContainerFrame:ClearAllPoints()
    if p and not UIWidgetTopCenterContainerFrame.isMoving then
        if global.debug then mod:Print("Running hooked UIWidgetTopCenterContainerFrame_SetPoint.") end
		self.hooks[UIWidgetTopCenterContainerFrame]["SetPoint"](UIWidgetTopCenterContainerFrame, p[1], p[2], p[3], p[4], p[5])
	else
        if global.debug then mod:Print("Running original UIWidgetTopCenterContainerFrame_SetPoint.") end
		self.hooks[UIWidgetTopCenterContainerFrame]["SetPoint"](...)
	end
end

local function frameAlreadyPositioned(f)
    local mad = MoveAnythingData
    if mad[f] then
        if global.debug then mod:Print("Checking frame positions for " .. f .. ".") end
        local n = _G[f]:GetNumPoints()
        while n > 0 do
            local a = { _G[f]:GetPoint(n) }
            a[4], a[5] = a[4] or 0, a[5] or 0
            local matchedOrigPos = false

            for i=1, 5 do
                if not mad[f].orgPos[i] == a[i] then
                    break
                end
                matchedOrigPos = true -- only runs if all 5 points didn't break
            end

            if matchedOrigPos then
                if global.debug then
                    mod:Print("Matched original position on " .. _G[f]:GetName() .. ".")
                    mod:Print(_G[f]:GetPoint(n)) end
                return false
            end

            n = n - 1
        end -- original position matching. change this to absPos matching?
    end
end

local function moveFrame(f)
    local p = MoveAnythingData[f] and MoveAnythingData[f].pos
    if p then
        if f == "UIWidgetTopCenterContainerFrame" then
            _G[f].isMoving = true
            -- Heuristically don't accept static position, since it's docked to a non-static frame.
            _G[f]:SetPoint(p[1], p[2], p[3], p[4], p[5])
            _G[f].isMoving = false
        else
            local m = _G[f]:IsMovable()
            if not m then _G[f]:SetMovable(true) end

            if global.debug then mod:Print("Moving frame " .. f .. ".") end
            _G[f]:StartMoving()
            _G[f].isMoving = true

            _G[f]:ClearAllPoints()
            _G[f]:SetPoint(p[1], p[2], p[3], p[4], p[5])

            _G[f].isMoving = false
            _G[f]:StopMovingOrSizing()

            if not m then _G[f]:SetMovable(false) end
        end

        C_Timer.After(0.07, function() -- save position - currently unused, but helpful for debug
            if global.debug then
                mod:Print("Moved " .. _G[f]:GetName() .. " to:")
                mod:Print(_G[f]:GetPoint(1))
            end
            profile.frames[f] = profile.frames[f] or {}
            profile.frames[f].absPos = { _G[f]:GetPoint(1) }
            profile.frames[f].absPos[2] = _G[f]:GetName() or nil
            profile.frames[f].absPos[4] = profile.frames[f].absPos[4] or 0
            profile.frames[f].absPos[5] = profile.frames[f].absPos[5] or 0
        end)
    end
end

--[[    "Features" local variable
Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
Remember to set/change db values during these functions.
--]]
local features = {
    position_all = function()
        for k,_ in pairs(MoveAnythingData) do
            if not frameAlreadyPositioned(k) then
                moveFrame(k)
            end
        end
    end,
    run_each_login = function(force_debug)
        if global.debug then mod:Print("Running logon routing.") end

        local debug = false
        if force_debug then
            debug = global.debug
            global.debug = true
        end

        for k,_ in pairs(MoveAnythingData) do
            moveFrame(k)
        end

        if force_debug then
            global.debug = debug
        end
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
        position_all = {
			name = "Position All Frames",
			type = "execute",
			confirm = true,
			func = features.position_all,
		},
        run_each_login = {
            name = "Move frames every login.",
            desc = "You should leave this enabled unless you're sure it works without.",
            type = "toggle",
            set = function(_, value) profile.run_each_login = value end,
            get = function() return profile.run_each_login end,
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

    --[[ Module specific on-run routines go here. --]]
    if MoveAnythingData["DurabilityFrame"] then
    	self:RawHook(DurabilityFrame, "SetPoint", "DurabilityFrame_SetPoint", true)
	    --self:RawHook(DurabilityFrame, "IsShown", "DurabilityFrame_IsShown", true)
    end

    if MoveAnythingData["VehicleSeatIndicator"] then
        self:RawHook(VehicleSeatIndicator, "SetPoint", "VehicleSeatIndicator_SetPoint", true)
    end

    if MoveAnythingData["UIWidgetBelowMinimapContainerFrame"] then
        self:RawHook(UIWidgetBelowMinimapContainerFrame, "SetPoint", "UIWidgetBelowMinimapContainerFrame_SetPoint", true)
    end

    if MoveAnythingData["UIWidgetTopCenterContainerFrame"] then
        self:RawHook(UIWidgetTopCenterContainerFrame, "SetPoint", "UIWidgetTopCenterContainerFrame_SetPoint", true)
    end

    if profile.run_each_login then
        features.run_each_login(false) -- force move
        --features.run_each_login()
    else
        features.position_all() -- clean move
        --features.run_each_login()
    end

    -- Sadly this works
    do
        local p = MoveAnythingData.UIWidgetBelowMinimapContainerFrame.pos
        UIWidgetBelowMinimapContainerFrame:SetPoint(p[1], p[2], p[3], p[4], p[5])
    end

    -- Fake Shit:
    -- if _G["SLASH_Leatrix_Plus1"] then
    --     C_Timer.After(0.1, function()
            
    --     end)
    -- end

    --[[ TODO: Custom position for Inerva Darkvein,
    as well as jailer attention bar. --]]
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
