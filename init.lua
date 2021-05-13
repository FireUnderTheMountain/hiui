--[[
	Hiui tweaks some character settings on log in.
--]]
local addonName, hiui = ...

--[[
	DEBUG MODE:
	Set debug to non-nil value for debugging.
--]]
--hiui.debugLevel = 0		-- debug
--hiui.debugLevel = nil		-- no debugging
-- absent					-- also no debugging

--[[
	This version number should be updated every time there's a functional change to
	the way hiui works. Increasing hiui.version will cause all units to run again.

	Each run-unit compares their own variable against hiui.version; if they're less,
	then they will be ran, and their variable updated to equal hiui.version.
--]]
hiui.version = 2

--[[
	"run" is a structure of functions that will be executed in sequence. The first
	thing you should do in your function is initialize your needed SavedVariables
	Ex:
			hiuiDB.MyAddOnRanThisVersion = hiuiDB.MyAddOnRanThisVersion or 0
	At the end of your function, you should update your SV so we know it ran.
	Ex:
			hiuiDB.MyAddOnRanThisVersion = hiui.version
--]]
hiui.run = {}

--[[
	todo is a table of bools that determine if the associated run function is executed.
	Each todo key needs to be named after the function that it runs.
	The following will run hiui.run.MyAddon():
			hiui.todo.MyAddon = true
	To make this dynamic, use:
			_, hiui.todo.MyAddon = IsAddOnLoaded("MyAddon")
	GetAddOnInfo("MyAddon") could also be useful, but we haven't needed it yet.
--]]
hiui.todo = {}


function hiui.sysMsg(msg, force)
	local debug = (hiui.debugLevel or 0) > hiui.version
	if force or debug then
		DEFAULT_CHAT_FRAME:AddMessage(addonName .. ": " .. msg)
	end
end

--[[
	Put `local msg = hiui.sysMsg` near the start of your file and you can then use
	msg("My message") to print debugging/updating messages, or
	msg("My message", true) to always print a message.
--]]
local msg = hiui.sysMsg

--[[
	If your addon needs to send chat commands (like slash commands to other addons) you should use RunSlashCmd(cmd).
	Because via our own edit box causes taint and I suck at fixing it.
--]]
-- hiui.editbox = CreateFrame("EditBox", "hiuiEditbox", UIParent, "ChatFrameEditBoxTemplate")
-- hiui.editbox:SetScript("OnLoad", function(self)
-- 	self.chatFrame = self:GetParent()
-- 	ChatEdit_OnLoad(self)
-- )
--[[
	hiui.RunSlashCmd(cmd) - Run an artibrary slash command.
	Copied from the good doggos who deserve treats at
	https://wow.gamepedia.com/RunSlashCmd
--]]
local _G = _G
local SlashCmdList = _G["SlashCmdList"]
function hiui.RunSlashCmd(cmd)
  local slash, rest = cmd:match("^(%S+)%s*(.-)$")
  for name, func in pairs(SlashCmdList) do
     local i, slashCmd = 1, nil
     repeat
        slashCmd, i = _G["SLASH_"..name..i], i + 1
        if slashCmd == slash then
           return true, func(rest)
        end
     until not slashCmd
  end
  -- Okay, so it's not a slash command. It may also be an emote.
  local i = 1
  while _G["EMOTE" .. i .. "_TOKEN"] do
     local j, cn = 2, _G["EMOTE" .. i .. "_CMD1"]
     while cn do
        if cn == slash then
           return true, DoEmote(_G["EMOTE" .. i .. "_TOKEN"], rest);
        end
        j, cn = j+1, _G["EMOTE" .. i .. "_CMD" .. j]
     end
     i = i + 1
  end
end


--[[	To add your own run unit
	Step 1: Create a new lua file in the hiui/units folder
	Step 2: Open hiui.toc:
		A) Add your lua file to hiui.toc in the others, in alphabetical order.
		B) Create a saved variable name and add it to the SavedVars line.
	Step 2: Open your lua file:
		A) Start your file with:
				local addonName, hiui = ...
				local msg = hiui.sysMsg
				_, hiui.todo.MyAddon = IsAddOnLoaded("MyAddon")
		B) Create a hiui.run.MyAddon function.
		C) Initialize your savedvar inside of it
		D) At the end of the function, update your SavedVar to hiui.version

		Ex:
			function hiui.run.MyAddon()

				do -- initialize
					hiuiDB.MyAddonSavedVar = hiuiDB.MyAddonSavedVar or 0
				end

				...

				-- all done!
				hiuiDB.MyAddonSavedVar = hiui.version
			end
--]]
