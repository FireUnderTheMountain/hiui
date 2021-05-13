Hiui = LibStub("AceAddon-3.0"):NewAddon("hiUI", "AceEvent-3.0", "AceConsole-3.0")
local Hiui = Hiui
Hiui:SetDefaultModuleState(false)
-- Remember to run :Enable() on each module.
Hiui.optionsName = "Hiui Options Table Main Page"
local optionsName = tostring(Hiui.optionsName)
local db

Hiui.defaults = {
	global = {
		debug = false,
		modules = {
			['**'] = {
				debug = false,
			},
		},
	},
	profile = {
		-- The whole UI should operate in the profile space.
		modules = {
			['**'] = {
				enabled = false,
			},
		},
	},
	char = {
		-- Store confirmation bools for changes here,
		-- to ensure we don't rechange things that don't need it.
		modules = {
			['**'] = {
				initialized = 0,
			},
		},
	},
}
local defaults = Hiui.defaults

local options = {
	name = "hiUI",
	type = "group",
	args = {
		testtoggle = {
			name = "Test Toggle Do Not Click!",
			desc = "UwU wots dis",
			descStyle = "inline",
			type = "toggle",
			set = function(info, val) print((db.global.debug and "Debug is currently enabled.") or "Debug not enabled.") db.profile.testtoggled = val end,
			get = function(info) return db.profile.testtoggled end,
		},
		printmessage = {
			name = "Print a message.",
			type = "execute",
			desc = "Print message in chat.",
			func = function(info) print("o hi.") end,
		},
		debug = {
			name = "Print verbose debugging messages.",
			type = "toggle",
			get = function(info) return db.global.debug end,
			set = function(info, val) db.global.debug = val end,
		},
		modules = {
			name = "Modules",
			type = "group",
			guiHidden = true,
			args = {},
		},
	},
}

--[[
	Ace Addon component initialization
--]]
local confDialog = LibStub("AceConfigDialog-3.0")

function Hiui:CommandHandler(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionFrames.main)
		InterfaceOptionsFrame_OpenToCategory(self.optionFrames.main)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("Hiui", optionsName, input)
    end
end

function Hiui:OnInitialize()
	print("Hiui initialized.")

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
	self.optionFrames.main = confDialog:AddToBlizOptions(optionsName)
end

function Hiui:OnEnable()
	print("Hiui enabled.")

	-- load modules
	for modName, mod in self:IterateModules() do
		if db.profile.modules[modName].enabled then
			mod:Enable()
		end
	end

	self.optionFrames.profiles = confDialog:AddToBlizOptions(optionsName, tostring(options.args.profiles.name), optionsName, "profiles") 

	self:RegisterChatCommand("Hiui", "CommandHandler")

	Hiui.registerLdb()
end
