local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.ChatPosition = true
hiui.todo.ChatButtons = false
hiui.todo.ChatMessages = true


local DEBUG_THIS_SECTION = true

local MCF = _G["ChatFrame1"]
--local MCFBF = _G["ChatFrame1ButtonFrame"]
local MCFT = _G["ChatFrame1Tab"]
local FCF_OpenNewWindow = _G["FCF_OpenNewWindow"]
local ChatFrame_RemoveAllMessageGroups = _G["ChatFrame_RemoveAllMessageGroups"]
local ChatFrame_RemoveAllChannels = _G["ChatFrame_RemoveAllChannels"]
local ChatFrame_AddMessageGroup = _G["ChatFrame_AddMessageGroup"]

function hiui.run.ChatPosition()

	do	-- init
		hiuiDB.ChatCornered	= hiuiDB.ChatCornered or 0
		--hiuiDB.ChatCornered = 0

		local uiWidth = UIParent:GetWidth()

		-- Arbitrary magic numbers based on pencil sketch
		hiui.ChatWidthOOCMagic = uiWidth/4
		hiui.ChatWidthICMagic = uiWidth*10/54.352
		hiui.ChatHeightOOCMagic = UIParent:GetHeight()*10/36
	end


	if hiuiDB.ChatCornered < (hiui.debugLevel or hiui.version) then

		msg("Repositioning chatframe from version " .. hiuiDB.ChatCornered, true)
		-- Two ways to unlock the chat window.
		--SetChatWindowLocked(1, 0)
		--chat.isLocked = false

		MCF:StartMoving()
		MCF:ClearAllPoints()
		MCF:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 35, 23)
		MCF:SetWidth(hiui.ChatWidthOOCMagic)
		MCF:SetHeight(hiui.ChatHeightOOCMagic)
		MCF:StopMovingOrSizing()

		--[[ Removed, pending confirmation StopMovingOrSizing() causes docked frame repositon. --]]
		--MCFBF:StartMoving()
		--MCFBF:ClearAllPoints()
		--MCFBF:SetPoint("TOPRIGHT", ChatFrame1Background, "TOPLEFT", -3, -3)
		--MCFBF:SetPoint("BOTTOMRIGHT", ChatFrame1Background, "BOTTOMLEFT", -3, 6)
		--MCFBF:StopMovingOrSizing()

		-- Three ways to lock the chat window
		--SetChatWindowLocked(1, 1)
		--MCF.isLocked = true
		--MCF:SetUserPlaced(true)

		SetChatWindowColor(1, 0, 0, 0)
		SetChatWindowAlpha(1, 0)

		MCF.buttonSide = "left" -- does not appear to function
		-- these don't apply changes from variables, rip
		--MCF:RefreshDisplay()
		--MCF:RefreshLayout()
		-- RefreshIfNecessary ?

		hiuiDB.ChatCornered = hiui.version

	end

	local bitt, target, anchor, left, bot = MCF:GetPoint(1)
	if (not (left or bot)) or (left > 35.1 or left < 34.9) or (bot > 23.1 or bot < 22.9) then
		msg("Chat frame is not cornered. If you think this is in error, report this.", true)
		msg("Debug: " .. (bitt or "No point") .. " to " .. (target:GetName() or "no frame") .. " " .. (anchor or "no anchor"), true)
		hiuiDB.ChatCornered = hiuiDB.ChatCornered - 1
		C_Timer.After(0.35, hiui.run.ChatPosition)
	end

end

function hiui.run.ChatButtons()
	-- Reparent all chat frame buttons because its old parent is off screen.
	-- The button frame names are: QuickJoinToastButton, ChatFrameChannelButton, ???, ???, ChatFrameMenuButton
	-- Reorder them to: Quick Join, Chat Menu, Channels, then the other two.

	do	-- init
		hiuiDB.ChatButtonsReparented = hiuiDB.ChatButtonsReparented or 0
	end

	if hiuiDB.ChatButtonsReparented < (hiui.debugLevel or hiui.version) then
		msg("Reparenting chat buttons to a space on screen.")


		--The Toast button repositions itself on every bnet toast display. RIP
		--QuickJoinToastButton:ClearAllPoints()
		--QuickJoinToastButton:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 0)
		local ChatFrameMenuButton = _G["ChatFrameMenuButton"]
		local ChatFrameChannelButton = _G["ChatFrameChannelButton"]
		local QuickJoinToastButton = _G["QuickJoinToastButton"]

		ChatFrameMenuButton:ClearAllPoints()
		--ChatFrameMenuButton:SetPoint("BOTTOMLEFT", QuickJoinToastButton, "BOTTOMRIGHT", 0, 0)
		ChatFrameMenuButton:SetPoint("BOTTOMLEFT", MCFT, "TOPLEFT", 0, 0)

		ChatFrameChannelButton:ClearAllPoints()
		ChatFrameChannelButton:SetPoint("LEFT", ChatFrameMenuButton, "RIGHT", 0, 0)

		QuickJoinToastButton.Toast:ClearAllPoints()
		QuickJoinToastButton.Toast:SetPoint("BOTTOMLEFT", ChatFrameMenuButton, "TOPLEFT", 0, 0)
		QuickJoinToastButton.Toast2:ClearAllPoints()
		QuickJoinToastButton.Toast2:SetPoint("BOTTOMLEFT", ChatFrameMenuButton, "TOPLEFT", 0, 0)


		hiuiDB.ChatButtonsReparented = hiui.version

	end
end

function hiui.run.ChatMessages()

	do	-- init
		hiuiDB.TrashChatTabCreated = hiuiDB.TrashChatTabCreated or 0
		hiuiDB.MainChatCleaned = hiuiDB.MainChatCleaned or 0
	end

	if hiuiDB.TrashChatTabCreated < (hiui.debugLevel or hiui.version) then

		local NEW_CHAT_FRAME_NAME = ".,"

		-- Get chatframe index by name
		-- if chatframe index is a value, don't create a new chatframe.
		local trashTab = nil
		local trashTabId = nil
		local NUM_CHAT_WINDOWS = _G["NUM_CHAT_WINDOWS"] or 9
		msg("Polling chat windows 2 through " .. NUM_CHAT_WINDOWS .. ".")
		for i = 2, NUM_CHAT_WINDOWS do

			msg("Polling chat frame " .. i .. ".")

			local name = GetChatWindowInfo(i)
			if name == NEW_CHAT_FRAME_NAME then

				trashTab = _G["ChatFrame" .. i]
				trashTabId = i

				msg("Found existing trash tab.")

				break

			end

		end

		trashTab = trashTab or FCF_OpenNewWindow(NEW_CHAT_FRAME_NAME)
		trashTabId = trashTabId or NUM_CHAT_WINDOWS

		msg("Removing all messages and channels from trash tab.")

		ChatFrame_RemoveAllMessageGroups(trashTab)
		ChatFrame_RemoveAllChannels(trashTab)

		msg("Adding relevant messages to trash tab.")

		-- is this not just AddChatWindowMessages()?
		-- No. This one actually works.
		ChatFrame_AddMessageGroup(trashTab, "SKILL")
		ChatFrame_AddMessageGroup(trashTab, "LOOT")
		ChatFrame_AddMessageGroup(trashTab, "CURRENCY")
		ChatFrame_AddMessageGroup(trashTab, "MONEY")
		ChatFrame_AddMessageGroup(trashTab, "COMBAT_XP_GAIN")
		ChatFrame_AddMessageGroup(trashTab, "COMBAT_HONOR_GAIN")
		ChatFrame_AddMessageGroup(trashTab, "ACHIEVEMENT")
		ChatFrame_AddMessageGroup(trashTab, "GUILD_ITEM_LOOTED")

		hiuiDB.TrashChatTabCreated = hiui.version

	end

	if hiuiDB.MainChatCleaned < (hiui.debugLevel or hiui.version) and
	   hiuiDB.TrashChatTabCreated == hiui.version then

	   	msg("Chat frame exists, cleaning up primary chat frame.")

		AddChatWindowMessages(1, "TARGETICONS")

		RemoveChatWindowMessages(1, "SKILL")
		RemoveChatWindowMessages(1, "LOOT")
		RemoveChatWindowMessages(1, "CURRENCY")
		RemoveChatWindowMessages(1, "MONEY")
		RemoveChatWindowMessages(1, "COMBAT_XP_GAIN")
		RemoveChatWindowMessages(1, "COMBAT_HONOR_GAIN")
		RemoveChatWindowMessages(1, "ACHIEVEMENT")
		RemoveChatWindowMessages(1, "GUILD_ITEM_LOOTED")
		
		hiuiDB.MainChatCleaned = hiui.version

	end

end

function hiui.CompressChat(trufe)

	if trufe then

		MCF:SetWidth(hiui.ChatWidthICMagic)
		MCF.timeVisibleSecs = 10

	else

		MCF:SetWidth(hiui.ChatWidthOOCMagic)
		MCF.timeVisibleSecs = 120

	end

end
