local _G = _G
local SlashCmdList = _G["SlashCmdList"]
function RunSlashCmd(cmd)
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

-- local function sysMsg(msg, force)
-- 	local debug = false
-- 	if force or debug then
-- 		DEFAULT_CHAT_FRAME:AddMessage("Hiui: " .. msg)
-- 	end
-- end

-- local locallib = {
--     sysMsg = sysMsg,
-- }
