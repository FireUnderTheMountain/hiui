local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.Viewport = true

--** User config **--
local topInset = 0
local bottomInset = 20
local leftInset = 0
local rightInset = 0
--** End user config **--


function hiui.run.Viewport()

	local WorldFrame = _G["WorldFrame"]

	local combat = false
	local uiScale = 768 / UIParent:GetHeight()

	local function wfResize()
		-- Offsets relative to UIParent (which is your screen, I guess)
		WorldFrame:ClearAllPoints()
		WorldFrame:SetPoint("TOPLEFT")
		--WorldFrame:SetPoint("TOP")
		--WorldFrame:SetPoint("LEFT")
		--WorldFrame:SetPoint("RIGHT")
		WorldFrame:SetPoint("BOTTOMRIGHT", 0, bottomInset * uiScale)
		print("Frame resized.")

		WorldFrame:SetUserPlaced(true)
	end

	local function applyVP(event)
		if not WorldFrame or GetScreenWidth() < 1 then
			DEFAULT_CHAT_FRAME:AddMessage("Skipping viewport change because addon loaded before WorldFrame. This is an error!")
			C_Timer.After(5, applyVP)
			return
		end

		if (UIParent:GetWidth() * uiScale - WorldFrame:GetWidth()) > 1 then
			if InCombatLockdown() then
				DEFAULT_CHAT_FRAME:AddMessage("In combat during WorldFrame resize, will try later.")
				C_Timer.After(1.1, applyVP)
				return
			end

			print("Resizing viewport because width bad.")
			wfResize()
			C_Timer.After(2, applyVP)

		elseif WorldFrame:GetBottom() <= 10 then
			if InCombatLockdown() then
				DEFAULT_CHAT_FRAME:AddMessage("In combat during WorldFrame resize, will try later.")
				C_Timer.After(1.1, applyVP)
				return
			end

			print("Resizing viewport in response to " .. (event or "own recursion."))
			wfResize()
			C_Timer.After(2, applyVP)
		--else
		--	DEFAULT_CHAT_FRAME:AddMessage("Skipping WorldFrame resize because it should be fine already. If you see this message often and your WorldFrame has a black bar at the bottom, tell someone.")
		end
	end


	local frame = CreateFrame("Frame", nil, UIParent)
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("CINEMATIC_STOP")
	frame:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			applyVP(event)
		elseif event == "CINEMATIC_STOP" then
			applyVP(event)
		end
	end)

	applyVP(nil)
end
