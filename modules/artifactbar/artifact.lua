﻿--// artifactbar // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["artifactbar"] == false then return end

		-- first let us create our bar
		local afbar = CreateFrame("StatusBar", "bar4artifactpower", UIParent)
		afbar:SetPoint(LolzenUIcfg["artifactbar_anchor"], LolzenUIcfg["artifactbar_parent"], LolzenUIcfg["artifactbar_posx"], LolzenUIcfg["artifactbar_posy"])
		afbar:SetHeight(LolzenUIcfg["artifactbar_height"])
		afbar:SetWidth(LolzenUIcfg["artifactbar_width"])
		afbar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["artifactbar_texture"])
		afbar:SetAlpha(LolzenUIcfg["artifactbar_alpha"])
		afbar:SetStatusBarColor(unpack(LolzenUIcfg["artifactbar_color"]))
		afbar:SetFrameStrata("BACKGROUND")

		--Background for our bar
		local bg = afbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(afbar)
		bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["artifactbar_texture"])
		bg:SetVertexColor(0, 0, 0, LolzenUIcfg["artifactbar_bg_alpha"])

		--1px "border"
		if LolzenUIcfg["artifactbar_1px_border"] == true then
			local lines = {}
			for i = 1, 4 do
				if not lines[i] then
					lines[i] = afbar:CreateTexture(nil, "OVERLAY")
					lines[i]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
					lines[i]:SetVertexColor(0, 0, 0, 1)
				end
				if i == 1 then
					lines[i]:SetHeight(1)
					lines[i]:SetPoint("TOPLEFT", afbar, 0, 1)
					lines[i]:SetPoint("TOPRIGHT", afbar, 0, 1)
				elseif i == 2 then
					lines[i]:SetHeight(1)
					lines[i]:SetPoint("BOTTOMLEFT", afbar, 0, -1)
					lines[i]:SetPoint("BOTTOMRIGHT", afbar, 0, -1)
				elseif i == 3 then
					lines[i]:SetWidth(1)
					if LolzenUIcfg["artifactbar_1px_border_round"] == true then
						lines[i]:SetPoint("TOPLEFT", afbar, -1, 0)
						lines[i]:SetPoint("BOTTOMLEFT", afbar, -1, 0)
					else
						lines[i]:SetPoint("TOPLEFT", afbar, 0, 0)
						lines[i]:SetPoint("BOTTOMLEFT", afbar, 0, 0)
					end
				elseif i == 4 then
					lines[i]:SetWidth(1)
					if LolzenUIcfg["artifactbar_1px_border_round"] == true then
						lines[i]:SetPoint("TOPRIGHT", afbar, 1, 0)
						lines[i]:SetPoint("BOTTOMRIGHT", afbar, 1, 0)
					else
						lines[i]:SetPoint("TOPRIGHT", afbar, 0, 0)
						lines[i]:SetPoint("BOTTOMRIGHT", afbar, 0, 0)
					end
				end
			end
		end

		-- fontstring
		local xptext = afbar:CreateFontString(nil, "OVERLAY")
		xptext:SetPoint(LolzenUIcfg["artifactbar_text_anchor1"], afbar, LolzenUIcfg["artifactbar_text_anchor2"], LolzenUIcfg["artifactbar_text_posx"], LolzenUIcfg["artifactbar_text_posy"])
		xptext:SetParent(UIParent)
		xptext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg["artifactbar_font"], LolzenUIcfg["artifactbar_font_size"], LolzenUIcfg["artifactbar_font_flag"])
		xptext:SetTextColor(unpack(LolzenUIcfg["artifactbar_font_color"]))

		-- get artifact power data
		function afbar:ARTIFACT_XP_UPDATE()
			local hasArtifact = HasArtifactEquipped("player")
			if hasArtifact then
				local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
				local numPoints, artifactXP, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
				afbar:SetMinMaxValues(0, xpForNextPoint)
				afbar:SetValue(artifactXP)
				afbar:SetAlpha(LolzenUIcfg["artifactbar_alpha"])
				-- use tostring to prevent integer overflow
				xptext:SetFormattedText("%s / %s (%.0f%%)", tostring(artifactXP), tostring(xpForNextPoint), tostring(artifactXP/xpForNextPoint*100) )
			else
				afbar:SetAlpha(0)
			end
		end
		afbar.PLAYER_ENTERING_WORLD = afbar.ARTIFACT_XP_UPDATE
		afbar.UNIT_INVENTORY_CHANGED = afbar.ARTIFACT_XP_UPDATE

		afbar:RegisterEvent("ARTIFACT_XP_UPDATE")
		afbar:RegisterEvent("UNIT_INVENTORY_CHANGED")
		afbar:RegisterEvent("PLAYER_ENTERING_WORLD")
		afbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	end
end)
