local addonName, hiui = ...
local msg = hiui.sysMsg
_, hiui.todo.CTATracker = IsAddOnLoaded("CTATracker")

local CTATracker_MainFrame = _G["CTATracker_MainFrame"]
local ExecAssist_TaskWindow = _G["ExecAssist_TaskWindow"]

function hiui.run.CTATracker()
	do -- init
		hiuiDB.CTAPositioned = hiuiDB.CTAPositioned or 0
	end

	if CTATracker_MainFrame then
		CTATracker_MainFrame:ClearAllPoints()

		local ear
		if ExecAssist_TaskWindow and ExecAssist_TaskWindow:IsShown() then
			ear = ExecAssist_TaskWindow:GetWidth()
		end

		-- Sadly it only scrolls down, rip bottom of screen placement
		CTATracker_MainFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", ear or 350, -24)
	end
end


-- Inherently broken. Needs LDB addon.
function hiui.HideCTA(trufe)
	if CTATracker_MainFrame then
		if trufe then CTATracker_MainFrame:Hide()
		else CTATracker_MainFrame:Show() end
	end
end
