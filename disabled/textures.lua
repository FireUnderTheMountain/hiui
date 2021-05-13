local addonName, hiui = ...

local msg = hiui.sysMsg

hiui.textures = {}


function hiui.MakeFocusFrame(mom)

	msg("Making FocusFrame texture.")

	local tex = mom:CreateTexture("HiuiFocus", "ARTWORK", nil, 1)
	
	tex:SetTexture("Interface\\AddOns\\Hiui\\Textures\\focus.tga")

	tex:ClearAllPoints()
	tex:SetPoint("BOTTOM", "UIParent", "CENTER")

	return tex

end

function hiui.MakePlayerFrame(mom)

	msg("Making Playerframe texture.")

	local tex = mom:CreateTexture("HiuiPlayer", "ARTWORK", nil, 2)
	
	tex:SetTexture("Interface\\AddOns\\Hiui\\Textures\\unitframeStandard.tga")

	tex:ClearAllPoints()
	tex:SetPoint("RIGHT", "UIParent", "CENTER")

	return tex

end

function hiui.MakeTargetFrame(mom)

	msg("Making TargetFrame texture.")

	local tex = mom:CreateTexture("HiuiTarget", "ARTWORK", nil, 2)
	
	tex:SetTexture("Interface\\AddOns\\Hiui\\Textures\\unitframeStandard.tga")

	tex:ClearAllPoints()
	tex:SetPoint("LEFT", "UIParent", "CENTER")

	return tex

end

function hiui.MakeBackground(mom)

	msg("Making Background texture.")

	local tex = mom:CreateTexture("HiuiBG", "ARTWORK", nil, 3)

	tex:SetTexture("Interface\\AddOns\\Hiui\\Textures\\topbar.tga")

	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", 0, 0)
	tex:SetSize(1366, 256)

	return tex

end

function hiui.loadAllTextures(frame)

	hiui.textures.FocusFrame = hiui.MakeFocusFrame(frame)
	hiui.textures.PlayerFrame = hiui.MakePlayerFrame(frame)
	hiui.textures.TargetFrame = hiui.MakeTargetFrame(frame)
	hiui.textures.Background = hiui.MakeBackground(frame)

end