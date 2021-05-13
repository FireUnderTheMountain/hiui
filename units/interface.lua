local addonName, hiui = ...
local msg = hiui.sysMsg
hiui.todo.InterfaceOptions = true


function hiui.run.InterfaceOptions()
	do -- init
		hiuiDB.InterfaceOptions	= hiuiDB.InterfaceOptions or 0
		hiuiDB.Tracking = hiuiDB.Tracking or 0
	end

	local debugthis = false

	if debugthis or hiuiDB.InterfaceOptions < (hiui.debugLevel or hiui.version) then

		msg("Applying standard new character adjustments.")

		-- Advanced Interface Options
		--Fade Map When Moving
		--Secure ability toggle
		--No debuff filter on target (irrelevant?)
		--Quest sorting mode, proximity
		--max cam distance (LTP?)
		--- Chat
		--Remove chat hover delay
		--mouse wheel scroll chat
		---Combat
		--stop auto attack on target switch
		--attack on assist
		--action on key down (default yes, don't touch)
		--lag tolerance, default 400ms
		---Floating Combat Text
		--?
		---Nameplates
		--nothing

		hiuiDB.InterfaceOptions = hiui.version
	end

	if debugthis or hiuiDB.Tracking < (hiui.debugLevel or hiui.version) then
		--Tracking
		-- target
		-- focus
	end

	do -- disable unused addons
		if IsAddOnLoaded("AdvancedInterfaceOptions") then
			msg("You can delete the AdvancedInterfaceOptions addon.", true)
		end

		if IsAddOnLoaded("AAP-Core") then
			msg("You can delete the Azeroth Auto Pilot Addon.", true)
			hiui.todo.AAP = false
			hiui.todo.AapAndKaliels = false
		end

		if IsAddOnLoaded("!KalielsTracker") then
			msg("You can delete the Kaliel's Tracker Addon.", true)
			hiui.todo.AapAndKaliels = false
		end

		if IsAddOnLoaded("QuestStash") then
			msg("You can delete the Quest Stash Addon.", true)
		end

		if IsAddOnLoaded("XLoot_Frame") then
			msg("You can disable XLoot Frame addon.", true)
		end

		if IsAddOnLoaded("XLoot_Group") then
			msg("You can disable XLoot Group addon.", true)
		end

		if IsAddOnLoaded("XLoot_Master") then
			msg("You can disable XLoot Master addon.", true)
		end

	end

end