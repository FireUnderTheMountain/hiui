local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.questFrame = (not select(2, IsAddOnLoaded("!KalielsTracker")))


function hiui.run.questFrame()

    do -- init
        -- delay til after we run hiui.run.questStash()
        if not hiui.hideQuests then
            C_Timer.After(1, hiui.run.questFrame)
            return
        end
    end

    -- track minimap top or bottom for frame attachment?

    --local otf = _G['ObjectiveTrackerFrame']
    local otf = _G["ObjectiveTrackerFrame"]
    local Minimap = _G["Minimap"]
    local width, height = 160, 521
    local moving

    --[[ Class color headers:"ZoneName" "World Quests" "Dungeons"
    local _, class = UnitClass("player")
    local color = RAID_CLASS_COLORS[class]
    OBJECTIVE_TRACKER_COLOR.Header = {r = color.r, g = color.g, b = color.b}
    OBJECTIVE_TRACKER_COLOR.HeaderHighlight = {r = color.r*1.2, g = color.g*1.2, b = color.b*1.2}
    --]]

    hooksecurefunc(otf, 'SetPoint', function(self)
        if moving then return end
        moving = true
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:ClearAllPoints()
        --self:SetPoint("TOPLEFT", questWrapper)
        --self:SetPoint("TOPRIGHT", questWrapper)
        --self:SetParent(questWrapper)
        --self:SetPoint('TOPRIGHT', UIParent, -45, -200)
        self:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", -40, 8)
        self:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 40, 8)
        --[[ This sets otfBlocksFrame.QuestHeader left and right to 1456.66 and 1691.66
            while minimap left and right is 1466.66 and 1666.66 --]]

        self:SetHeight(height)
        self:SetMovable(false)
        moving = nil

        msg("Quest frame hook ran.", true)
    end)

    --[[
    Do we uhhhhhhh, move these to questhider?
    --]]
    local function bossing()
        -- if UnitExists("boss1") then return true end
        return UnitExists("boss1")
    end

    local function arenaing()
        -- if UnitExists("arena1") then return true end
        return UnitExists("arena1")
    end

    local function pvping()
        return C_PvP.GetActiveMatchState() ~= Enum.PvPMatchState.Inactive
        -- if C_PvP.GetActiveMatchState() ~= Enum.PvPMatchState.Inactive then
        --     return true
        -- end
    end

    --[[    ObjectiveTracker_Collapse() and ObjectiveTracker_Expand()
    are the functions we want to use to grow and shrink the tracker.
    --]]
end
