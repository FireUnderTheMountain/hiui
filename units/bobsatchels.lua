local addonName, hiui = ...
local msg = hiui.sysMsg
_, hiui.todo.BobSatchels = IsAddOnLoaded("bobSatchels")

local bobSatchelsSaved = _G["bobSatchelsSaved"]

local you = UnitName("player") .. "-" .. GetRealmName()

local function setOption(option, value)
	bobSatchelsSaved[you][option] = value
end


-- bobSatchels saves standard interface options per-character. So we have to set them every time.
function hiui.run.BobSatchels()
	do -- init
		hiuiDB.BobSatchelsPerChar = hiuiDB.BobSatchelsPerChar or 0
	end

	if hiuiDB.BobSatchelsPerChar < (hiui.debugLevel or hiui.version) then
		setOption("rewards", false)
		setOption("flashalert", false)
		setOption("alert", false)
		setOption("popup", false)
		setOption("minimap", false)
		setOption("autodock", false)
		setOption("flash", false)
		setOption("autoopen", false)
		setOption("showdone", false)
		setOption("autohide", true)

		setOption("mbf", false)	-- Requires reload to function.

		hiuiDB.BobSatchelsPerChar = hiui.version
	end
end
