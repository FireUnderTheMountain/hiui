local addonName, hiui = ...
local msg = hiui.sysMsg
local RunSlashCmd = hiui.RunSlashCmd

--[[	We desire to free ourselves from small, secondary addons that need adaptation to work to our needs. To this end, we utilize non-copyrightable "functional use" (not art) for most of the work, along with QuestStash's MIT License[1] to swipe the clever artistic bits.
(1) https://web.archive.org/web/20210205073309/https://www.curseforge.com/wow/addons/quest-stash
--]]
--_, hiui.todo.QuestStash = IsAddOnLoaded("QuestStash")



--[[	Quest Hider
	In order to hide a list of quests, we have to store their IDs so we can get them back from the quest log once we need to show them.
	To restore quests, we have to have: valid event, valid location, and quests in the stash. Clear the stash after every showQuests()
--]]
local function localQS()
	--[[ Beep boop. Local functions are faster. --]]
	local print, next, After, InCombatLockdown = print, next, C_Timer.After, InCombatLockdown
	local pairs, ipairs = pairs, ipairs
	local IsChallengeModeActive = C_ChallengeMode.IsChallengeModeActive
	local GetInfo = C_QuestLog.GetInfo
	--local GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
	local GetNumQuestWatches, GetNumWorldQuestWatches = C_QuestLog.GetNumQuestWatches, C_QuestLog.GetNumWorldQuestWatches
	local GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
	local GetQuestIDForQuestWatchIndex, GetQuestIDForWorldQuestWatchIndex = C_QuestLog.GetQuestIDForQuestWatchIndex, C_QuestLog.GetQuestIDForWorldQuestWatchIndex
	local GetQuestWatchType = C_QuestLog.GetQuestWatchType
	local AddQuestWatch, RemoveQuestWatch = C_QuestLog.AddQuestWatch, C_QuestLog.RemoveQuestWatch
	local AddWorldQuestWatch, RemoveWorldQuestWatch = C_QuestLog.AddWorldQuestWatch, C_QuestLog.RemoveWorldQuestWatch
	local GetBestMapForUnit, GetQuestsOnMap = C_Map.GetBestMapForUnit, C_QuestLog.GetQuestsOnMap


	local reasons = { mplus = false, raid = false, rp = false, arena = false, pvp = false, combat = false, }
	hiuiDB.trackedQuests, hiuiDB.trackedWorldQuests = hiuiDB.trackedQuests or {}, hiuiDB.trackedWorldQuests or {}
	local trackedQuests, trackedWorldQuests = hiuiDB.trackedQuests, hiuiDB.trackedWorldQuests
	local thisZone = {}

	--[[	Quest Hider
	The primary quest hiding function. Will hide all your tracked
	quests and store them for later. If you provide a reason, that
	reason will be stored in the reasons and your quests won't be
	shown until ALL reasons for hiding are false.
	--]]
	local function hideQuests(reason)
		if InCombatLockdown() then
			if reason then
				reasons.combatLockdownHide = reason
			end
			After(1, hideQuests)
			return
		elseif reasons.combatLockdownHide then -- ran from After()
			reason = reasons.combatLockdownHide
			reasons.combatLockdownHide = nil
		end

		if reason then
			reasons[reason] = true
			if reason ~= "combat" then
				msg('hideQuests() for "' .. reason .. '."', true)
			end
		end

		--[[ During combat reason, don't untrack quests from current area. --]]
		if reason == "combat" then
			local map = GetBestMapForUnit("player")
			--print("Your map id: " .. map .. ".")

			if map then
				local mapQuests = GetQuestsOnMap(map)
				for _, v in ipairs(mapQuests) do
					thisZone[v.questID] = true
					--print("Quest in zone so not hiding: " .. v.questID)
				end
			end
			-- Seem to be already taken care of by GQOM() above
			--local worldQuests = C_TaskQuest.GetQuestsForPlayerByMapID(map)
			--for i, v in ipairs(worldQuests) do
			--	if v.inProgress then
			--		thisZone[v.questId] = true
			--		print("World quest in progress: " .. v.questId)
			--	end
			--end
		end

		--[[ Incrementing 1+ fails because after RemoveQuestWatch(1), index 2 becomes index 1, so running RemoveQuestWatch(2) removes what was previously index 3. As well, `while GetNumQuestWatches() > 0` is low performance, even with local reference. --]]
		for i = GetNumQuestWatches(), 1, -1  do
			local qID = GetQuestIDForQuestWatchIndex(i)
			--print("Got quest id " .. (qID or "none") .. " from watched quests.")
			if not (thisZone and thisZone[qID]) then
				local logIndex = GetLogIndexForQuestID(qID) -- filters out headers (needed?)
				if logIndex then
					local qInf = GetInfo(logIndex)
					--print(qInf.title)
					--print(qInf.hasLocalPOI)
					--print(qInf.isOnMap)
					--print()
					if not qInf.hasLocalPOI and not qInf.isHidden then
						trackedQuests[qID] = GetQuestWatchType(qID)
						RemoveQuestWatch(qID)
					end
				end
			end
		end

		for i = GetNumWorldQuestWatches(), 1, -1 do
			local qID = GetQuestIDForWorldQuestWatchIndex(i)
			--print("Got world quest id " .. (qID or "none") .. " from watched quests.")
			if qID and not (thisZone and thisZone[qID]) then
				trackedWorldQuests[qID] = GetQuestWatchType(qID)
				RemoveWorldQuestWatch(qID)
			end
		end
	end
	hiui.hideQuests = hideQuests



	--[[ showQuests()
	showQuests, when provided with a reason, will toggle off hiding 
	quests for that particular reason. Afterwards, if there's no
	reason for hiding the quest any longer, it'll show all the quests
	that are hidden and empty the hidden quest tracker.

	Currently, the provided way to show all quests regardless of reason
	is to pass "all" as your reason for showing. This will clear all
	the hiding reasons, and thus show all your quests.
	--]]
	local function showQuests(reason)
		if InCombatLockdown() then
			if reason then
				reasons.combatLockdownShow = reason
			end
			After(1, showQuests)
			return
		elseif reasons.combatLockdownShow then -- ran from After()
			reason = reasons.combatLockdownShow
			reasons.combatLockdownShow = nil
		end

		if reason == "all" then
			for k, _ in pairs(reasons) do
				reasons[k] = false
			end
		elseif reason then
			reasons[reason] = false
		end

		for k, v in pairs(reasons) do	-- any reason for hiding still
			--msg("Reason for showing - " .. k .. ": " .. tostring(v), true)
			if v then return end		-- being true means skip showing.
		end

		for qID, _ in pairs(trackedQuests) do
			if GetLogIndexForQuestID(qID) then
				AddQuestWatch(qID)
				trackedQuests[qID] = nil
			else
				msg("Tried to track " .. qID .. " but it wasn't in your log. This is not necessarily an error.", true)
			end
		end

		for qID, watchType in pairs(trackedWorldQuests) do
			AddWorldQuestWatch(qID, watchType)
			trackedWorldQuests[qID] = nil
		end

		trackedQuests, trackedWorldQuests = {}, {}
	end
	hiui.showQuests = showQuests



	local function questHider_OnEvent(self, event, ...)
		local ntq = (next(trackedQuests) == nil)
		if event == "CHALLENGE_MODE_START" and ntq then
			hideQuests("mplus")

		elseif event == "PLAYER_ENTERING_WORLD" then
			local ins = IsInInstance()
			if ntq and (ins == "raid" or ins == "pvp" or ins == "arena") then
				print("Hiding quests because entered raid/pvp/arena")
				hideQuests(ins)
			elseif not ntq and (ins == "none" or ins == "scenario" or (ins == "party" and not IsChallengeModeActive())) then
				print("Un-hiding quests because you're in the open world.")
				reasons.raid, reasons.pvp, reasons.arena, reasons.mplus = false, false, false, false
				showQuests()
			end

		elseif event == "CHALLENGE_MODE_COMPLETED" or (event == "CHALLENGE_MODE_RESET" and not IsChallengeModeActive()) then
			print("Showing quests because " .. event .. ".")
			showQuests("mplus")

		--[[ TESTING --]]
		elseif event == "PLAYER_REGEN_DISABLED"	then hideQuests("combat")
		elseif event == "PLAYER_REGEN_ENABLED" then showQuests("combat")
		end
	end



	local questHider = CreateFrame("Frame", addonName .. "QuestHidingFrame")
	--[[	Start Hiding	--]]
	questHider:RegisterEvent("CHALLENGE_MODE_START")
	--[[	Stop Hiding		--]]
	questHider:RegisterEvent("CHALLENGE_MODE_RESET")
	questHider:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	-- also PLAYER_ENTERING_WORLD into a non-instance while mplus
	--[[	Both			--]]
	questHider:RegisterEvent("PLAYER_ENTERING_WORLD")

	--[[ TESTING --]]
	questHider:RegisterEvent("PLAYER_REGEN_DISABLED")
	questHider:RegisterEvent("PLAYER_REGEN_ENABLED")

	questHider:SetScript("OnEvent", questHider_OnEvent)
	--msg((questHider:GetScript("OnEvent") and "QH has OnEvent registered successfully!" or "QH did not register OnEvent appropriately..."), true)
end



local function addonQS()

	do --[[ init --]]
		hiuiDB.QstashOn	= hiuiDB.QstashOn or 0

		function hiui.hideQuests()
			-- DEFAULT_CHAT_FRAME.editBox:SetText("/qstash hide")
			-- ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
			RunSlashCmd("/qstash hide")
		end

		function hiui.showQuests()
			-- DEFAULT_CHAT_FRAME.editBox:SetText("/qstash show")
			-- ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
			RunSlashCmd("/qstash show")
		end
	end

	if hiuiDB.QstashOn < (hiui.debugLevel or hiui.version) then

		msg("Turning Quest Stash on.")

		-- DEFAULT_CHAT_FRAME.editBox:SetText("/qstash on")
		-- ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
		RunSlashCmd("/qstash on")

		hiuiDB.QstashOn = hiui.version

	end

end


if hiui.todo.QuestStash then
	hiui.run.QuestStash = addonQS
else
	hiui.todo.QuestStash = true
	hiui.run.QuestStash = localQS
	msg("Using local Quest Stash. Disable or remove the addon \"queststash\".")
end
