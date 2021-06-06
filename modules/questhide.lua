-- On login...
-- Collapse quest tracker in major city (and show when leaving)
-- Hide quests not in zone.

--[[    Header
In this opening block, only the name of the addon, version, info and dependencies needs to be changed.
Dependencies are mod names that you require to be enabled for this mod to load. You should use the folder name exactly.
Module information will be displayed on the main hiui page.
The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Quest Hider", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0", "AceConsole-3.0")
mod.modName, mod.version = name, version
mod.info = "Hide quests that aren't relevant - Out of zone quests while in combat; all quests when in M+ or raid encounter."
mod.depends = {}

--[[ A temporary table until we can establish clear "modes" that the player is in --]]
local reasons = { mplus = false, raid = false, rp = false, arena = false, pvp = false, combat = false, }

--[[ Imports
Global imports are not NEARLY as much of a speed improvement as people think, but this code is going to run in the open world, as the enter and leave combat, so even little performance boosts may help.
--]]
local After = C_Timer.After
local GetBestMapForUnit, GetQuestsOnMap = C_Map.GetBestMapForUnit, C_QuestLog.GetQuestsOnMap
local GetNumQuestWatches, GetNumWorldQuestWatches = C_QuestLog.GetNumQuestWatches, C_QuestLog.GetNumWorldQuestWatches
local GetQuestIDForQuestWatchIndex = C_QuestLog.GetQuestIDForQuestWatchIndex
local GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local GetInfo = C_QuestLog.GetInfo
local GetQuestWatchType = C_QuestLog.GetQuestWatchType
local AddQuestWatch, RemoveQuestWatch = C_QuestLog.AddQuestWatch, C_QuestLog.RemoveQuestWatch
local GetQuestIDForWorldQuestWatchIndex = C_QuestLog.GetQuestIDForWorldQuestWatchIndex
local AddWorldQuestWatch, RemoveWorldQuestWatch = C_QuestLog.AddWorldQuestWatch, C_QuestLog.RemoveWorldQuestWatch
local IsChallengeModeActive = C_ChallengeMode.IsChallengeModeActive

--[[    Database Access
Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
mod.db.global, mod.db.profile, mod.db.char
--]]
local global, profile, char
local trackedQuests, trackedWorldQuests, thisZone

--[[ Delay quest showing --]]
--[[
    leftCombat = time()
    if global.debug then mod:Print("Setting 3 second timer for leaving combat: " .. leftCombat) end

    C_Timer.After(3.1, function()
        local cTime = time()
        if cTime - leftCombat >= 3 and not InCombatLockdown() then
            if global.debug then mod:Print("Successfully reset chat width.") end
            ChatFrame1:SetWidth(profile.width.ooc)
            ChatFrame1.timeVisibleSecs = 120
        elseif global.debug then
            mod:Print("Not resetting chat frame width due to combat or timer. Timers: " .. cTime .. ", " .. leftCombat)
        end -- if this fails, its because we left [a second] combat recently, so leftCombat is too big.
    end)    -- but that also means there's a second After() running that will clean up later.
--]]

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
            mod:Print('hideQuests() for "' .. reason .. '."', true)
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
        -- Seem to be already taken care of by GetQuestsOnMap() above
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

--[[    Quest Un-hiding
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
            mod:Print("Tried to track " .. qID .. " but it wasn't in your log. This is not necessarily an error.")
        end
    end

    for qID, watchType in pairs(trackedWorldQuests) do
        AddWorldQuestWatch(qID, watchType)
        trackedWorldQuests[qID] = nil
    end

    trackedQuests, trackedWorldQuests = {}, {}
end

local leftCombat
local function questHider_OnEvent(event, ...)
    local ntq = (next(trackedQuests) == nil)
    if event == "CHALLENGE_MODE_START" and ntq then
        hideQuests("mplus")

    elseif event == "PLAYER_ENTERING_WORLD" then
        local ins = IsInInstance()
        if ntq and (ins == "raid" or ins == "pvp" or ins == "arena") then
            if global.debug then mod:Print("Hiding quests because entered raid/pvp/arena") end
            hideQuests(ins)
        elseif not ntq and (ins == "none" or ins == "scenario" or (ins == "party" and not IsChallengeModeActive())) then
            if global.debug then mod:Print("Un-hiding quests because you're in the open world.") end
            reasons.raid, reasons.pvp, reasons.arena, reasons.mplus = false, false, false, false
            showQuests()
        end

    elseif event == "CHALLENGE_MODE_COMPLETED" or (event == "CHALLENGE_MODE_RESET" and not IsChallengeModeActive()) then
        if global.debug then mod:Print("Showing quests because " .. event .. ".") end
        showQuests("mplus")

    elseif event == "PLAYER_REGEN_DISABLED"	then hideQuests("combat")

    elseif event == "PLAYER_REGEN_ENABLED" then
        leftCombat = time()
        if global.debug then mod:Print("Setting 3 second left-combat timer: " .. leftCombat) end

        C_Timer.After(3.1, function()
            local cTime = time()
            if cTime - leftCombat >= 3 and not InCombatLockdown() then
                showQuests("combat")
            elseif global.debug then
                mod:Print("Not showing quests because you entered combat during the countdown. Timers: " .. cTime .. ", " .. leftCombat)
            end -- if this fails, its because we left [a second] combat recently, so leftCombat is too big.
        end)    -- but that also means there's a second After() running that will clean up later.
    end
end

--[[    Default Values
You should include at least the following:
defaults.global.debug = false
defaults.profile.enabled = false
defaults.char.initialized = false
--]]
local defaults = {
    global = {
        debug = true, -- noisy debugging
    },
    profile = {
        enabled = false, -- have root addon enable?
        enable_quest_hiding = true,
        hide_nonzone_quests_during_combat = false,
    },
    char = {
        initialized = 0, -- used for first time load
        trackedQuests = {},
        trackedWorldQuests = {},
        thisZone = {},
    },
}

--[[    "Features" local variable
Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
Remember to set/change db values during these functions.
--]]
local features = {
	enable_quest_hiding = function(value)
        if value then
            if global.debug then mod:Print("Enabling quest hiding.") end
            mod:RegisterEvent("CHALLENGE_MODE_START", questHider_OnEvent)
            mod:RegisterEvent("CHALLENGE_MODE_RESET", questHider_OnEvent)
            mod:RegisterEvent("CHALLENGE_MODE_COMPLETED", questHider_OnEvent)
            mod:RegisterEvent("PLAYER_ENTERING_WORLD", questHider_OnEvent)
        else
            if global.debug then mod:Print("Disabling quest hiding.") end
            mod:UnregisterEvent("CHALLENGE_MODE_START")
            mod:UnregisterEvent("CHALLENGE_MODE_RESET")
            mod:UnregisterEvent("CHALLENGE_MODE_COMPLETED")
            mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
	end,

    hide_nonzone_quests_during_combat = function(value)
        if value then
        if global.debug then mod:Print("Enabling quest hiding for combat.") end
            mod:RegisterEvent("PLAYER_REGEN_DISABLED", questHider_OnEvent)
            mod:RegisterEvent("PLAYER_REGEN_ENABLED", questHider_OnEvent)
        else
            if global.debug then mod:Print("Disabling quest hiding for combat.") end
            mod:UnregisterEvent("PLAYER_REGEN_DISABLED")
            mod:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
    end,
}

--[[    GUI Options Menu
Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
--]]
local options = {
    name = " " .. name,
    type = "group",
    args = {
        enable = {
            order = 0,
            name = "Enable " .. name,
            desc = "Check to enable this module.",
            type = "toggle",
            set = function(_, value)
                profile.enabled = value
                if value then
                    mod:Enable()
                else
                    mod:Disable()
                end
            end,
            get = function() return profile.enabled end,
        },
        debug = {
            order = 1,
            name = "Noisy debugging",
            desc = "Print lots of text to the chatbox.",
            type = "toggle",
            set = function(_, value) global.debug = value end,
            get = function() return global.debug end,
        },
        disabledWarning = {
            order = 2,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        enable_quest_hiding = {
            order = 3,
			name = "Enable Relevant Quest Hiding",
			desc = "Hide quests that are out of zone when you enter combat, and hide all quests when entering M+.",
			type = "toggle",
			set = function(_, value)
                profile.enable_quest_hiding = value
                features.enable_quest_hiding(value)
            end,
            get = function() return profile.enable_quest_hiding end,
		},
        hide_nonzone_quests_during_combat = {
            order = 4,
            name = "Hide out-of-zone quests during combat",
            type = "toggle",
            set = function(_, value)
                profile.hide_nonzone_quests_during_combat = value
                features.hide_nonzone_quests_during_combat(value)
            end,
            get = function() return profile.hide_nonzone_quests_during_combat end,
        }
    },
}

--[[    Option Page Show
Removes the disabled state of each option. Also hides the disabled warning. Do not modify.
--]]
local function enableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if v.disabled then v.disabled = false end
    end
    optionsTable.args.disabledWarning.hidden = true
end

--[[    Option Page Hide
Grays out the options when you disable the addon. Also hides the disabled warning. Do not modify.
--]]
local function disableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if k ~= "enable" and k ~= "disabledWarning" then
            v.disabled = true
        end
    end
    optionsTable.args.disabledWarning.hidden = false
end

function mod:OnInitialize()
    --[[ data initialization. do not modify. --]]
    self.db = Hiui.db:RegisterNamespace(name, defaults)
    global, profile, char = self.db.global, self.db.profile, self.db.char

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ QuestStash will handle this if you have it. --]]
    if IsAddOnLoaded("QuestStash") then
        if global.debug then self:Print("You are using the addon \"QuestStash\" so our quest stashing feature will be disabled.") end
        RunSlashCmd("/qstash on")
        profile.enabled = false
    end

    --[[ Gray out args. do not modify. --]]
    if not profile.enabled then disableArgs(options) end

    --[[ Module specific on-load routines go here. --]]
    trackedQuests, trackedWorldQuests, thisZone = char.trackedQuests, char.trackedWorldQuests, char.thisZone
end

function mod:OnEnable()
    --[[ For combat-unsafe mods. --]]
    if InCombatLockdown() then
        return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
    end
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")

    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]
	if char.initialized < mod.version then
		for _, feature in pairs(features) do
			feature()
		end
		char.initialized = mod.version
	end

    --[[ Module specific on-run routines go here. --]]
    features.enable_quest_hiding(profile.enable_quest_hiding)
    features.hide_nonzone_quests_during_combat(profile.hide_nonzone_quests_during_combat)
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    self:UnregisterAllEvents()
end
