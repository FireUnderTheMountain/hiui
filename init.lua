local Hiui = LibStub("AceAddon-3.0"):NewAddon("hiUI", "AceEvent-3.0", "AceConsole-3.0") -- AceConfigDialog-3.0 not embeddable but used.
Hiui:SetDefaultModuleState(false) -- Remember to run :Enable() on each module.
local optionsName = "Hiui"
local db

local defaults = {
	global = {
		debug = false,
	},
	profile = {
		world_tools_opie_string = "oetohH7 TWzINIq q4Xdswt oy92q32 q4iaEwm ount932 q4N0bwi tem932q 4KBE1q3 230w07U SE070Du se06212 1spell0 B0G0H0H 70F8232 391y4w9 1i430wR eset06A ll06Ins tances9 1i4q4DW 11o4w0Q label06 Reset0y 07SCRIP T070Dsc ript06R esetIns tances0 Y0U0N0y 91y43ww World06 Tools91 34wALT0 AW9144.",
	},
	char = {},
}
--local defaults = Hiui.defaults

local options = {
	name = optionsName,
	type = "group",
	args = {
		debug = {
			name = "Print verbose debugging messages.",
			type = "toggle",
			get = function(_) return db.global.debug end,
			set = function(_, val) db.global.debug = val end,
		},
		opie_string = {
			name = "\"World Tools\" oPie Import String",
			desc = "Paste this string into oPie and bind a key to it for full BagSync functionality. Interface -> AddOns -> oPie -> Custom Rings -> New Ring -> Import Snapshot",
            width = "full",
			type = "input",
            multiline = 5,
            set = function(info, value)
                info.option.get()
            end,
            get = function(_)
                return db.profile.world_tools_opie_string
            end,
		},
		-- modules = {
		-- 	name = "Modules",
		-- 	type = "group",
		-- 	guiHidden = true,
		-- 	args = {},
		-- },
	},
}

function Hiui:CommandHandler(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionFrames.main)
		InterfaceOptionsFrame_OpenToCategory(self.optionFrames.main)
	else
		for k,v in pairs(Hiui.optionFrames) do
			--input = input:lower()
			if v.name:lower():find(input:lower()) then
				InterfaceOptionsFrame_OpenToCategory(v)
				InterfaceOptionsFrame_OpenToCategory(v)
				return
			end
		end
		LibStub("AceConfigCmd-3.0"):HandleCommand("Hiui", optionsName, input)
    end
end

function Hiui:OnInitialize()
	-- Hook AceDB up to SavedVars
	--AceDB:New(tbl, defaults, defaultProfile)
	self.db = LibStub("AceDB-3.0"):New("HiuiAADB", defaults, "Hiui")
	db = self.db

	-- Turn profile selection into an options window
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
	options.args.profiles.guiHidden = true

	--AceConfig:RegisterOptionsTable(appNameToMake, optionsTable [, slashcmd])
	LibStub("AceConfig-3.0"):RegisterOptionsTable(optionsName, options)

	-- Create a GUI for your options table.
	--AceConfigDialog:AddToBlizOptions(appNameFromRegister, displayName, parent, ...)
	self.optionFrames = {}
	self.optionFrames.main = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(optionsName)
end

function Hiui:OnEnable()
	for modName, mod in self:IterateModules() do
		if db.global.debug then self:Print(modName) end

		if mod.db.profile.enabled then -- must be turned on in its own settings
			if mod.depends then -- and its self-described dependencies must be met
				if db.global.debug then self:Print("Checking dependencies for " .. modName) end

				if (function()
					for _, v in ipairs(mod.depends) do
						if IsAddOnLoadOnDemand(v) then
							if db.global.debug then self:Print("Loading LOD addon " .. v) end
							LoadAddOn(v)
						-- else
						-- 	if db.global.debug then self:Print(v .. " is not a LOD addon.") end
						end

						if IsAddOnLoaded(v) then
							if db.global.debug then self:Print("Addon dependency " .. v .. " loaded successfully.") end
						else
							self:Print("Dependency " .. v .. " for module " .. mod.modName .. " couldn't load during Hiui initialization.")
							return false
						end
					end

					if db.global.debug then self:Print("All dependencies satisfied.") end
					return true
				end)() then -- all deps are loaded
					mod:Enable()
				end
			else -- no dependencies
				mod:Enable()
			end
		end
	end

	self.optionFrames.profiles = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(optionsName, tostring(options.args.profiles.name), optionsName, "profiles")

	self:RegisterChatCommand("Hiui", "CommandHandler")

	Hiui.registerLdb()
end

function Hiui:OnDisable()
end
