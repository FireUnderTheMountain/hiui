local addonName, hiui = ...
local msg = hiui.sysMsg
local RunSlashCmd = hiui.RunSlashCmd
--local editbox = hiui.editbox
_, hiui.todo.ExtraQuestButton = IsAddOnLoaded("ExtraQuestButton")

local DEBUG_BASIC_MOVEMENT = true

--local ChatEdit_SendText = _G["ChatEdit_SendText"]

function hiui.run.ExtraQuestButton()
	local ExtraQuestButtonAnchor = _G["ExtraQuestButtonAnchor"]
	local DominosFrameextra = _G["DominosFrameextra"]
	
	--if select(2, IsAddOnLoaded("Dominos")) then
	--	msg("EQB using dominos extra action button.", DEBUG)
	--	local abilityContainer = _G["DominosFrameextra"]
	--	local heightOffset = 0
	--else
	--	msg("EQB using default extra action button.", DEBUG)
	--	local abilityContainer = _G["ExtraAbilityContainer"]
	--	local heightOffset = 0
	--end
	--local bitt, target, anchor, offsetX, offsetY = "BOTTOM", abilityContainer, "BOTTOM", 0, 0

	--abilityContainer:HookScript("OnShow", function(self)
	--	msg("Test hook for abilityContainer OnShow.", DEBUG)
	--	EQBA:SetPoint(bitt, target, anchor, offsetX, offsetY + self:GetHeight())
	--end)

	--abilityContainer:HookScript("OnHide", function(self)
	--	msg("Test hook for abilityContainer OnHide.", DEBUG)
	--	EQBA:SetPoint(bitt, target, anchor, offsetX, offsetY)
	--end)


	-- editbox:SetText("/eqb lock")
	-- ChatEdit_SendText(editbox, 0)
	RunSlashCmd("/eqb lock")
	ExtraQuestButtonAnchor:StartMoving()
	ExtraQuestButtonAnchor:ClearAllPoints()
	ExtraQuestButtonAnchor:SetPoint("BOTTOM", DominosFrameextra, "TOP", 0, 0)
	ExtraQuestButtonAnchor:StopMovingOrSizing()
	-- editbox:SetText("/eqb lock")
	-- ChatEdit_SendText(editbox, 0)
	RunSlashCmd("/eqb lock")
	msg("Moved extra quest button anchor.", DEBUG_BASIC_MOVEMENT)

	hiuiDB.QuestButtonPositioned = hiui.version

end	
