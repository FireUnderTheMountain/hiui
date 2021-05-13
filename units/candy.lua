local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.Candy = select(2, IsAddOnLoaded("Candy")) and select(2, IsAddOnLoaded("Broker_Everything"))

local temp_fail = 0

local CandyDB = _G["CandyDB"]

local function setPoint(mod, point, relativeTo, relativePoint, x, y)
	CandyDB.global.bars[mod]["anchors"][1]["point"] = point
	CandyDB.global.bars[mod]["anchors"][1]["relativeTo"] = relativeTo
	CandyDB.global.bars[mod]["anchors"][1]["relativePoint"] = relativePoint
	CandyDB.global.bars[mod]["anchors"][1]["x"] = x
	CandyDB.global.bars[mod]["anchors"][1]["y"] = y
end

function hiui.run.Candy()
	do -- init
		hiuiDB.CandybarsPositioned = hiuiDB.CandybarsPositioned or 0
		hiuiDB.CandybarsArt = hiuiDB.CandybarsArt or 0
	end

	-- This tests Details, Broker_everything, and Candy
	local testFrames = {
	   "CandyDetailsFrame", "CandyGPSFrame",
	   "CandyFriendsFrame", "CandyDifficultyFrame", "CandyXPFrame", "CandybobSatchelsFrame", "CandyGoldFrame", }

	local CandyDetailsFrame = _G["CandyDetailsFrame"]
	local CandyTotalRP3Frame = _G["CandyTotalRP3Frame"]
	local CandyAltoholicFrame = _G["CandyAltoholicFrame"]
	local CandyGPSFrame = _G["CandyGPSFrame"]
	local CandyFriendsFrame = _G["CandyFriendsFrame"]
	local CandyDifficultyFrame = _G["CandyDifficultyFrame"]
	local CandyXPFrame = _G["CandyXPFrame"]
	local CandybobSatchelsFrame = _G["CandybobSatchelsFrame"]
	local CandyGoldFrame = _G["CandyGoldFrame"]

	local CandyWoWTokenFrame = _G["CandyWoWTokenFrame"]
	local CandyNotesFrame = _G["CandyNotesFrame"]

	-- Failure
	for _, v in pairs(testFrames) do

		if not _G[v] then
			if temp_fail > 5 then
				msg("Not returning, failed too many times.")
			else
				temp_fail = temp_fail + 1
				C_Timer.After(0.7, hiui.run.Candy)
			end
			return
		end
	end


	if hiuiDB.CandybarsPositioned < (hiui.debugLevel or hiui.version) then
		local uiw = UIParent:GetWidth()

		if CandyDetailsFrame and CandyDetailsFrame:IsShown() then
			CandyDetailsFrame:ClearAllPoints()
			CandyDetailsFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT")

			setPoint("Details", "TOPLEFT", "UIParent", "TOPLEFT", 0, 0)
		end

		if CandyTotalRP3Frame and CandyTotalRP3Frame:IsShown() then
			CandyTotalRP3Frame:ClearAllPoints()
			CandyTotalRP3Frame:SetPoint("TOPLEFT", UIParent, "TOP")

			setPoint("Total RP 3", "TOPLEFT", "UIParent", "TOP", 0, 0)
		end

		if CandyAltoholicFrame and CandyAltoholicFrame:IsShown() then
			CandyAltoholicFrame:ClearAllPoints()
			CandyAltoholicFrame:SetPoint("TOPLEFT", "CandyDetailsFrame", "TOPRIGHT", uiw/12, 0)

			setPoint("Altoholic", "TOPLEFT", "CandyDetailsFrame", "TOPRIGHT", uiw/12, 0)
		end

		if CandyGPSFrame and CandyGPSFrame:IsShown() then
			CandyGPSFrame:ClearAllPoints()
			CandyGPSFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")

			setPoint("GPS", "TOPRIGHT", "UIParent", "TOPRIGHT", 0, 0)
		end

		if CandyFriendsFrame and CandyFriendsFrame:IsShown() then
			CandyFriendsFrame:ClearAllPoints()
			CandyFriendsFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")

			setPoint("Friends", "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0)
		end

		if CandyDifficultyFrame and CandyDifficultyFrame:IsShown() then
			CandyDifficultyFrame:ClearAllPoints()
			CandyDifficultyFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -uiw/4, 0)

			setPoint("Difficulty", "BOTTOMRIGHT", "UIParent", "BOTTOM", -uiw/4, 0)
		end

		if CandyXPFrame and CandyXPFrame:IsShown() then
			CandyXPFrame:ClearAllPoints()
			CandyXPFrame:SetPoint("BOTTOM", UIParent, "BOTTOM")

			setPoint("XP", "BOTTOM", "UIParent", "BOTTOM", 0, 0)
		end

		if CandybobSatchelsFrame and CandybobSatchelsFrame:IsShown() then
			CandybobSatchelsFrame:ClearAllPoints()
			CandybobSatchelsFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", uiw/4, 0)

			setPoint("bobSatchels", "BOTTOMLEFT", "UIParent", "BOTTOM", uiw/4, 0)
		end

		if CandyGoldFrame and CandyGoldFrame:IsShown() then
			CandyGoldFrame:ClearAllPoints()
			CandyGoldFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")

			setPoint("Gold", "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, 0)
		end

		hiuiDB.CandybarsPositioned = hiui.version
	end

	--[[
		Top left: Details, WoWToken
		Top center-left: config buttons (Altoholic, BugSack)
		Top: none(?), TRP
		Top center-right: none
		Top right: Mail, GPS

		Bot left: Friends, Guild
		Bot center-left: Difficulty, Equipment
		Bot center: XP
		Bot center right: Notes, bobSatchels
		Bot right: System, Volume, Bags, Gold
	--]]

	local primaryFrames = { Topleft = CandyDetailsFrame or CandyWoWTokenFrame, Topright = CandyGPSFrame, Botleft = CandyFriendsFrame, Botcenleft = CandyDifficultyFrame, Botcen = CandyXPFrame, Botcenright = CandybobSatchelsFrame or CandyNotesFrame, Botright = CandyGoldFrame }

	-- Never eat a candy bar if the wrapper is torn or broken...
	local wrapper = {}
	for k, v in pairs(primaryFrames) do
		if v then
			--msg("Test: " .. v:GetName() .. " exists.")

			wrapper[k] = CreateFrame("Frame", "HiuiCandybarWrapper" .. k, v)
			--wrapper[k]:SetFrameLevel(wrapper[k]:GetParent():GetFrameLevel()-1)
			wrapper[k]:SetFrameLevel(v:GetFrameLevel()-1)
		else
			msg("Oh shit, candy bar " .. k .. " has gone missin... . this IS the bad news bro!! !")
		end
	end


	-- Wrapper: Set left frame, right frame OR NIL, crimp corners
	local function wrapIt(self, lframe, rframe, upsidedown)
		if not lframe then return end
		local u = upsidedown or false

		self:SetPoint("TOPLEFT", lframe, "TOPLEFT")
		self:SetPoint("BOTTOMRIGHT", rframe or lframe, "BOTTOMRIGHT")

		local bg = self:CreateTexture(nil, "BACKGROUND", nil, -1)
		bg:SetTexture([[Interface/AddOns/Hiui/Textures/CandyBarBg]])
		bg:SetPoint("LEFT")
		bg:SetPoint("RIGHT")

		local lcrimp = self:CreateTexture(nil, "BACKGROUND", nil, 0)
		lcrimp:SetTexture([[Interface/AddOns/Hiui/Textures/CandyBarEnd]])

		local rcrimp = self:CreateTexture(nil, "BACKGROUND", nil, 0)
		rcrimp:SetTexture([[Interface/AddOns/Hiui/Textures/CandyBarEnd]])


		if u then
			lcrimp:SetTexCoord(0, 1, 1, 0)
			lcrimp:SetPoint("RIGHT", self, "LEFT", 9, 1)

			rcrimp:SetTexCoord(1, 0, 1, 0)
			rcrimp:SetPoint("LEFT", self, "RIGHT", -9, 1)

			bg:SetTexCoord(0, 1, 1, 0)
			bg:SetPoint("TOP", self, "TOP", 0, 3)
			bg:SetPoint("BOTTOM")
		else
			lcrimp:SetTexCoord(0, 1, 0, 1)
			lcrimp:SetPoint("RIGHT", self, "LEFT", 9, -1)

			rcrimp:SetTexCoord(1, 0, 0, 1)
			rcrimp:SetPoint("LEFT", self, "RIGHT", -9, -1)

			bg:SetTexCoord(0, 1, 0, 1)
			bg:SetPoint("TOP")
			bg:SetPoint("BOTTOM", self, "BOTTOM", 0, -3)
		end

		lcrimp:SetSize(24, 24)
		rcrimp:SetSize(24, 24)
	end

	-- Many addons bring their own broker, so be prepared for them not to exist.
	-- at least 1 frame must exist.
	local CandyMailFrame = _G["CandyMailFrame"]
	local CandyGuildFrame = _G["CandyGuildFrame"]
	local CandyIDsFrame = _G["CandyIDsFrame"]
	local CandyEquipmentFrame = _G["CandyEquipmentFrame"]
	local CandySystemFrame = _G["CandySystemFrame"]

	wrapIt(wrapper.Topleft, CandyDetailsFrame or CandyWoWTokenFrame, CandyWoWTokenFrame, true)
	wrapIt(wrapper.Topright, CandyMailFrame, CandyGPSFrame, true)
	wrapIt(wrapper.Botleft, CandyFriendsFrame, CandyGuildFrame)
	wrapIt(wrapper.Botcenleft, CandyIDsFrame or CandyDifficultyFrame, CandyEquipmentFrame)
	wrapIt(wrapper.Botcen, CandyXPFrame)
	wrapIt(wrapper.Botcenright, CandyNotesFrame, CandybobSatchelsFrame)
	wrapIt(wrapper.Botright, CandySystemFrame, CandyGoldFrame)
end
