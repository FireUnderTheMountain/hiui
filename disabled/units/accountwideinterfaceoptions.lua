local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.accountwideinterfaceoptions = true
hiui.todo.accountwidetracking = true

--[[ DEBUG VARS
Set anything to true to see warnings in chat, or false to hide warnings.
--]]
local DEBUG_INTERFACE_SAVING = false
local WARN_UNHANDLED_FRAME_TYPE = true
local WARN_NEED_RELOAD = true
local DEBUG_TRACKING_SAVE = true
local INFO_TRACKING_RESTORE_NOT_ACCOUNT_WIDE = true
local INFO_TRACKING_RESTORE_CHANGES = true
local INFO_TRACKING_RESTORE_OTHER = true
local INFO_IN_COMBAT = true
--[[ DEBUG END --]]

function hiui.run.accountwideinterfaceoptions()
	local InterfaceOptionsFrame_Show = _G["InterfaceOptionsFrame_Show"]
	local InterfaceOptionsFrameCancel = _G["InterfaceOptionsFrameCancel"]
	hiuiTempCrossCharacterDB = hiuiTempCrossCharacterDB or { }
	local hiuiCC = hiuiTempCrossCharacterDB
	hiuiCC.InterfaceOptionsStorage = hiuiCC.InterfaceOptionsStorage or {
		buttons = { }, -- Button names, :SetChecked(v) and :GetChecked()
		dropdowns = { }, -- Frame names, :SetValue(v) and :GetValue()
		-- Sliders and toggles work the same as dropdowns.
	}
	local ios = hiuiCC.InterfaceOptionsStorage

	local i = "InterfaceOptions"
	local panels = {
		i .. "ControlsPanel",
		i .. "CombatPanel",
		i .. "DisplayPanel",
		i .. "SocialPanel",
		i .. "ActionBarsPanel",
		i .. "NamesPanel",
	}

	local knownUnhandledFrames = {
		InterfaceOptionsDisplayPanelResetTutorials = true,
		InterfaceOptionsSocialPanelTwitterLoginButton = true,
		InterfaceOptionsSocialPanelRedockChat = true,
	}

	-- Ref: FrameXML/InterfaceOptionsPanels.lua
	local function InterfaceOptionsStorage_ReadAndSaveInterfacePanel()
		for _, p in ipairs(panels) do
			msg("Frame " .. p .. " got!", DEBUG_INTERFACE_SAVING)
			for _, child in ipairs({_G[p]:GetChildren()}) do
				local cName = child:GetName()
				if cName then
					msg("Handling frame " .. cName, DEBUG_INTERFACE_SAVING)

					local cType = child:GetObjectType()
					msg(cName .. " is a " .. tostring(cType), DEBUG_INTERFACE_SAVING)
					if cType == "CheckButton" then
						ios.buttons[cName] = child:GetChecked()
					elseif cType == "Slider" then
						ios.dropdowns[cName] = child:GetValue()
					elseif cType == "Frame" then
						if child.cvar then -- Dropdown with cvar
							ios.dropdowns[cName] = child:GetValue()
							msg(cName .. " has associated CVar.", DEBUG_INTERFACE_SAVING)
						elseif child.value then -- sliders & toggles
							ios.dropdowns[cName] = child:GetValue()
							msg(cName .. " has associated value.", DEBUG_INTERFACE_SAVING)
						end
					elseif not knownUnhandledFrames[cName] then
						msg("Frame " .. cName .. " on panel " .. p .. " is an unhandled frame type: " .. tostring(cType) .. ". Please report this.", WARN_UNHANDLED_FRAME_TYPE)
					end
				end
			end
		end
	end

	function InterfaceOptionsStorage_Save()
		if InCombatLockdown() then
			msg("Please wait til combat ends to try to save your variables.", INFO_IN_COMBAT)
			return
		end

		InterfaceOptionsFrame_Show()
		local function closeIOF(self)
			if InCombatLockdown() then return end

			InterfaceOptionsStorage_ReadAndSaveInterfacePanel()
			InterfaceOptionsFrameCancel:Click()
			msg("Saving interface options. Please relead to prevent miscellaneous errors in combat.", WARN_NEED_RELOAD)
			self:Cancel()
		end
		hiuiTempTicker = C_Timer.NewTicker(0.15, closeIOF)
	end

	--[[ TODO: Allow optional argument to load from a specific character.
	Requires setting up AceDB first. --]]
	local seenMessage = false
	function InterfaceOptionsStorage_Load()
		if InCombatLockdown() then
			if not seenMessage then
				msg("Restoring cvars not support in combat. Will apply once you leave combat.", INFO_IN_COMBAT)
				seenMessage = true
			end
			C_Timer.After(1.5, InterfaceOptionsStorage_Load())
			return
		end

		--[[ Click all the buttons. --]]
		for b, desiredState in pairs(ios.buttons) do
			local button = _G[b]
			local checkState = button:GetChecked()
			if button:IsEnabled() and checkState ~= desiredState then
				print("Adjusted interface option " .. b .. ".")
				button:SetChecked(not checkState)
				button:GetScript("OnClick")(button) -- Fizzie said to do this.
			end
		end

		--[[ Set all dropdown menus, toggles, and sliders. --]]
		for dd, desiredState in pairs(ios.dropdowns) do
			local dropdown = _G[dd]
			if dropdown:GetValue() ~= desiredState then
				print("Adjusted interface option " .. dd .. ".")
				dropdown:SetValue(desiredState)
			end
		end

		 msg("You changed your interface settings. You should /reload to avoid awful lua errors in combat!")
	end
end


--[[ 	NOTES	--]]
--BONUS: autoLootRate	150ms default	Game	Per-Character
--	--BONUS: lossOfControlDisarm, Full, Interrupt, Root, Silence, all 2 default
--	--BONUS: findYourselfAnywhere, findYourselfAnywhereOnlyInCombat
--	"findYourselfMode", -- outline mode (0 (circle), 1 (both), 2 (outline))
--	"findYourselfInRaid", "findYourselfInRaidOnlyInCombat", "findYourselfInBG", "findYourselfInBGOnlyInCombat", -- raid self highlight (drop down)
-- IMMERSION MODE
	-- World
-- ["ObjectSelectionCircle"] 0, 1 (default)
-- ["ShowQuestUnitCircles"], 0, 1 (default)
-- ["autoStand"], 0, 1 (default)
-- ["autoUnshift"], 0, 1 (default)
-- ["autoSelfCast"], 0, 1 (default)
-- ["autoDismount"], 0, 1 (default)
	-- Map
-- ["showQuestObjectivesOnMap"], 0, 1 (default)
-- ["showDungeonEntrancesOnMap"], 0, 1 (default)

--INTERFACE:
-- ?? ["autoPushSpellToActionBar"], 0, 1 (default)
-- ?? ["advancedWatchFrame"], 0 (default), 1
-- ?? ["flightAngleLookAhead"], 0 (default), 1
-- ["calendarShowLockouts"], 0, 1 (default)
	--removeChatDelay
-- ["combatLogUniqueFilename"], 0 (default), 1
-- ["minimapAltitudeHintMode"], 0 (default), 1 (darken), 2 (arrows)
-- ["missingTransmogSourceInItemTooltips"] - ?
-- threatShowNumeric
-- MouseNoRepositioning 0 default
-- MouseUseLazyRepositioning
-- rawMouseAccelerationEnable	1	Game		Enable acceleration for raw mouse input
-- rawMouseEnable	0	Game		Enable raw mouse input
-- rawMouseRate	125	Game		Raw mouse update rate
-- rawMouseResolution

--		TargetNearestUseNew	1	Game		Use new 7.2 'nearest target' functionality (Set to 0 for 6.x style tab targeting)
--GitHub Octocat.png	TargetPriorityCombatLock	1	Game		1=Lock to in-combat targets when starting from an in-combat target. 2=Further restrict to in-combat with player.
--GitHub Octocat.png	TargetPriorityCombatLockContextualRelaxation	1	Game		1=Enables relaxation of combat lock based on context (eg. no in-combat target infront)
--GitHub Octocat.png	TargetPriorityCombatLockHighlight	0	Game		1=Lock to in-combat targets when starting from an in-combat target. 2=Further restrict to in-combat with player. (while doing hold-to-target)
--GitHub Octocat.png	TargetPriorityPvp	1	Game		When in pvp, give higher priority to players and important pvp targets (1 = players & npc bosses, 2 = all pvp targets, 3 = players only)
--GitHub Octocat.png	TargetPriorityValueBank	1	Game		Selects the active targeting values bank for calculating target priority order

function hiui.run.accountwidetracking()
	hiuiTempCrossCharacterDB = hiuiTempCrossCharacterDB or { }
	local hiuiCC = hiuiTempCrossCharacterDB
	hiuiCC.TrackingStorage = hiuiCC.TrackingStorage or { }
	local mainTracking = hiuiCC.TrackingStorage
	local you = UnitName("player") -- for acedb?

	function TrackingStorage_Save(sparse)
		local sparse = (sparse and true or false)
		for i=1, GetNumTrackingTypes() do
			local name, _, active, _ = GetTrackingInfo(i)
			local active = (active or false)
			local different = (mainTracking[name] and mainTracking[name] ~= active)

			if mainTracking[name] == nil then
				mainTracking[name] = active
				msg("Adding new tracking type " .. name .. " to defaults.", true)
			elseif different and not sparse then
				mainTracking[name] = active
				local m = active and ("Tracking \"" .. name .. "\".") or ("Setting \"" .. name .. "\" tracking inactive.")
				msg(m, DEBUG_TRACKING_SAVE)
			end
		end
		msg("Your current character's tracking has been saved.", true)
	end

	local function shouldAlwaysEnable(trackingInfoName)
		return strmatch(trackingInfoName, "Find ")
	end

	local seenMessage = false
	function TrackingStorage_Load()
		if InCombatLockdown() then
			if not seenMessage then
				msg("Changing tracking settings not support in combat. Will apply once you leave combat.", INFO_IN_COMBAT)
				seenMessage = true
			end
			C_Timer.After(1.5, TrackingStorage_Load())
			return
		end

		if not next(mainTracking) then
			msg("Can't load your tracking settings because you haven't saved any!", INFO_TRACKING_RESTORE_OTHER)
			return
		end

		for i=1, GetNumTrackingTypes() do
			local name, _, active, _ = GetTrackingInfo(i)
			active = (active or false)

			--if category ~= "other" and active then
			--	msg("Tracking-type " .. name .. " is a spell/ability and must be manually used to track it.", true)
			--elseif not mainTracking[name] then
			if mainTracking[name] == nil then
				msg(name .. " isn't tracked account wide so we won't change it. Maybe you want to run a sparse save to add it?", INFO_TRACKING_RESTORE_NOT_ACCOUNT_WIDE)
			elseif active ~= mainTracking[name] then
				msg("Toggling " .. name .. " because you want it " .. (mainTracking[name] and "enabled." or "disabled."), INFO_TRACKING_RESTORE_CHANGES)
				SetTracking(i, (mainTracking[name] and true))
			end
		end
	end
end
