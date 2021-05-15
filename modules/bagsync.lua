--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = Hiui
local name, version = "BagSync", 0.1
local mod = Hiui:NewModule(name)
mod.modName, mod.version = name, version

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    Hiui.db.global.modules[name]
    Hiui.db.profile.modules[name]
    Hiui.db.char.modules[name]
--]]
local db, global, profile, char

--[[    Default Values
    In each module, you can begin editing defaults for this module by using defaults.global|profile|char.modules.MyModule
    Variables set in init.lua default table don't need to be set unless you want them set differently. They are:
    Hiui.defaults.global.modules[name].debug = false
    Hiui.defaults.profile.modules[name].enabled = false
    Hiui.defaults.char.modules[name].initialized = false
--]]
local defaults = Hiui.defaults
defaults.global.modules[name] = {
    debug = false, -- noisy debugging information.
}
defaults.profile.modules[name] = {
    enabled = true,
    opie_snapshot_string = "oetohH7 lFOYRRY 30qg01t 1o4w0Ql abel06B lacklis t0y07AC ECONSOL E18BGS0 70Dbgs0 6blackl ist91y4 30q4SDe 1o4w0Ql abel06P rofessi ons0y07 ACECONS OLE18BG S070Dbg s06prof essions 91y430q 4Dbt1o4 w0Qlabe l06Curr ency0y0 7ACECON SOLE18B GS070Db gs06cur rency91 y430q4S BL1o4w0 Qlabel0 6Gold0y 07ACECO NSOLE18 BGS070D bgs06go ld91y43 0q4D4U1 o4w0Qla bel06Se arch0y0 7ACECON SOLE18B GS070Db gs06sea rch91y4 3qq4it2 1q4wBag s9134.",
}
defaults.char.modules[name] = {
    sample_function_run = false,
    sample_func_two_run = false,
}


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
    hide_minimap_button = function(_)
        _G["BagSync_MinimapButton"]:Hide()
    end
	-- sample_function = function(_)
    --     char.sample_function_run = true
    --     return
	-- end,
    -- sample_func_two = function(_, value)
    --     if value then -- running as "set"
    --         char.sample_func_two_run = value
    --     else -- running as "get"
    --         return char.sample_func_two_run
    --     end
    -- end,
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
end

function mod:OnEnable()
    Hiui:Print(name .. " enabled.")
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
    Hiui:Print(name .. " disabled.")
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
