﻿--// PossessBar //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		PossessButton1:ClearAllPoints()
		PossessButton1:SetPoint(LolzenUIcfg["actionbar_pb_anchor1"], LolzenUIcfg["actionbar_pb_parent"], LolzenUIcfg["actionbar_pb_anchor2"], LolzenUIcfg["actionbar_pb_posx"], LolzenUIcfg["actionbar_pb_posy"])

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local pb = _G["PossessButton"..i]
			if pb then
				pb:SetSize(LolzenUIcfg["actionbar_button_size"], LolzenUIcfg["actionbar_button_size"])
			end
		end
		modded = true
	end
end)