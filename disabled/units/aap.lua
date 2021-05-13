local addonName, hiui = ...
local msg = hiui.sysMsg
_, hiui.todo.AAP = IsAddOnLoaded("AAP-Core")

local testAAPLoaded = 0

-- Todo: AAP_PartyListFrame1

function hiui.run.AAP()

	--[[ Globals --]]
	local AAP_OptionsMainFrame = _G["AAP_OptionsMainFrame"]
	local AAP_Arrow = _G["AAP_Arrow"]
	local CLQListF2 = _G["CLQListF2"]
	local CLQListF1 = _G["CLQListF1"]
	local AAPQOrderList = _G["AAPQOrderList"]
	local AAP_SBXOZ = _G["AAP_SBXOZ"]
	local AAP_QuestFrame = _G["AAP_QuestFrame"]
	local AAP_GreetingsFrame = _G["AAP_GreetingsFrame"]
	local AAP_AutoAcceptCheckButton = _G["AAP_AutoAcceptCheckButton"]
	local AAP_AutoHandInCheckButton = _G["AAP_AutoHandInCheckButton"]
	local AAP_CutSceneCheckButton = _G["AAP_CutSceneCheckButton"]
	local AAP_AutoVendorCheckButton = _G["AAP_AutoVendorCheckButton"]
	local AAP_AutoRepairCheckButton = _G["AAP_AutoRepairCheckButton"]
	local AAP_DisableHeirloomWarningCheckButton = _G["AAP_DisableHeirloomWarningCheckButton"]
	local AAP_LockArrowCheckButton = _G["AAP_LockArrowCheckButton"]
	local AAP_GreetingsHideB = _G["AAP_GreetingsHideB"]
	local AAP_ShowQListCheckButton = _G["AAP_ShowQListCheckButton"]
	local AAP_WorldQuestsCheckButton = _G["AAP_WorldQuestsCheckButton"]
	local AAP_ShowArrowCheckButton = _G["AAP_ShowArrowCheckButton"]
	local AAP_ShowGroupCheckButton = _G["AAP_ShowGroupCheckButton"]
	local AAP_BlobsShowCheckButton = _G["AAP_BlobsShowCheckButton"]
	local AAP_MapBlobsShowCheckButton = _G["AAP_MapBlobsShowCheckButton"]
	local CLQListMyProgress = _G["CLQListMyProgress"]
	local AAP_OptionsButtons1 = _G["AAP_OptionsButtons1"]

	if not AAP_OptionsMainFrame then
		if testAAPLoaded > 5 then
			msg("AAP not detected for 3s after it should be, not initializing frame adjustments.")
			return false
		else
			--msg("Delaying AAP options until AAP is loaded.")
			testAAPLoaded = testAAPLoaded + 1

			C_Timer.After(0.5, hiui.run.AAP)
			return false
		end
	end

	do -- init
		hiuiDB.AAPFixes = hiuiDB.AAPFixes or 0
		hiuiDB.AAPMaxLevelFixes = hiuiDB.AAPMaxLevelFixes or 0
	end


	local maxLevel = (UnitLevel("player") == GetMaxPlayerLevel())
	do	-- ALWAYS RUN
		if not maxLevel and AAP_Arrow then
			if (CLQListF2 and CLQListF2:IsShown()) or (CLQListF1 and CLQListF1:IsShown()) then

				AAP_Arrow:ClearAllPoints()
				AAP_Arrow:SetPoint("LEFT", (CLQListF2:IsShown() and CLQListF2) or (CLQListF1:IsShown() and CLQListF1), "RIGHT")

				--msg("Set AAP Arrow by relative position.")
			else
				AAP_Arrow:ClearAllPoints()
				AAP_Arrow:SetPoint("LEFT", UIParent, "BOTTOMLEFT", 330, 697)

				msg("Set AAP Arrow by absolute position.")
			end
		end
	end


	local normalFixesRun = 0

	if hiuiDB.AAPFixes < (hiui.debugLevel or hiui.version) then
		--msg("Applying standard AAP adjustments for a new character.")

		-- AAPQOrderList is the big list of quests from start to finish for this zone.
		-- AAP internal name: AAP.ZoneOrder
		if AAPQOrderList and AAPQOrderList:IsShown() then
			-- AAP_SBXOZ is the Close button the AAP zone-quests list.
			AAP_SBXOZ:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_QuestFrame and AAP_QuestFrame:IsShown() then
			AAP_QuestFrame:StartMoving()
			AAP_QuestFrame.isMoving = true

			AAP_QuestFrame:ClearAllPoints()
			AAP_QuestFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -56)

			--error. We should, but we can't:
			--AAP_QuestFrameList:OnMouseUp("LeftButton")

			AAP_QuestFrame:StopMovingOrSizing()
			AAP_QuestFrame.isMoving = false

			normalFixesRun = normalFixesRun + 1
		end


		if AAP_GreetingsFrame and AAP_GreetingsFrame:IsShown() then
			AAP_GreetingsHideB:Click("LeftButton")	-- "Close" button

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_AutoAcceptCheckButton and AAP_AutoAcceptCheckButton:GetChecked() then
			AAP_AutoAcceptCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_AutoHandInCheckButton and AAP_AutoHandInCheckButton:GetChecked() then
			AAP_AutoHandInCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_CutSceneCheckButton and AAP_CutSceneCheckButton:GetChecked() then
			AAP_CutSceneCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_AutoVendorCheckButton and AAP_AutoVendorCheckButton:GetChecked() then
			AAP_AutoVendorCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_AutoRepairCheckButton and AAP_AutoRepairCheckButton:GetChecked() then
			AAP_AutoRepairCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_DisableHeirloomWarningCheckButton and not AAP_DisableHeirloomWarningCheckButton:GetChecked() then

			AAP_DisableHeirloomWarningCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		if AAP_LockArrowCheckButton and not AAP_LockArrowCheckButton:GetChecked() then

			AAP_LockArrowCheckButton:Click("LeftButton")

			normalFixesRun = normalFixesRun + 1
		end

		hiuiDB.AAPFixes = hiui.version
	end



	local maxLevelFixesRun = 0

	if maxLevel and hiuiDB.AAPMaxLevelFixes < (hiui.debugLevel or hiui.version) then

		-- Hide AAP quest tracker
		if AAP_ShowQListCheckButton and AAP_ShowQListCheckButton:GetChecked() then

			AAP_ShowQListCheckButton:Click("LeftButton")

			maxLevelFixesRun = maxLevelFixesRun + 1

		end

		-- Don't track world quests
		if AAP_WorldQuestsCheckButton and AAP_WorldQuestsCheckButton:GetChecked() then

			AAP_WorldQuestsCheckButton:Click("LeftButton")

			maxLevelFixesRun = maxLevelFixesRun + 1

		end

		-- Don't show the arrow since we're not tracking any quests anyway...
		if AAP_ShowArrowCheckButton and AAP_ShowArrowCheckButton:GetChecked() then

			AAP_ShowArrowCheckButton:Click("LeftButton")

			maxLevelFixesRun = maxLevelFixesRun + 1

		end

		if AAP_ShowGroupCheckButton and AAP_ShowGroupCheckButton:GetChecked() then

			AAP_ShowGroupCheckButton:Click("LeftButton")

			maxLevelFixesRun = maxLevelFixesRun + 1

		end

		-- Dots on minimap that direct you to the next checkpoint/quest area
		if AAP_BlobsShowCheckButton and AAP_BlobsShowCheckButton:GetChecked() then

			AAP_BlobsShowCheckButton:Click("LeftButton")

			maxLevelFixesRun = maxLevelFixesRun + 1

		end

		-- Dots on main map that direct you to next checkpoint/quest area
		if AAP_MapBlobsShowCheckButton and AAP_MapBlobsShowCheckButton:GetChecked() then

			AAP_MapBlobsShowCheckButton:Click("LeftButton")

			maxLevelFixesRun = maxLevelFixesRun + 1

		end

		-- header still shows even when list is hidden.
		if CLQListMyProgress and CLQListMyProgress:IsShown() then

			CLQListMyProgress:ClearAllPoints()
			CLQListMyProgress:SetPoint("TOPLEFT", UIParent, "TOPRIGHT", 15, 0)

		end

		if maxLevelFixesRun > 0 then

			msg("You're max level. Disabling everything about AAP")

		end

		hiuiDB.AAPMaxLevelFixes = hiui.version

	end

	msg("Ran " .. normalFixesRun .. " generic AAP fixes and " .. maxLevelFixesRun .. " max level fixes.")

	--close AAP options
	if AAP_OptionsMainFrame:IsShown() then

		msg("Closing AAP options frame because it's open.")

		AAP_OptionsButtons1:Click("LeftButton")

	end

	if UnitLevel("player") == GetMaxPlayerLevel() then
		return true	-- end prematurely because we don't need to show/hide elements on group changes.
	end


	--[[	AAP Dynamic Frames based on group roster updates.	--]]
	
	-- local function to hide frames based on challenge mode and raid group
	local function aapHideForRealContent(hide, event)

		msg((hide and "Hiding" or "Showing") .. " AAP frames based on " .. event .. ".")
				-- Hide AAP quest tracker
		local AAP_ShowQListCheckButton = _G["AAP_ShowQListcheckButton"]
		if AAP_ShowQListCheckButton then
			if (hide and AAP_ShowQListCheckButton:GetChecked()) or (not hide and not AAP_ShowQListCheckButton:GetChecked()) then

				AAP_ShowQListCheckButton:Click("LeftButton")
			end
		end

		-- Don't show the arrow since we're not tracking any quests anyway...
		local AAP_ShowArrowCheckButton = _G["AAP_ShowArrowCheckButton"]
		if AAP_ShowArrowCheckButton then
			if (hide and AAP_ShowArrowCheckButton:GetChecked()) or (not hide and not AAP_ShowArrowCheckButton:GetChecked()) then
				AAP_ShowArrowCheckButton:Click("LeftButton")
			end
		end

		local AAP_ShowGroupCheckButton = _G["AAP_ShowGroupCheckButton"]
		if AAP_ShowGroupCheckButton then
			if (hide and AAP_ShowGroupCheckButton:GetChecked()) or (not hide and not AAP_ShowGroupCheckButton:GetChecked()) then
				AAP_ShowGroupCheckButton:Click("LeftButton")
			end
		end

		-- Dots on minimap that direct you to the next checkpoint/quest area
		if AAP_BlobsShowCheckButton then
			if (hide and AAP_BlobsShowCheckButton:GetChecked()) or (not hide and not AAP_BlobsShowCheckButton:GetChecked()) then

				AAP_BlobsShowCheckButton:Click("LeftButton")

			end

		end

		-- Dots on main map that direct you to next checkpoint/quest area
		if AAP_MapBlobsShowCheckButton then

			if (hide and AAP_MapBlobsShowCheckButton:GetChecked()) or (not hide and not AAP_MapBlobsShowCheckButton:GetChecked()) then

				AAP_MapBlobsShowCheckButton:Click("LeftButton")

			end

		end

		--[[ Is this needed?

			if AAP_OptionsMainFrame:IsShown() then

			msg("Closing AAP options frame because it's open.")

			AAP_OptionsButtons1:Click("LeftButton")

			end

		--]]

	end


	local aapMonitor = CreateFrame("Frame")

	aapMonitor:RegisterEvent("GROUP_ROSTER_UPDATE")
	aapMonitor:RegisterEvent("PLAYER_ENTERING_WORLD")


	function aapMonitor:abort()

		-- If this runs, you leveled to max level recently. None of this is loaded otherwise.
		msg("Unregistering AAP group adjustments because you're max level.")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		hiui.run.AAP()
		return

	end

	local dungeoning = false
	local raiding = false
	--local numberMembers = 0

	aapMonitor:SetScript("OnEvent", function(self, event, ...)

		if event == "GROUP_ROSTER_UPDATE" then

			if UnitLevel("player") == GetMaxPlayerLevel() then aapMonitor:abort() end

			if not raiding and IsInRaid() then

				raiding = true

				if not dungeoning then aapHideForRealContent(true, event) end

			elseif raiding and not IsInRaid() then

				raiding = false

				if not dungeoning then aapHideForRealContent(false, event) end

			end

		elseif event == "PLAYER_ENTERING_WORLD" then

			if UnitLevel("player") == GetMaxPlayerLevel() then aapMonitor:abort() end


			local _, i = IsInInstance()

			if not dungeoning and i ~= "none" and i ~= "scenario" then

				dungeoning = true

				if not raiding then aapHideForRealContent(true, event) end

			elseif dungeoning and i == "none" or i == "scenario" then

				dungeoning = false

				if not raiding then aapHideForRealContent(false, event) end

			end

		end

	end)


	return true

end
