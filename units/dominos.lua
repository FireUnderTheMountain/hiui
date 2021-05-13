local addonName, hiui = ...
local msg = hiui.sysMsg
local RunSlashCmd = hiui.RunSlashCmd
--local editbox = hiui.editbox
_, hiui.todo.Dominos = IsAddOnLoaded("Dominos")

--local ChatEdit_SendText = _G["ChatEdit_SendText"]

function hiui.run.Dominos()
	do -- init
		hiuiDB.DominosProfile = hiuiDB.DominosProfile or 0
	end

	if hiuiDB.DominosProfile < (hiui.debugLevel or hiui.version) and
	   not select(2, IsAddOnLoaded("Reflux")) then

		msg("Setting dominos profile for Hiui.")

		-- editbox:SetText("/dominos set Hiui")
		-- ChatEdit_SendText(editbox)
		RunSlashCmd("/dominos set Hiui")

		hiuiDB.DominosProfile = hiui.version
	end
end
