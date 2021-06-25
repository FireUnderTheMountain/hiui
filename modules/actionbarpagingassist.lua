--[[    Header
In this opening block, only the name of the addon, version, info and dependencies needs to be changed.
Dependencies are mod names that you require to be enabled for this mod to load. You should use the folder name exactly.
Module information will be displayed on the main hiui page.
The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Action Bar Paging Assist", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "Module information."
mod.depends = {}

--[[ Imports --]]
-- local GlobalUIElement = _G["GlobalUIElement"]

--[[ Locals --]]
local art = {
    target = [[]], -- target
    focus = [[]], -- focus
    assist = [[]], -- assist

    sword = [[]], -- sword
    shield = [[]], -- shield
    cross = [[]], -- cross

    harm = [[]], -- harm
    help = [[]], -- help

    gray = [[]], -- gray
    red = [[]], -- red
    green = [[]], -- green
    blue = [[]], -- blue
}

--[[    Database Access
Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
mod.db.global, mod.db.profile, mod.db.char
--]]
local global, profile, class, char

--[[    Default Values
You should include at least the following:
defaults.global.debug = false
defaults.profile.enabled = false
defaults.char.initialized = false
--]]
local defaults = {
    global = {
        debug = true, -- noisy debugging
        bar = {
            ['*'] = [[default]],
        },
    },
    profile = {
        enabled = false, -- have root addon enable?
        bar = {
            ['*'] = [[default]],
        },
    },
    class = {
        ['*'] = {
            bar = {
                ['*'] = [[default]],
            },
        },
        bar = {
            ['*'] = [[default]],
        },
    },
    char = {
        scope = "class",
        bar = {
            ['*'] = [[default]],
        },
    },
    -- ['**'] = {
    --     bar = {
    --         ['*'] = [[default\texture]],
    --     }
    -- }
}


--[[    "Features" local variable
Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
Remember to set/change db values during these functions.
--]]
local features = {
    update_scope = function(_, value)
        if value then char.scope = value end

        mod:ACTIONBAR_PAGE_CHANGED() -- update current bar.
    end,
    set_art = function()
    end
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
        update_scope = {
            order = 3,
            name = "Art Locality",
            type = "select",
            style = "radio",
            values = {
                global = "Global",
                profile = "Profile",
                class = "Class",
                spec = "Specialization",
                char = "Character",
            },
            sorting = { [1] = "global", [2] = "profile", [3] = "class", [4] = "spec", [5] = "char", },
            set = features.update_scope,
            get = function() return char.scope end,
        },
        set_art = {
            order = 4,
            name = "Art",
            type = "select",
            style = "radio",
            values = function()
                local t = {}
                for k,v in pairs(art) do
                    t[v] = k
                end
                return t
            end,
            sorting = {},
            set = features.set_art,
            get = function()
                if char.scope == "spec" then
                    return class[GetSpecialization()][GetActionBarPage()]
                else
                    return mod.db[char.scope][GetActionBarPage()]
                end
            end,
            width = "full",
        },
    },
}

function mod:ACTIONBAR_PAGE_CHANGED(event)
    -- get current page for action bar 1. match with art chosen for profile->class->spec->character.
    local b = GetActionBarPage()

    if char.scope == "spec" then
        art:SetTexture(class[GetSpecialization()].bar[b])
    else
        art:SetTexture(self.db[char.scope].bar[b])
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
    global, profile, class, char = self.db.global, self.db.profile, self.db.class, self.db.char

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ Gray out args. do not modify. --]]
    if not profile.enabled then disableArgs(options) end

    --[[ Module specific on-load routines go here. --]]
end

function mod:OnEnable()
    do -- disable unworking
        mod:Disable()
        return
    end
    --[[ For combat-unsafe mods. --]]
    if InCombatLockdown() then
        return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
    end
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")

    enableArgs(options) -- do not remove.

    self:RegisterEvent("ACTIONBAR_PAGE_CHANGED")

    --[[ Module specific on-run routines go here. --]]
    self:ACTIONBAR_PAGE_CHANGED()
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
end
