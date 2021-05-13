local addonName, hiui = ...
local msg = hiui.sysMsg

_, hiui.todo.Details = IsAddOnLoaded("Details")

--msg("Details loaded?: " .. (hiui.todo and tostring(hiui.todo.Details)) or "no", true)
local Details = _G["Details"]
local CandyDetailsFrame = _G["CandyDetailsFrame"]

local testDetailsLoaded = 0

function hiui.run.Details()

	local testAAPLoaded = 0
	local details = Details:GetWindow(1)

	do	-- Test for loaded
		if not details then
			if testAAPLoaded > 5 then
				msg("AAP not detected for 3s after it should be, not initializing frame adjustments.")
				return false
			else
				--msg("Delaying AAP options until AAP is loaded.")
				testDetailsLoaded = testDetailsLoaded + 1
				C_Timer.After(0.5, hiui.run.AAP)
				return false
			end
		end
	end


	do	-- always
		if details then
			if IsResting() then
				details:HideWindow()
			end

			if CandyDetailsFrame then
				msg("Debugging details frame.")
				-- Fix a bug in Details where the frame may be non-interactable if it's visible when you log in.
				CandyDetailsFrame:Click("LeftButton")
				CandyDetailsFrame:Click("LeftButton")
			end
		end
	end
end
