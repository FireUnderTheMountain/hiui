--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "BagSync", 0.1
local mod = Hiui:NewModule(name)
mod.modName, mod.version = name, version

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global.modules[name]
    mod.db.profile.modules[name]
    mod.db.char.modules[name]
--]]
local db, global, profile, char

--[[    Default Values
    In each module, you can begin editing defaults for this module by using defaults.global|profile|char
    You should include at least the following:
    mod.defaults.global.debug = false
    mod.defaults.profile.enabled = false
    mod.defaults.char.initialized = false
--]]
local defaults = {
    global = {
        debug = false, -- noisy debugging information.
    },
    profile = {
        enabled = false,
        opie_snapshot_string = "oetohH7 lFOYRRY 30qg01t 1o4w0Ql abel06B lacklis t0y07AC ECONSOL E18BGS0 70Dbgs0 6blackl ist91y4 30q4SDe 1o4w0Ql abel06P rofessi ons0y07 ACECONS OLE18BG S070Dbg s06prof essions 91y430q 4Dbt1o4 w0Qlabe l06Curr ency0y0 7ACECON SOLE18B GS070Db gs06cur rency91 y430q4S BL1o4w0 Qlabel0 6Gold0y 07ACECO NSOLE18 BGS070D bgs06go ld91y43 0q4D4U1 o4w0Qla bel06Se arch0y0 7ACECON SOLE18B GS070Db gs06sea rch91y4 3qq4it2 1q4wBag s9134.",
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
    hide_minimap_button = function()
        _G["BagSync_MinimapButton"]:Hide()
    end
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
            set = function(_, value)
                profile.enabled = value
                if value then
                    mod:Enable()
                else
                    mod:Disable()
                end
            end,
            get = function(_)
                return profile.enabled
            end,
        },
        disabledWarning = {
            order = 1,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        opie_string = {
			name = "\"BagSync\" oPie Import String",
			desc = "Paste this string into oPie and bind a key to it for full BagSync functionality. Interface -> AddOns -> oPie -> Custom Rings -> New Ring -> Import Snapshot",
            width = "full",
			type = "input",
            multiline = 5,
            set = function(info, value)
                info.option.get()
            end,
            get = function(_)
                return profile.opie_snapshot_string
            end,
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
    features.hide_minimap_button()
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
