local addonName, hiui = ...
local msg = hiui.sysMsg
local RunSlashCmd = hiui.RunSlashCmd
local HiuiDB = _G["hiuiDB"]
hiui.todo.MinimapButtons = true

function hiui.run.MinimapButtons()
	local Minimap = _G["Minimap"]

	local LibDBIcon10_SimulationCraft = _G["LibDBIcon10_SimulationCraft"]
	local LibDBIcon10_Details = _G["LibDBIcon10_Details"]
	local Grid2Layout = _G["Grid2Layout"]
	local LibDBIcon10_Myslot = _G["LibDBIcon10_Myslot"]
	local LibDBIcon10_Grid2 = _G["LibDBIcon10_Grid2"]
	local BasicMinimapSV = _G["BasicMinimapSV"]
	do -- init
		HiuiDB.HideMinimapButtons = HiuiDB.HideMinimapButtons or 0
		HiuiDB.MinimapPositioned = HiuiDB.MinimapPositioned or 0
	end
	
	if HiuiDB.HideMinimapButtons < (hiui.debugLevel or hiui.version) then
		-- Grid2Layout.minimapIcon is a stub of LibDB, so until
		-- we implement our own, we can use that.

		if LibDBIcon10_SimulationCraft and LibDBIcon10_SimulationCraft:IsShown() then
			msg("Hiding Simcraft Button.")

			--DEFAULT_CHAT_FRAME.editBox:SetText("/simc minimap")
			--ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
			RunSlashCmd("/simc minimap")
		end

		if LibDBIcon10_Details and LibDBIcon10_Details:IsShown() then
			-- how the frickle frackle do we hide the icon from inside the menu?
			-- GameCooltipMainButton10
			Grid2Layout.minimapIcon:Hide("Details")
			--GameCooltipMainButton10:Click("LeftButton")
		end

		HiuiDB.HideMinimapButtons = hiui.version
	end

	do -- unfortunately, until we figure out how to uncheck non-named buttons,
	   -- we have to hide these each time.
		if LibDBIcon10_Myslot and LibDBIcon10_Myslot:IsShown() then
			Grid2Layout.minimapIcon:Hide("Myslot")
			-- ls:Hide("Myslot")
		end

		if LibDBIcon10_Grid2 and LibDBIcon10_Grid2:IsShown() then
			Grid2Layout.minimapIcon:Hide("Grid2")
			--ls:Hide("Grid2")
		end
	end

	-- calculate minimap position
	if Minimap and BasicMinimapSV and BasicMinimapSV.profiles[addonName] then

		local desired = {
			bitt = "BOTTOMRIGHT",
			anchor = "BOTTOMRIGHT",
			xOffset = -40,
			yOffset = 55,
		}

		local bitt, anchor, xOffset, yOffset = BasicMinimapSV.profiles[addonName].position[1], BasicMinimapSV.profiles[addonName].position[2], BasicMinimapSV.profiles[addonName].position[3], BasicMinimapSV.profiles[addonName].position[4]

		if bitt == desired.bitt and anchor == desired.anchor and xOffset == desired.xOffset and yOffset == desired.yOffset then
			return
		else
			BasicMinimapSV.profiles[addonName].position = {
				[1] = desired.bitt,
				[2] = desired.anchor,
				[3] = desired.xOffset,
				[4] = desired.yOffset,
			}
		end

		HiuiDB.MinimapPositioned = hiui.version

	end
end
