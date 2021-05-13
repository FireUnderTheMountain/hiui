local addonName, hiui = ...
local hiuiAA = hiui.AA
local msg = hiui.sysMsg


---- ****
local main = CreateFrame("Frame")
main:RegisterEvent("ADDON_LOADED")
main:RegisterEvent("PLAYER_ENTERING_WORLD")
main:RegisterEvent("PLAYER_REGEN_ENABLED")
main:RegisterEvent("PLAYER_REGEN_DISABLED")


local function processRunUnits()
	local hiuiUnitsProcessed = {}
	for key, value in pairs(hiui.todo) do
		if value then
			hiui.run[key]()
			hiuiUnitsProcessed[#hiuiUnitsProcessed+1] = key
		end
	end

	msg("Processed run units: " .. table.concat(hiuiUnitsProcessed, ", "), true) -- Debug
end


function main:OnEvent(event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		msg("debug level is " .. tostring(hiui.debugLevel) .. " and version level is " .. tostring(hiui.version) .. ".", true)

		processRunUnits()
		hiui.registerLdb()

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	-- end PLAYER_ENTERING_WORLD
	elseif event == "ADDON_LOADED" and arg1 == addonName then
		hiuiDB = hiuiDB or {}

		self:UnregisterEvent("ADDON_LOADED")
	-- end ADDON_LOADED
	elseif event == "PLAYER_REGEN_DISABLED" then
		hiui.CompressChat(true)
		hiui.HideCTA(true)
	-- end PLAYER_REGEN_DISABLED
	elseif event == "PLAYER_REGEN_ENABLED" then
		--for _, v in pairs(hiui[event]) do
		--	hiui[event][v]()
		--end

		hiui.CompressChat(false)
		hiui.HideCTA(false)
	-- end PLAYER_REGEN_ENABLED
	end
end

main:SetScript("OnEvent", main.OnEvent)
