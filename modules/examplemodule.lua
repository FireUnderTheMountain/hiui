--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = Hiui
local name, version = "Test Module", 1
local mod = Hiui:NewModule(name)
mod.modName, mod.version = name, version

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
local defaults = Hiui.defaults
defaults.global.modules[name] = {
    debug = true, -- noisy debugging information.
}
defaults.profile.modules[name] = {
    enabled = true,
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
        exampleoption = {
			name = "Function",
			desc = "Run a function?",
			type = "execute",
			confirm = true,
			func = features.sample_function,
		},
        exampleoptiontwo = {
            name = "Another function",
            desc = "Run a function on checking.",
            type = "toggle",
            set = features.sample_func_two,
            get = features.sample_func_two,
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
    Hiui:Print(name .. " initialized.")

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
end

function mod:OnDisable()
    Hiui:Print(name .. " disabled.")
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
