--[[
lib\Ace3\LibStub\LibStub.lua
lib\Ace3\CallbackHandler-1.0.xml
lib\Ace3\CallbackHandler-1.0.lua
lib\libdatabroker-1.1\LibDataBroker-1.1.lua
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")


function Hiui.registerLdb()
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

	-- local function doCreated(eventName, dataobj)
	-- 	--DEFAULT_CHAT_FRAME:AddMessage("Hiui LDB data object " .. name .. "created.")
	-- end
	-- ldb.RegisterCallback(Hiui, "LibDataBroker_DataObjectCreated", doCreated)

	local function attribChanged(eventName, attr, value, dataobj)
		if dataobj == Hiui.ldb then
			print("Hiui LDB attribute changed: " .. attr .. ".")
		else
			print("Attrib changed for some reason?")
		end
	end
	ldb.RegisterCallback(Hiui, "LibDataBroker_AttributeChanged_Hiui_LDB", attribChanged)

	local doInitializer = {
		type = "data source",
		text = Hiui.db:GetCurrentProfile() or "No Profile",
		--label = "Hiui", -- default: name from NewDataObject(name)
		icon = [[Interface\AddOns\Hiui\Textures\icon-32]],
		OnClick = function(self, button)
			if not InCombatLockdown() then
				InterfaceOptionsFrame_OpenToCategory(Hiui.optionFrames.
				profiles)
				InterfaceOptionsFrame_OpenToCategory(Hiui.optionFrames.
				profiles)
			end
		end,
		OnEnter = function(self)
			print("Right LDB.")
		end,
		OnLeave = function(self)
			print("Left LDB.")
		end,
		OnTooltipShow = function(self) -- display addon handling.
			self:AddLine("Test First Line.")
			for k, v in pairs(Hiui.db:GetProfiles()) do
				self:AddLine(tostring(k) .. ": " .. tostring(v))
			end
			self:AddLine("Second Test Line.")
		end,
	}

	Hiui.ldb = ldb:NewDataObject("Hiui LDB", doInitializer)
	--local myldb = Hiui.ldb
end
