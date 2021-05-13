local addonName, hiui = ...
local msg = hiui.sysMsg
_, hiui.todo.ExecAssist = IsAddOnLoaded("Executive_Assistant")


function hiui.run.ExecAssist()
	local ExecAssist_TaskWindow_posAnchor = _G["ExecAssist_TaskWindow_posAnchor"]

	do -- init
		hiuiDB.ExecAssistPositioned	= hiuiDB.ExecAssistPositioned or 0
	end

	if hiuiDB.ExecAssistPositioned < (hiui.debugLevel or hiui.version) then
		ExecAssist_TaskWindow_posAnchor:ClearAllPoints()
		ExecAssist_TaskWindow_posAnchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -1, -24)

		hiuiDB.ExecAssistPositioned = hiui.version
	end
end
