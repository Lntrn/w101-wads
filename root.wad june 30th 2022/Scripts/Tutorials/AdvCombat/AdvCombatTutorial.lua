-- AdvCombatTutorial.lua
-- Client side script that loads up the Tutorial gui and displays the dialog text allowing the user
-- to choose an item...

Include("API/WindowAnimations.lua");
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua");
Include("Tutorials/API/AdvancedTutorialUtility.lua");
Include("API/ControlClasses.lua");
Include("Tutorials/API/TutorialArrow.lua");
Include("API/Classes/Timer.lua");

MobID = nil; -- Used to store OwnerID of mob we will be dueling

function main()

-- Disable some of the game commands
   UnmapKey("ToggleQuestList");
   UnmapKey("ToggleCharStats");
   UnmapKey("ToggleMapWindow");
   UnmapKey("ToggleWorldWindow");
   UnmapKey("ToggleInventory");
   UnmapKey("DisplayBuddyList");
   UnmapKey("DisplayLogin");
   UnmapKey("ToggleDeckConfig");

   ShowTips(false);

   -- Retrieve a reference to our client tutorial object.
   clientTutorial = OpenClass(GetTutorial());
   Log("Entering Advanced Combat Tutorial");

   clientTutorial.SetTutuorialGUIState();
   TutorialDialog = TutorialDialog();
   TutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Diego_Duelmaster.dds");
   TutorialDialog:MoveToTop();

   g_GuiElements =
   {
      "btnFriends",
      "PermShopButton",
      "btnFeedback",
      "btnSpellbook",
      "btnPotions",
      "spriteHealthBkg",
      "spriteManaBkg",
      "btnRadialQuickChat",
      "btnHelpChat",
      "XPBar",
      "compassAndTeleporterButtons",
      "btnEarnCrowns",
      "TradeRequestWindow",
      "QuestHelperHud",
      "spriteEnergyBkg",
      "btnMainWebPage"
   };

   ShowGUIElements(g_GuiElements, false);

   -- If the player is in queue to play a pvp match and they elected to remain in queue, quit the tutorial
   -- They can resume it later if they return to the tutorial zone.
   if(CheckPvpStatus() == false) then
      if(TutorialDialog) then
         TutorialDialog:ShowWindow(false);
      end
      doTeleport();
      -- Terminate the script without completing the tutorial
      Kill(GetProcessID());
   end

   -- If player is wearing special gear that debuffs their mana to a critical level, they won't be able to take the tutorial
   if(IsWearingPvPEquip() == 1) then
      TutorialDialog:DoDialog("Tutorial_ManaTooLow");
      TutorialDialog:ShowWindow(false);
      doTeleport();
      -- Terminate the script without completing the tutorial
      Kill(GetProcessID());
   end

   local complete = AdvCombatTutorial();

   RestoreGUIElements(g_GuiElements);

   Sleep(3000);

   clientTutorial.UnsetTutuorialGUIState();

   ShowTips(true);

   -- Re-Enable disabled game commands
   RemapKey("ToggleQuestList");
   RemapKey("ToggleCharStats");
   RemapKey("ToggleMapWindow");
   RemapKey("ToggleWorldWindow");
   RemapKey("ToggleInventory");
   RemapKey("DisplayBuddyList");
   RemapKey("DisplayLogin");
   RemapKey("ToggleDeckConfig");

   if(complete == true) then
      RegisterEvent("OnTeleported");
      -- Teleport back to the Commons
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-013");
      clientTutorial.RequestAddQuest("WC-TUT-C09-013");

      -- Clear all old quests
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-001");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-002");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-004");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-005");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-006");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-007");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-008");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-009");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-010");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-012");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-013");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");

      GetEvent("OnTeleported");
      Sleep(2000);
      UnregisterEvent("OnTeleported");
      -- Complete the tutorial quest
      clientTutorial.RequestGoalCompletion("Tutorial_Advanced_Combat", "OnlyGoal");
   end
end


function AdvCombatTutorial()

   RegisterEvent("CombatHand");
   RegisterEvent("OnEnterCombat");
   RegisterEvent("ExecutionPhase");
   RegisterEvent("CombatCardSelected");
   RegisterEvent("CombatTargetSelected");

   RegisterEvent("OpenPlanningPhase");
   RegisterEvent("OnLeaveCombat");
   RegisterEvent("OnDOT");
   RegisterEvent("OnTeleported");
   RegisterEvent("CombatUiVisible");

   local clientTutorial = OpenClass(GetTutorial());

    -- Refill mana and health to 100% BEFORE combat starts
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
   clientTutorial.RequestAddQuest("WC-TUT-C09-014");
   clientTutorial.RequestAddQuest("WC-TUT-C09-016");

   -- Set the title
   FreezePlayer();
   TutorialDialog:SetTitle("Tutorial_Title17");
   -- "Welcome, my friend, to the Dueling Arena!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat1", nil, "Dialogue_ADVTUT/Diego_ADVTUT_01.mp3");
   -- "You wish to learn more of the Art of Dueling, no?"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat2", nil, "Dialogue_ADVTUT/Diego_ADVTUT_02.mp3");
   -- "Outstanding! Approach the Puppet, and we shall begin your lesson."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat3", -1, "Dialogue_ADVTUT/Diego_ADVTUT_03.mp3", true);
   -- Player now walks to the enemy and aggros it.
   UnfreezePlayer();

   planningPhaseWindow = nil;
   while ( true ) do
      planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
      if(planningPhaseWindow ~= nill and planningPhaseWindow.IsVisible()) then
	     HidePlanningPhase(true);
		 FindAndConfigurePlanningPhase();
	     break;
	  end
		 
      local event = GetEvent();
      if ( event.EventName == "OnTeleported" ) then
         return false;
      end
      if ( event.EventName == "OnEnterCombat" ) then
	     HidePlanningPhase(true);
		 GetEvent("CombatUiVisible");
	     -- Hide the planning window
	     FindAndConfigurePlanningPhase();
	     local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
	     GetEvent("CombatHand");		 
         break; 
      end
	  
   end

   TutorialDialog:ShowWindow(false);
   FreezePlayer();

   -- ROUND 1

   -- Request Troll spell be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-001");
   clientTutorial.RequestAddQuest("WC-TUT-C09-001");
   GetEvent("CombatHand");
   -- "Let us begin by explaining Power Points. You may call them pips, for short!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat4", nil, "Dialogue_ADVTUT/Diego_ADVTUT_04.mp3");
   -- "Power Points are magical energy. Gaining pips allows you to cast more powerful spells."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat5", nil, "Dialogue_ADVTUT/Diego_ADVTUT_05.mp3");
   -- "Every round, you will receive another Pip. "
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat6", nil, "Dialogue_ADVTUT/Diego_ADVTUT_06.mp3");
   TutorialDialog:SetProfessorImage("GUI/Art/Art_Duel_Pips.dds");
   -- "You can see the number of Pips each participant has by looking at the circle around their feet."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat7", nil, "Dialogue_ADVTUT/Diego_ADVTUT_07.mp3");
   TutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Diego_Duelmaster.dds");
   local pipCostWindow = CreateGUIClass("AdvCombatPips.gui", true);
   -- "Nearly every card has a Pip Cost. It is the number in the upper left hand corner."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat8", nil, "Dialogue_ADVTUT/Diego_ADVTUT_08.mp3");
   -- "You can only cast a Spell if you have enough Pips to do so. "
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat9", nil, "Dialogue_ADVTUT/Diego_ADVTUT_09.mp3");
   pipCostWindow.DetachSelf();
   ShowPassButton(false);
   -- Show the planning window
   HidePlanningPhase(false);
   DisableCard(0, true);
   Sleep(250); -- Give the card time to move into place within the layout
   ExpandCard(0, true);
   ShowPassButton(false);
   -- "Let us start with one spell with a Pip cost of 2."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat10", nil, "Dialogue_ADVTUT/Diego_ADVTUT_10.mp3");
   ExpandCard(0,false);
   ShowPassButton(true);
   -- "...but you only have 1 pip, so you cannot cast this turn. You will have to Pass."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat11", -1, "Dialogue_ADVTUT/Diego_ADVTUT_11.mp3");
   GetEvent("ExecutionPhase");
   ReleasePlanningPhaseWindow();
   -- "You can also use a zero rank spell, if you want to save up Power Pips."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat42", -1, "Dialogue_ADVTUT/Diego_ADVTUT_54.mp3");
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 2
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("CombatHand");
   RegisterEvent("TargetCardSelected");
   FindAndConfigurePlanningPhase();
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   -- Request tough spell to be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-002");
   clientTutorial.RequestAddQuest("WC-TUT-C09-002");
   GetEvent("CombatHand");
   DisableCards(0, 1, true);
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   -- "Good! You have passed and gained another Pip!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat12", nil, "Dialogue_ADVTUT/Diego_ADVTUT_12.mp3");
   -- "With 2 Pips, you can now cast the Troll spell."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat13", nil, "Dialogue_ADVTUT/Diego_ADVTUT_13.mp3");
   ExpandCard(1, true);
   -- "Ah, but look! You have drawn another card: Tough. This is an Enchantment Card."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat14", nil, "Dialogue_ADVTUT/Diego_ADVTUT_14.mp3");
   ExpandCard(1, false);
   -- "Enchantment Cards can be used to improve the other cards in your hand."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat15", nil, "Dialogue_ADVTUT/Diego_ADVTUT_15.mp3");
   DisableCard(1, false);
   -- "Let me show you. Click on the Tough card? "
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat16", -1, "Dialogue_ADVTUT/Diego_ADVTUT_16.mp3");
   local newArrow;
   -- repeat until player get's it right
   while(true) do
      local curSpell = spellSelectionWindow.FindNamedWindow("Card2");
      newArrow = CreateDockedArrow(curSpell);
      GetEvent("CombatCardSelected");
      RegisterEvent("InvalidSelection");
      newArrow:ShowWindow(false);
      local curSpell = spellSelectionWindow.FindNamedWindow("Card1");
      newArrow = CreateDockedArrow(curSpell);
      DisableCard(0, false);
      -- "?and now click on the Troll. "
      TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat17", -1, "Dialogue_ADVTUT/Diego_ADVTUT_17.mp3");
      local event = GetEvents("TargetCardSelected", "InvalidSelection")
      -- Player got it right, break out of the loop
      if(event == "TargetCardSelected") then break; end
      UnregisterEvent("InvalidSelection");
      DisableCard(0, true);
      newArrow:ShowWindow(false);
      -- "Whoops! You missed. Click on the Tough card again..."
      TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat18", -1, "Dialogue_ADVTUT/Diego_ADVTUT_18.mp3");
   end
   UnregisterEvent("InvalidSelection");

   -- remove the arrow
   newArrow:ShowWindow(false);
   -- disable the cards again
   DisableCard(0, true);

   --ExpandCard(0, false);
   --ExpandCard(0, true);
   -- "Look what has happened! The card has been Enchanted to do more damage.  Now it is a Treasure Card."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat19", nil, "Dialogue_ADVTUT/Diego_ADVTUT_19.mp3");
   ExpandCard(0, false);
   -- "Unused Treasure Cards go back into your Deck at the end of the Duel."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat20", nil, "Dialogue_ADVTUT/Diego_ADVTUT_20.mp3");
   -- enable the cards and add arrows
   DisableCard(0, false);
   local curSpell = spellSelectionWindow.FindNamedWindow("Card1");
   newArrow = CreateDockedArrow(curSpell);
   -- "Now, since you have 2 Pips, you can cast the Troll at the Puppet."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat21", -1, "Dialogue_ADVTUT/Diego_ADVTUT_21.mp3");
   GetEvent("CombatCardSelected");
   newArrow:ShowWindow(false);
   TutorialDialog:MoveToBottom(); -- the dialog at screen top covers the pupet at lower resolutions, so move it temporarily.
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();
   TutorialDialog:MoveToTop();
   TutorialDialog:ShowWindow(false);
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 3
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   -- Grant the player one power PIP
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-009");
   clientTutorial.RequestAddQuest("WC-TUT-C09-009");
   GetEvent("CombatHand");
   -- Request 3rd rank spell of each kind
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-010");
   clientTutorial.RequestAddQuest("WC-TUT-C09-010");
   -- "Now you are back to one Pip, yes?"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat23", nil, "Dialogue_ADVTUT/Diego_ADVTUT_22.mp3");
   -- "Let us give you another hand."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat24", nil, "Dialogue_ADVTUT/Diego_ADVTUT_23.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   DisableCards(0, 6, true);
   -- "Since you only have one Pip, you cannot cast any of these 3rd rank spells.  Normally you would need to pass for two rounds and build up your power."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat25", nil, "Dialogue_ADVTUT/Diego_ADVTUT_24.mp3");
   -- Hide the planning window
   HidePlanningPhase(true);
   -- "But wait!  There is another way? Let me show you."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat26", nil, "Dialogue_ADVTUT/Diego_ADVTUT_25.mp3");
   -- update PIP data on client
   RegisterEvent("OnUpdatePips");
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
   clientTutorial.RequestAddQuest("WC-TUT-C09-011");
   GetEvent("OnUpdatePips");
   UnregisterEvent("OnUpdatePips");
   --DisplayPopup("CombatMessages_PowerPipGained");
   TutorialDialog:MoveToBottom(); -- the dialog at screen top covers the pupet at lower resolutions, so move it temporarily.
   -- "I have given you a POWER PIP, see?"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat27", nil, "Dialogue_ADVTUT/Diego_ADVTUT_26.mp3");
   --"At the beginning of each Planning Phase, you will have a chance of receiving a Power Pip instead of your normal Pip."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat28", nil, "Dialogue_ADVTUT/Diego_ADVTUT_27.mp3");
   DisableCards(0, 6, true);
   --"Power Pips count double ? but only for Spells in your School of Focus."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat29", nil, "Dialogue_ADVTUT/Diego_ADVTUT_28.mp3");
   -- "Now you have 1 pip and 1 power pip."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat30", nil, "Dialogue_ADVTUT/Diego_ADVTUT_29.mp3");
   -- "That means you can cast any 2nd rank spell that you wish?"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat31", nil, "Dialogue_ADVTUT/Diego_ADVTUT_30.mp3");
   -- "?or you can use a 3rd rank spell in your School of Focus!  1 point for the Pip + 2 points for the Power Pip !"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat32", nil, "Dialogue_ADVTUT/Diego_ADVTUT_31.mp3");
   -- Give the Fire Cat spell to the Mob for next round
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-007");
   clientTutorial.RequestAddQuest("WC-TUT-C09-007");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);   
   DisableCards(0, 6, -1);
   -- "See?  The card for your school is now available to you. Cast it at the puppet now."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat33", -1, "Dialogue_ADVTUT/Diego_ADVTUT_32.mp3");
   GetEvent("CombatCardSelected");
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();
   TutorialDialog:MoveToTop();
   TutorialDialog:ShowWindow(false);
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 4
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   GetEvent("CombatHand");
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   -- Clear the play deck of all remaining cards.
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   GetEvent("CombatHand");
   -- "Outstanding! Now let us look at another type of Spell Card."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat35", nil, "Dialogue_ADVTUT/Diego_ADVTUT_33.mp3");
   local fireShieldWindow = CreateGUIClass("AdvCombatFireShield.gui", true);
   -- "A shield can be used to protect you against future attacks. "
   RegisterEvent("HangingEffectTriggered");
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat36", nil, "Dialogue_ADVTUT/Diego_ADVTUT_34.mp3");
   -- "This is a FIRE shield. When you cast it on yourself or a friend, it will HANG in front of them, waiting to be activated."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat37", nil, "Dialogue_ADVTUT/Diego_ADVTUT_35.mp3");
   -- "The next incoming FIRE spell will trigger it."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat38", nil, "Dialogue_ADVTUT/Diego_ADVTUT_36.mp3");
   -- Give a fire shield spell to the player's hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-004");
   clientTutorial.RequestAddQuest("WC-TUT-C09-004");
   GetEvent("CombatHand");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   fireShieldWindow.DetachSelf();
   -- put an arrow on the spell card
   local curSpell = spellSelectionWindow.FindNamedWindow("Card"..tostring(1));
   local newArrow = CreateDockedArrow(curSpell);
   -- "Let me show you. Cast this Fire Ward upon yourself."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat39", -1, "Dialogue_ADVTUT/Diego_ADVTUT_37.mp3");
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   newArrow:ShowWindow(false);
   ReleasePlanningPhaseWindow();
   -- "Very good! See how this Fire Ward hangs near your feet? Watch how it can protect you!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat40", -1, "Dialogue_ADVTUT/Diego_ADVTUT_38.mp3");
   -- Clear the Mob's hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-008");
   clientTutorial.RequestAddQuest("WC-TUT-C09-008");
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   GetEvent("HangingEffectTriggered");
   TutorialDialog:HideNextButton();
   -- "Do you see? The Fire Ward has activated, and helps you resist most of the damage from this attack!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat41", -1, "Dialogue_ADVTUT/Diego_ADVTUT_39.mp3");

   -- ROUND 5
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   GetEvent("CombatHand");
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   -- Clear the play deck of all remaining cards.
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Give an Ice Charm spell to the player's hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-005");
   clientTutorial.RequestAddQuest("WC-TUT-C09-005");
   GetEvent("CombatHand");

   TutorialDialog:ShowNextButton();
   TutorialDialog:WaitForNextButton();

   local iceBladeWindow = CreateGUIClass("AdvCombatIceBlade.gui", true);
   -- "Let's try one more Hanging sepll. This one is called Ice Blade."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat44", nil, "Dialogue_ADVTUT/Diego_ADVTUT_40.mp3");
   iceBladeWindow.DetachSelf();
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   local curSpell = spellSelectionWindow.FindNamedWindow("Card"..tostring(1));
   local newArrow = CreateDockedArrow(curSpell);
   -- "Cast it on yourself, and see what happens."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat45", -1, "Dialogue_ADVTUT/Diego_ADVTUT_41.mp3");
   GetEvent("CombatTargetSelected");
   TutorialDialog:ShowWindow(false);
   -- Hide the planning window
   HidePlanningPhase(true);
   ReleasePlanningPhaseWindow();
   newArrow:ShowWindow(false);
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 6
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   GetEvent("CombatHand");
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   -- Clear the play deck of all remaining cards.
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   GetEvent("CombatHand");
   -- Give an Frost Beetle spell to the player's hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-006");
   clientTutorial.RequestAddQuest("WC-TUT-C09-006");
   GetEvent("CombatHand");
   -- "Charms are the opposite of Wards!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat46", nil, "Dialogue_ADVTUT/Diego_ADVTUT_42.mp3");
   local iceBladeWindow = CreateGUIClass("AdvCombatIceBlade.gui", true);
   -- "Wards affect Spells that other people cast on you. Charms affect Spells that you cast on other people."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat47", nil, "Dialogue_ADVTUT/Diego_ADVTUT_43.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);   
   iceBladeWindow.DetachSelf();
   local curSpell = spellSelectionWindow.FindNamedWindow("Card"..tostring(1));
   local newArrow = CreateDockedArrow(curSpell);
   -- "Cast this Frost Beetle at the Puppet. Let's see how the Charm works."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat48", -1, "Dialogue_ADVTUT/Diego_ADVTUT_44.mp3");
   GetEvent("CombatCardSelected");
   newArrow:ShowWindow(false);
   TutorialDialog:MoveToBottom(); -- the dialog at screen top covers the pupet at lower resolutions, so move it temporarily.
   GetEvent("CombatTargetSelected");
   TutorialDialog:ShowWindow(false);
   ReleasePlanningPhaseWindow();
   GetEvent("HangingEffectTriggered");
   TutorialDialog:MoveToTop();
   TutorialDialog:ShowWindow(true);

   -- Request Fire Elf spell be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-012");
   clientTutorial.RequestAddQuest("WC-TUT-C09-012");
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   TutorialDialog:HideNextButton();
   -- "Do you see?  Your Ice Beetle has triggered the Ice Charm.  Now the Ice Beetle is more powerful!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat49", -1, "Dialogue_ADVTUT/Diego_ADVTUT_45.mp3");
   TutorialDialog:ShowWindow(true);

   -- ROUND 7
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("CombatHand");     
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   GetEvent("CombatHand");   
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   DisableCard(0, true);

   TutorialDialog:ShowNextButton();
   TutorialDialog:WaitForNextButton();

   -- "Now let us cover one more type of Hanging Effect, the Aura spells."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat50", nil, "Dialogue_ADVTUT/Diego_ADVTUT_46.mp3");
   -- "Aura spells affect the target over multiple rounds of combat."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat51", nil, "Dialogue_ADVTUT/Diego_ADVTUT_47.mp3");
   local fireElfWindow = CreateGUIClass("AdvCombatFireElf.gui", true);
   -- "For example, the Fire Elf spell will cause 240 points of Fire damage, spead over three rounds."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat52", nil, "Dialogue_ADVTUT/Diego_ADVTUT_48.mp3");
   fireElfWindow.DetachSelf();
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   local curSpell = spellSelectionWindow.FindNamedWindow("Card"..tostring(1));
   local newArrow = CreateDockedArrow(curSpell);
   TutorialDialog:MoveToBottom();
   -- "Let's see how it works.  Cast a Fire Elf at the puppet."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat53", -1, "Dialogue_ADVTUT/Diego_ADVTUT_49.mp3");
   DisableCard(0, false);
   GetEvent("CombatCardSelected");
   newArrow:ShowWindow(false);
   TutorialDialog:MoveToBottom(); -- the dialog at screen top covers the pupet at lower resolutions, so move it temporarily.
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();
   --GetEvent("OnDOT");
   TutorialDialog:MoveToTop();
   TutorialDialog:ShowWindow(false);
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 8
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   GetEvent("CombatHand");
   TutorialDialog:MoveToBottom();
   GetEvent("OnDOT");
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   -- "Good!  Now watch what happens next round."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat54", nil, "Dialogue_ADVTUT/Diego_ADVTUT_50.mp3");
   TutorialDialog:ShowWindow(false);
   ForcePass();
   ReleasePlanningPhaseWindow();
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 9
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   GetEvent("CombatHand");
   TutorialDialog:MoveToBottom();
   GetEvent("OnDOT");
   ReleasePlanningPhaseWindow();
   -- "And again..."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat55", nil, "Dialogue_ADVTUT/Diego_ADVTUT_51.mp3");
   TutorialDialog:ShowWindow(false);
   -- Reset mob pips back to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");

   -- ROUND 10
   ForcePass();

   GetEvent("OnDOT");

   -- Combat Complete!
   GetEvent("OnLeaveCombat");
   ReleasePlanningPhaseWindow();

   -- "Excellent!  You have defeated him, and completed our lesson."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat56", nil, "Dialogue_ADVTUT/Diego_ADVTUT_52.mp3");
   -- "I hope you have found our lesson to be most helpful!...
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat57", nil, "Dialogue_ADVTUT/Diego_ADVTUT_53.mp3");
   TutorialDialog:ShowWindow(false);

   -- Refill mana and health to 100%
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
   clientTutorial.RequestAddQuest("WC-TUT-C09-014");
   clientTutorial.RequestAddQuest("WC-TUT-C09-016");

   UnregisterEvent("CombatHand");
   UnregisterEvent("OnEnterCombat");
   UnregisterEvent("ExecutionPhase");
   UnregisterEvent("CombatCardSelected");
   UnregisterEvent("CombatTargetSelected");

   UnregisterEvent("OpenPlanningPhase");
   UnregisterEvent("OnLeaveCombat");
   UnregisterEvent("OnDOT");
   UnregisterEvent("OnTeleported");
   UnregisterEvent("HangingEffectTriggered");
   UnregisterEvent("CombatUiVisible");

   return true;

   --TutorialDialog:DetachSelf();
end

function WaitForMobGID()
   Log("Waiting on Mob GID...");
   RegisterEvent("CombatAddMob");
   local event = GetEvent("CombatAddMob");
   MobID = event.OwnerID;
   if(MobID) then
      Log("Got Mob OwnerID "..MobID);
   else
      Log("Got Mob with NIL OwnerID!");
   end
   UnregisterEvent(eventName);
end

function CreateDockedArrow(window)
   local myArrow = TutorialArrow(window,"Bottom",64,0.5,0.5,true);
   --local myArrow = CreateSpriteClass("Art/Art_Tutorial_Arrow.dds",MakeRectString(0,0,70,128),false,window);
   -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   --myArrow.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
   --myArrow.m_Flags = "VISIBLE|DOCK_TOP|DOCK_OUTSIDE|HCENTER";
   myArrow:ShowWindow(true);
   return myArrow;
end

function FindAndConfigurePlanningPhase()
   if(planningPhaseWindow) then
      DestroyClass(planningPhaseWindow);
   end

   planningPhaseWindow = nil;
   while(planningPhaseWindow == nil) do -- keep trying to get a handle on the window until we get it
      planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
      Sleep(100);
   end

   planningPhaseWindow.FindNamedWindow("Focus").ShowWindow(false);
   planningPhaseWindow.FindNamedWindow("Flee").ShowWindow(false);
   planningPhaseWindow.FindNamedWindow("HelpText").ShowWindow(false);
   planningPhaseWindow.FindNamedWindow("CountText").ShowWindow(false);
   --planningPhaseWindow.FindNamedWindow("Draw").ShowWindow(false);

   planningPhaseWindow.ShowWindow(false);
end

-- This function prevents the script engine from holding a reference to the
-- stale planning phase window so it can be deleted
-- Thus it fixes the bug where one can click on a mob during the cinematics
-- and a selection sound would play.
function ReleasePlanningPhaseWindow()
   if(planningPhaseWindow) then
      DestroyClass(planningPhaseWindow);
      planningPhaseWindow = nil;
   end
end

function ShowPassButton(aBool)
   local planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   if(not planningPhaseWindow) then
      Log("ShowPassButton could not find the planning phase window!");
      while(planningPhaseWindow == nil) do -- keep trying to get a handle on the window until we get it
         Sleep(100);
         planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
      end
   end
   local passButton = planningPhaseWindow.FindNamedWindow("Focus");
   passButton.ShowWindow(aBool);

   if(aBool == true) then
      PassArrow = CreateDockedArrow(passButton);
   elseif(PassArrow) then
      PassArrow:ShowWindow(false);
   end

end

function ForcePass()
   local planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
   if(not planningPhaseWindow) then
      Log("ForcePass could not find the planning phase window!");
      while(planningPhaseWindow == nil) do -- keep trying to get a handle on the window until we get it
         Sleep(100);
         planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
      end
   end
   local passButton = planningPhaseWindow.FindNamedWindow("Focus");
   -- Show the planning window
   HidePlanningPhase(false);
   passButton.ShowWindow(true);
   -- "Click" the pass button
   passButton.SetButtonDown(true);
   -- Pause 250 milliseconds
   Sleep(250);
   passButton.SetButtonDown(false);
   -- Hide the planning window
   HidePlanningPhase(true);
   Log("Forcing the player to pass...");
end

-- Expand the indicated card to its full mouse-over size if aBool is true, or return it to normal size if aBool is false
function ExpandCard(cardNum, aBool)
   ExpandCards(cardNum, cardNum, aBool);
end

-- Expand the indicated card to its full mouse-over size if aBool is true, or return it to normal size if aBool is false; cards specified by range
function ExpandCards(cardNum1, cardNum2, aBool)
   local planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   if(cardNum1 <= cardNum2) then
      local num;
      for num = cardNum1, cardNum2 do
         local spellBalloon = spellSelectionWindow.FindNamedWindow("Card"..tostring(num+1)).Parent();
         if(spellBalloon) then
            if(aBool == true) then
               spellBalloon.Inflate(num);
            else
               spellBalloon.Deflate(num);
            end
         else
            Log("Error in ExpandCards: spellBalloon is nil when cardNum is "..num);
         end
      end
   else
      Log("Error in ExpandCards: param1 must be <= param2!");
   end
end

function CreateIllustration(imageFile)
   local image = CreateSpriteClass(imageFile,MakeRectString(0,0,618,404),false,nil);
   image.SetLocation( 0, 0 );
   image.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
   image.m_Flags = "HCENTER|DOCK_BOTTOM";
   image.ShowWindow(true);

   return image;
end

function Sleep(aNumMilliSeconds)
   local gameTimer = Timer();
   local startTime = gameTimer:GetTime();
   while(gameTimer:GetTime() < startTime + aNumMilliSeconds) do end
end

function GetEvents(event1, event2)
   local oneOrTwo = false;  -- false = one, true = two

   while ( true ) do
      local event = GetEvent();
      if ( event.EventName == event1 ) then
         oneOrTwo = false;
         break;
      end
      if ( event.EventName == event2 ) then
         oneOrTwo = true;
         break;
      end
   end

   if( oneOrTwo == true ) then
      return event2;
   else
      return event1;
   end
end

-- Teleport Player out of tutorial zone and restore the GUI to its normal state
function doTeleport()

 RegisterEvent("OnTeleported");

      FreezePlayer();

      -- Clear all old quests
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-001");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-002");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-004");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-005");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-006");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-007");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-008");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-009");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-010");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-012");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-013");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");

      RestoreGUIElements(g_GuiElements);
      clientTutorial.UnsetTutuorialGUIState();

      ShowTips(true);

      -- Re-Enable disabled game commands
      RemapKey("ToggleQuestList");
      RemapKey("ToggleCharStats");
      RemapKey("ToggleMapWindow");
      RemapKey("ToggleWorldWindow");
      RemapKey("ToggleInventory");
      RemapKey("DisplayBuddyList");
      RemapKey("DisplayLogin");
      RemapKey("ToggleDeckConfig");

      -- Teleport back to the Commons
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-013");
      clientTutorial.RequestAddQuest("WC-TUT-C09-013");
      GetEvent("OnTeleported");
      UnregisterEvent("OnTeleported");

      UnfreezePlayer();
end
