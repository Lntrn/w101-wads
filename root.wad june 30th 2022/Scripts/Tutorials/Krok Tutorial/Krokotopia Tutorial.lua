-- KrokCombatTutorial.lua
-- Client side script that loads up the Tutorial gui and displays the dialog text allowing the user
-- to choose an item...

Include("API/WindowAnimations.lua");
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua");
Include("Tutorials/API/AdvancedTutorialUtility.lua");
Include("API/ControlClasses.lua");
Include("Tutorials/API/TutorialArrow.lua");
Include("API/Classes/Timer.lua");

MobID = nil;

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
   Log("Entering Krokotopia Tutorial");


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

   local complete = KrokCombatTutorial();

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
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-008");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-013");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-006");
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-005");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-001");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-002");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-003");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-004");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-005");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-006");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-007");
      clientTutorial.RequestRemoveQuest("WC-TUT-C11-008");

      GetEvent("OnTeleported");
      Sleep(2000);
      UnfreezePlayer();
      UnregisterEvent("OnTeleported");
      -- Complete the tutorial quest
      clientTutorial.RequestGoalCompletion("Tutorial_Krok", "OnlyGoal");
   end
end


function KrokCombatTutorial ()
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
   TutorialDialog:SetTitle("Tutorial_Tutorial_Krok_Title");
   -- "Welcome, my friend, to the Dueling Arena!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat1", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_03.mp3");
   -- "You wish to learn more of the Art of Dueling, no?"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat2", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_36.mp3");
   -- Outstanding approach the Firebird and we will begin our lesson.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat2", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_37.mp3");
   UnfreezePlayer();
   local event = GetEvents("OnTeleported", "OnEnterCombat");
   if(event == "OnTeleported") then
      return false;
   end
   if(event == "OnEnterCombat") then
      TutorialDialog:ShowWindow(false);
   end

   -- ROUND 1
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   --Reguest Fire Cat to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-001");
   clientTutorial.RequestAddQuest("WC-TUT-C11-001");

   TutorialDialog:MoveToBottom();
   -- A monster’s School is shown on it’s name tag. This Firebird is obviously a Fire monster.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat3", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_38.mp3");
   -- When you cast a spell in the same School as a monster, it does less damage. This is called Resistance.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat4", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_39.mp3");
   TutorialDialog:MoveToTop();
   -- Attack this Firebird with a Firecat spell and watch what happens.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat5", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_40.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();

   --ROUND 2
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   --Reguest Fire Prism to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-002");
   clientTutorial.RequestAddQuest("WC-TUT-C11-002");

   -- Did you see how the Firebird resisted the spell? Generally, the stronger the monster the more it resists spells of its own School.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat6", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_41.mp3");
   -- When you wish to cast spells at a monster of the same School, you should first cast a Prism.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat7", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_42.mp3");
   -- A Prism switches the damage from one School to its opposite. Life and Death, Ice and Fire, and Myth and Storm are all opposites.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat8", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_43.mp3");
   -- Unfortunately, Balance has no opposite and thus no Prism.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat9", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_44.mp3");
   -- Let’s watch a Prism in action. Cast this Fire Prism.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat10", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_45.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();

   --ROUND 3
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   --Reguest Fire Cat to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-008");
   clientTutorial.RequestAddQuest("WC-TUT-C11-008");

   -- Now cast Firecat again and watch how the Fire damage is converted to Ice damage.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat11", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_46.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();

   --ROUND 4
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   --Reguest Wyldfire to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-003");
   clientTutorial.RequestAddQuest("WC-TUT-C11-003");

   -- Most monsters are vulnerable to damage from their opposite School. Did you notice that Firecat did more damage the usual? Excellent!
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat12", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_47.mp3");
   -- Now let’s discuss Global spells. Global spells affect both friends and foes in a magical duel. They last until another Global spell is cast.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat13", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_48.mp3");
   -- Cast the spell Wyldfire!
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat14", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_49.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   ReleasePlanningPhaseWindow();

   --ROUND 5
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   --Request that player be given extra pips
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");
   --Request Darkwind to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-004");
   clientTutorial.RequestAddQuest("WC-TUT-C11-004");
   --Reguest Stun to be given to the mob
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-005");
   clientTutorial.RequestAddQuest("WC-TUT-C11-005");

   -- Wyldfire boosts all Fire spells for everyone in the duel by 25%. If anyone casts another Global spell it will cancel Wyldfire.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat15", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_50.mp3");
   -- Cast the Storm spell Darkwind and watch what happens.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat16", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_51.mp3");
   --Request to update pips
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
   clientTutorial.RequestAddQuest("WC-TUT-C09-011");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   ReleasePlanningPhaseWindow();

   --ROUND 6
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   planningPhaseWindow.ShowWindow(false);

   --Reguest Ice Beetle to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-006");
   clientTutorial.RequestAddQuest("WC-TUT-C09-006");

   -- Wyldfire was canceled and Darkwind is the new Global spell!
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat17", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_52.mp3");
   -- Finally, I must alert you to the practice of Stunning. Some spells can stun a Wizard, preventing them from casting spells for one turn.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat18", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_53.mp3");
   -- But it’s not all bad news. When you are Stunned you are given a Stun Shield to protect you against a future Stunning spell.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat19", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_54.mp3");
   -- When you’re stunned in PVP, you are given several Stun Shields. The number of Stun Shields you receive equals the number of your opponents.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat20", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_55.mp3");
   -- Let’s observe what happens when you’re Stunned. Try casting this Ice Beetle spell at the Sunbird.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat21", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_56.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   -- Request that opponents hand be cleared
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-008");
   clientTutorial.RequestAddQuest("WC-TUT-C09-008");
   ReleasePlanningPhaseWindow();

   --ROUND 7
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   --Reguest Ice Beetle to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-006");
   clientTutorial.RequestAddQuest("WC-TUT-C09-006");

   -- The Firebird Stunned you and you can’t cast spells this turn. Try casting this Ice Beetle spell again.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat22", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_57.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   ReleasePlanningPhaseWindow();

   --ROUND 8
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   --Reguest Ice Beetle to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C11-006");
   clientTutorial.RequestAddQuest("WC-TUT-C11-006");
   -- Your spell wasn’t cast because you were Stunned. Now that you’re not Stunned, try casting this Ice Beetle spell one more time.
   TutorialDialog:DoDialog("Tutorial_Tutorial_Krok_Combat23", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_58.mp3");

   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();

   GetEvent("OnLeaveCombat");
   -- Excellent! You have defeated him, and completed your lesson.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat26", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_59.mp3");
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-010");
   clientTutorial.RequestAddQuest("WC-TUT-C10-010");
   TutorialDialog:ShowWindow(false);
   FreezePlayer();

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
      while(planningPhaseWindow == nil)
      do -- keep trying to get a handle on the window until we get it
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
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-002");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-003");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-004");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-005");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-006");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-007");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-008");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-009");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-010");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-011");
      clientTutorial.RequestRemoveQuest("WC-TUT-C10-012");


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