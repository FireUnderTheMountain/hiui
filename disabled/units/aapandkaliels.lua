local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.AapAndKaliels = select(2, IsAddOnLoaded("AAP-Core")) and select(2, IsAddOnLoaded("!KalielsTracker"))

local DEBUG_BOTH_LOADED = false

local testBothLoaded = 0
function hiui.run.AapAndKaliels()
	local AAP_AfkFrames = _G["AAP_AfkFrames"]
	local KalielsTrackerScrollChild = _G["!KalielsTrackerScrollChild"]
	if testBothLoaded > 7 then

		msg("Kaliel's Tracker + AAP not loaded at same time, not docking aap afk frame", DEBUG_BOTH_LOADED)

		return false

	elseif not AAP_AfkFrames or not KalielsTrackerScrollChild then

		msg("Delaying AAP-and-Kaliel's until both is loaded.", DEBUG_BOTH_LOADED)

		testBothLoaded = testBothLoaded + 1

		C_Timer.After(0.5, hiui.run.AapAndKaliels)

		return false

	end


	AAP_AfkFrames:ClearAllPoints()
	AAP_AfkFrames:SetPoint("BOTTOMLEFT", _G["!KalielsTrackerScrollChild"].Center, "TOPLEFT")


	return true

end
