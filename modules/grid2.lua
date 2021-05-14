local Hiui = Hiui
local name = "Grid2 Customizations"
local mod = Hiui:NewModule(name)
mod.modName = name
mod.version = 1.4
local _, pClass = UnitClass("player")
local Grid2DB

local ge = {
    Healer = "Hiui-Healer",
    Tank = "Hiui-Tank",
    Damager = "Hiui-Damager",
}

local specs = {
    DEATHKNIGHT = { [1] = ge.Tank, [2] = ge.Damager, [3] = ge.Damager, },
    DEMONHUNTER = { [1] = ge.Damager, [2] = ge.Tank, },
    DRUID = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Tank, [4] = ge.Healer, },
    HUNTER = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Damager, },
    MAGE = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Damager, },
    MONK = { [1] = ge.Tank, [2] = ge.Healer, [3] = ge.Damager, },
    PALADIN = { [1] = ge.Healer, [2] = ge.Tank, [3] = ge.Damager, },
    PRIEST = { [1] = ge.Healer, [2] = ge.Healer, [3] = ge.Damager, },
    ROGUE = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Damager, },
    SHAMAN = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Healer, },
    WARLOCK = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Damager, },
    WARRIOR = { [1] = ge.Damager, [2] = ge.Damager, [3] = ge.Tank, },
}
local yClass = specs[pClass]

local function getGrid2DB()
    local function getDbNameForSv(sv)
        for k, v in pairs(_G) do
            if v == sv then
                return k
            end
        end
        return nil
    end

    local AceDB = LibStub:GetLibrary("AceDB-3.0",true)

    local g2
        for db in pairs(AceDB.db_registry) do
            if not db.parent then --db.sv is a ref to the saved vairable name
            local dbName = getDbNameForSv(db.sv)
            if dbName == "Grid2DB" then
                return db
            end
        end
    end
end

local db, global, profile, char

local defaults = Hiui.defaults
--[[ In each module, you can begin editing defaults for this module by using defaults.global|profile|char.modules.MyModule
    For example:
--]]
defaults.global.modules[name] = {
    debug = true, -- print ugly debug messages
    initialized = false, -- created the -Healer, -Damager and -Tank profiles.

}
defaults.profile.modules[name] = {
    enabled = true, -- default state of module
    always_apply_profiles = false,
}

local features = {
    enable_pps = function(_)
        RunSlashCmd("/grid2 profilesperspec enable")
        Hiui:Print("Grid2's profiles-per-specialization enabled.")
    end,
    init_hiui_profiles = function()
        local c = Grid2DB:GetCurrentProfile()
        Grid2DB:SetProfile(ge.Healer)
        Grid2DB:SetProfile(ge.Tank)
        Grid2DB:SetProfile(ge.Damager)
        --Grid2DB:SetProfile(c)
        _G["Grid2"]:SetProfileForSpec(c)
        Hiui:Print("Initialized Grid2 profiles for Hiui.")
    end,
    set_profile = function(p, s)
        --Hiui:Print("set_profile", p, s, c)
        if p then
            if s then
                _G["Grid2"]:SetProfileForSpec(p, s)
                Hiui:Print("Grid2 profile for spec " .. s .. " set to " .. p .. ".")
            else
                _G["Grid2"]:SetProfileForSpec(p)
                Hiui:Print("Grid2 profile set to " .. p .. ".")
            end
        end
    end,
    hide_minimap_icon = function(_)
        RunSlashCmd("/grid2 minimapicon hide")
        Hiui:Print("Grid2 minimap icon hidden.")
    end,
    toggle_always_apply_profiles = function(_, val)
        profile.always_apply_profiles = val
        return val
    end,
}
features.auto_set_profiles = function(_)
    for s=1,4 do
        local p = yClass[s]
        if p then
            features.set_profile(p, s)
        else
            Hiui:Print("Skipped setting profile for spec " .. s .. " because no profile assigned for it..")
        end
    end
    return
end

local options = {
    name = name .. " Options",
    type = "group",
    args = {
        enable = {
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
            order = 0,
        },
        disabledWarning = {
            name = "Disabled!\nNone of the options will function until you enable it again.",
            type = "description",
			order = 1,
			width = "full",
        },
        generic_header = {
            order = 2,
            name = "General Settings",
            type = "header",
            width = "half",
        },
        hide_minimap_icon = {
            name = "Hide Minimap Icon",
            --confirmText = "Hide Minimap Icon",
            type = "execute",
            func = features.hide_minimap_icon,
            order = 3,
        },
        profile_header = {
            name = "Profile Settings",
            type = "header",
            width = "half",
            order = 4,
        },
        set_current_profile = {
			name = "Set Current Spec Profile",
			confirmText = "Set your current Grid2 profile to the Hiui profile for this spec?",
			type = "execute",
			confirm = true,
			func = function()
                local s = GetSpecialization()
                features.set_profile(yClass[s], s)
            end,
            order = 5,
		},
        set_all_profiles = {
            name = "Reset All Profiles",
            desc = "Set all your Grid2 profiles on this character to the Hiui profiles.",
            confirmText = "This will change all this character's Grid2 profiles to the Hiui profiles.",
            type = "execute",
            confirm = true,
            func = features.auto_set_profiles,
            order = 6,
        },
        apply_profiles_on_login = {
            name = "Change every character's Grid2 profiles to Hiui's profiles",
            desc = "Normally Hiui changes each character's Grid2 profiles only once. This option will apply them at every login. NOTICE: This will not destroy your other profiles, it will only change which one is used. You can always uncheck this and change back later.",
            width = "full",
            type = "toggle",
            set = features.toggle_always_apply_profiles,
            get = function(_) return profile.always_apply_profiles end,
            order = 7,
        }
    },
}

local function enableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if v.disabled then
            v.disabled = false
        end
    end

    optionsTable.args.disabledWarning.hidden = true
end

local function disableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if k ~= "enable" and k ~= "disabledWarning" then
            v.disabled = true
        end
    end

    optionsTable.args.disabledWarning.hidden = false
end

function mod:Info()
    return "Test return info about mod."
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
    Grid2DB = getGrid2DB()
end

function mod:OnEnable()
    Hiui:Print(name .. " enabled.")
    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]
    if not global.initialized then
        -- long term we should iterate through the db checking for the profile names explicitly
        features.init_hiui_profiles()
        global.initialized = true
    end

	if char.initialized < mod.version then
        features.hide_minimap_icon()
		features.enable_pps()
        C_Timer.After(0.2, features.auto_set_profiles)
		char.initialized = mod.version
	end

    --[[ Module specific on-run routines go here. --]]
    if profile.always_apply_profiles == true then
        C_Timer.After(0.2, features.auto_set_profiles) -- dislike duplication but this keeps it clean.
    end
end

function mod:OnDisable()
    Hiui:Print(name .. " disabled.")
    disableArgs(options) -- do not remove

    --[[ Module specific on-disable routines go here. --]]
end
