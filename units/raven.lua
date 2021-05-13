local addonName, hiui = ...
local msg = hiui.sysMsg
_, hiui.todo.Raven = IsAddOnLoaded("Raven")
_, hiui.todo.Raven = IsAddOnLoaded("Raven_Options")	-- LOD, invoke load before using

function hiui.run.Raven()

	do -- init
		hiuiDB.RavenProfile = hiuiDB.RavenProfile or 0
	end

	-- Check that raven config frame exists

	-- Open Raven Frame

	-- Check that we opened raven config frame

end