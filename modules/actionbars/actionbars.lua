--// actionbars //--

local _, ns = ...
ns.RegisterModule("actionbars")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["actionbars"] == false then return end

		--// hide blizz art //--

		local invisible = CreateFrame("Frame", nil)
		invisible:EnableMouse(false)
		invisible:Hide()

		local BlizzArt = {
			MainMenuBarTexture0, MainMenuBarTexture1,
			MainMenuBarTexture2,MainMenuBarTexture3,
			MainMenuBarLeftEndCap, MainMenuBarRightEndCap,
			MainMenuBarPageNumber, ActionBarUpButton, ActionBarDownButton,
			CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot,
			MainMenuBarBackpackButton,
			StanceBarFrame,
			ReputationWatchBar, MainMenuExpBar, ArtifactWatchBar, HonorWatchBar,
		}

		for _, frame in pairs(BlizzArt) do
			frame:SetParent(invisible)
		end

		local MicroButtons = {
			CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
			AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, 
			PVPMicroButton, LFDMicroButton, CompanionsMicroButton,
			EJMicroButton, HelpMicroButton, MainMenuMicroButton,
			CollectionsMicroButton, StoreMicroButton,
		}

		--fix a blizz bug; thx tuller
		if not _G['AchievementMicroButton_Update'] then
			_G['AchievementMicroButton_Update'] = function() end
		end

		for _, frame in pairs(MicroButtons) do
			frame:SetParent(invisible)
			frame:Hide()
		end

		--// Bar sizes, positions & styling//--

		-- Make the MainMenuBar clickthrough, so it doesn't interfere with other frames placed at the bottom
		MainMenuBar:EnableMouse(false)

		-- Create a holder frame, which the Main Menu Bar can refer to when positioning;
		-- per default it wouldn't be centered
		local holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
		holder:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"]*12+LolzenUIcfg.actionbar["actionbar_button_spacing"]*11, LolzenUIcfg.actionbar["actionbar_button_size"])
		holder:SetPoint(LolzenUIcfg.actionbar["actionbar_mmb_anchor1"], LolzenUIcfg.actionbar["actionbar_mmb_parent"], LolzenUIcfg.actionbar["actionbar_mmb_anchor1"], LolzenUIcfg.actionbar["actionbar_mmb_posx"], LolzenUIcfg.actionbar["actionbar_mmb_posy"])
		
		local actionbars = {
			"ActionButton",
			"MultiBarBottomLeftButton",
			"MultiBarBottomRightButton",
			"MultiBarLeftButton",
			"MultiBarRightButton",
			"PetActionButton",
		}
		
		
		local function applyTheme(name)
			_G[name.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G[name.."Icon"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
			_G[name.."Icon"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)

			_G[name.."Flash"]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_flash_texture"])
			_G[name]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])
			_G[name]:SetCheckedTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_checked_texture"])
			_G[name]:SetHighlightTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_hover_texture"])
			_G[name]:SetPushedTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_pushed_texture"])

			if _G[name.."Border"] then
				_G[name.."Border"]:SetTexture(nil)
			end

			if _G[name.."Cooldown"] then
				_G[name.."Cooldown"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Cooldown"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end

			if _G[name.."HotKey"] then
				if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
					_G[name.."HotKey"]:Hide()
				end
			end

			if _G[name.."Name"] then
				_G[name.."Name"]:Hide()
			end

			if _G[name.."FloatingBG"] then
				_G[name.."FloatingBG"]:Hide()
			end

			if _G[name.."NormalTexture"] then
				_G[name.."NormalTexture"]:SetAllPoints(_G[name])
			end

			-- Autocast stuff on petbar
			if _G[name.."Shine"] then
				_G[name.."Shine"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Shine"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end
		end

		-- hide those pesky hotkeys, ffs
		hooksecurefunc("ActionButton_UpdateHotkeys", function(self, actionButtonType)
			local name = self:GetName()
			if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
				_G[name.."HotKey"]:Hide()
			end
		end)
		
		local function setActionBarPosition(name)
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G[name..i]

				if button then
					applyTheme(name..i)
					button:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
					button:ClearAllPoints()

					if i == 1 then
						if button == _G["ActionButton"..i] then
							button:SetPoint("BOTTOMLEFT", holder, 0, 0)
						elseif button == _G["MultiBarBottomLeftButton"..i] then
							button:SetPoint(LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"], LolzenUIcfg.actionbar["actionbar_mbbl_parent"], LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"], LolzenUIcfg.actionbar["actionbar_mbbl_posx"], LolzenUIcfg.actionbar["actionbar_mbbl_posy"])
						elseif button == _G["MultiBarBottomRightButton"..i] then
							button:SetPoint(LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"], LolzenUIcfg.actionbar["actionbar_mbbr_parent"], LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"], LolzenUIcfg.actionbar["actionbar_mbbr_posx"], LolzenUIcfg.actionbar["actionbar_mbbr_posy"])
						elseif button == _G["MultiBarLeftButton"..i] then
							button:SetPoint(LolzenUIcfg.actionbar["actionbar_mbl_anchor1"], LolzenUIcfg.actionbar["actionbar_mbl_parent"], LolzenUIcfg.actionbar["actionbar_mbl_anchor2"], LolzenUIcfg.actionbar["actionbar_mbl_posx"], LolzenUIcfg.actionbar["actionbar_mbl_posy"])
						elseif button == _G["MultiBarRightButton"..i] then
							button:SetPoint(LolzenUIcfg.actionbar["actionbar_mbr_anchor1"], LolzenUIcfg.actionbar["actionbar_mbr_parent"], LolzenUIcfg.actionbar["actionbar_mbr_anchor2"], LolzenUIcfg.actionbar["actionbar_mbr_posx"], LolzenUIcfg.actionbar["actionbar_mbr_posy"])
						elseif button == _G["PetActionButton"..i] then
							button:SetPoint(LolzenUIcfg.actionbar["actionbar_petb_anchor1"], LolzenUIcfg.actionbar["actionbar_petb_parent"], LolzenUIcfg.actionbar["actionbar_petb_anchor2"], LolzenUIcfg.actionbar["actionbar_petb_posx"], LolzenUIcfg.actionbar["actionbar_petb_posy"])
						end
					else
						if button == _G["ActionButton"..i] then
							button:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["MultiBarBottomLeftButton"..i] then
							button:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["MultiBarBottomRightButton"..i] then
							button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["MultiBarLeftButton"..i] then
							button:SetPoint("BOTTOM", _G["MultiBarLeftButton"..i-1], "BOTTOM", 0, - LolzenUIcfg.actionbar["actionbar_button_size"] - LolzenUIcfg.actionbar["actionbar_button_spacing"])
						elseif button == _G["MultiBarRightButton"..i] then
							button:SetPoint("BOTTOM", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, - LolzenUIcfg.actionbar["actionbar_button_size"] - LolzenUIcfg.actionbar["actionbar_button_spacing"])
						elseif button == _G["PetActionButton"..i] then
							button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						end
					end
				end
			end
		end

		for _, name in pairs(actionbars) do
			setActionBarPosition(name)
		end

		--// (re)skinning petbar on PetActionBar_Update //--
		local function applyPetBarTheme(self, i)
			local button = self..i

			_G[button]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])

			_G[button.."NormalTexture2"]:SetPoint("TOPLEFT", button, "TOPLEFT", -0, 0)
			_G[button.."NormalTexture2"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -0)

			if _G[button.."AutoCastable"] then
				_G[button.."AutoCastable"]:SetPoint("TOPLEFT", button, "TOPLEFT", -12, 12)
				_G[button.."AutoCastable"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 12, -12)
			end

		end

		local function applyThemeToPetBar()
			for i = 1, NUM_PET_ACTION_SLOTS do
				applyPetBarTheme("PetActionButton", i)
			end
		end

		hooksecurefunc("PetActionBar_Update", applyThemeToPetBar)
	end
end)