﻿--// MultiBarRight //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbr = _G["MultiBarRightButton"..i]
			mbr:SetSize(LolzenUIcfg["actionbar_button_size"], LolzenUIcfg["actionbar_button_size"])
			if i == 1 then
				mbr:ClearAllPoints()
				mbr:SetPoint(LolzenUIcfg["actionbar_mbr_anchor1"], LolzenUIcfg["actionbar_mbr_parent"], LolzenUIcfg["actionbar_mbr_anchor2"], LolzenUIcfg["actionbar_mbr_posx"], LolzenUIcfg["actionbar_mbr_posy"])
			else
				mbr:ClearAllPoints()
				mbr:SetPoint("BOTTOM", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, - LolzenUIcfg["actionbar_button_size"] - LolzenUIcfg["actionbar_button_spacing"])
			end
		end
		modded = true
	end
end)