--// buffs // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["buffs"] == false then return end

		-- Change the position
		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint(LolzenUIcfg["buff_anchor1"], LolzenUIcfg["buff_parent"], LolzenUIcfg["buff_anchor2"], LolzenUIcfg["buff_posx"], LolzenUIcfg["buff_posy"])

		local function StyleBuffs(buttonName, index)
			local button = _G[buttonName..index]
			if button and not button.modded then

				-- Size
				if buttonName == "BuffButton" then
					button:SetSize(LolzenUIcfg["buff_size"], LolzenUIcfg["buff_size"])
				elseif buttonName == "DebuffButton" then
					button:SetSize(LolzenUIcfg["buff_debuff_size"], LolzenUIcfg["buff_debuff_size"])
				elseif buttonName == "TempEnchant" then
					button:SetSize(LolzenUIcfg["buff_tempenchant_size"], LolzenUIcfg["buff_tempenchant_size"])
				end

				-- Border
				local border = _G[buttonName..index.."Border"]
				if border then
					-- Debuffborder
					border:SetParent(button)
					border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["buff_debuff_texture"])
					border:SetAllPoints(button)
					border:SetTexCoord(0, 1, 0, 1)
				else
					-- Auraborder
					if not button.border then
						button.border = button:CreateTexture(nil, "BORDER")
						button.border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["buff_aura_texture"])
						button.border:SetAllPoints(button)
						button.border:SetVertexColor(0, 0, 0)
					end
				end

				-- Change the look of the Icon slightly
				local icon = _G[buttonName..index.."Icon"]
				if icon then
					icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					icon:SetPoint("TOPLEFT", button ,"TOPLEFT", 2, -2)
					icon:SetPoint("BOTTOMRIGHT", button ,"BOTTOMRIGHT", -2, 2)
				end

				-- Reposition BuffTimeduration
				button.duration:ClearAllPoints()
				button.duration:SetPoint(LolzenUIcfg["buff_duration_anchor1"], button, LolzenUIcfg["buff_duration_anchor2"], LolzenUIcfg["buff_duration_posx"], LolzenUIcfg["buff_duration_posy"])
				button.duration:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg["buff_duration_font"], LolzenUIcfg["buff_duration_font_size"], LolzenUIcfg["buff_duration_font_flag"])
				button.duration:SetDrawLayer("OVERLAY")

				-- Reposition buffcounters
				button.count:ClearAllPoints()
				button.count:SetPoint("TOPRIGHT", button)
				button.count:SetFont("Fonts\\ARIALN.ttf", 17, "OUTLINE")
				button.count:SetDrawLayer("OVERLAY")
				
				button.modded = true
			end
		end

		local function UpdateAura()
			for i = 1, BUFF_ACTUAL_DISPLAY do
				StyleBuffs("BuffButton", i)
			end
			for i = 1, DEBUFF_MAX_DISPLAY do
				StyleBuffs("DebuffButton", i)
			end
			for i = 1, NUM_TEMP_ENCHANT_FRAMES do
				StyleBuffs("TempEnchant", i)
			end
		end

		hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateAura)
		hooksecurefunc("DebuffButton_UpdateAnchors", UpdateAura)

		if LolzenUIcfg["buff_duration_detailed"] == true then
			-- Change the timer
			SecondsToTimeAbbrev = function(time)
				local hr, m, s, text
				if time <= 0 then 
					text = ""
				elseif(time < 3600 and time > 40) then
					m = floor(time / 60)
					s = mod(time, 60)
					text = (m == 0 and format("|cffffffff%d", s)) or format("|cffffffff%d:%02d", m, s)
				elseif time < 60 then
					m = floor(time / 60)
					s = mod(time, 60)
					text = (m == 0 and format("|cffffffff%d", s))
				else
					hr = floor(time / 3600)
					m = floor(mod(time, 3600) / 60)
					text = format("%d:%2d", hr, m)
				end
				return text
			end
		end
	end
end)