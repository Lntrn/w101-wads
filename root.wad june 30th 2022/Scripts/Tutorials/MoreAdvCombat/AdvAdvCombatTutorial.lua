-- MoreAdvCombatTutorial.lua
-- Client side script that loads up the Tutorial gui and displays the dialog text allowing the user
-- to choose an item...
--[[New Hidden Quests Referenced: C10-01 = Give player 5 pips
                 02 = Give player Tutorial Stormzilla 1
                 03 = Give player Tutorial Helephant
                 04 = Give Player Tutorial Amplify
                 05 = Give Player Tutorial Firecat 2
                 06 = Give Player Tutorial Accurate
                 07 = Give Player Transform to Gobbler
                 08 = Give player Taco Toss(gobbler skill)
                 09 = Give enemy Fire Shield
                 10 = Give player the reward item Vicious Hat
                 11 = Give player Tutorial Stormzilla 2
                 12 = Give player Tutorial Stormzilla 3

]]
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
   Log("Entering Advanced Advanced Combat Tutorial");

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

   local complete = MoreAdvCombatTutorial();

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
      clientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
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

      GetEvent("OnTeleported");
      Sleep(2000);
      UnfreezePlayer();
      UnregisterEvent("OnTeleported");
      -- Complete the tutorial quest
      clientTutorial.RequestGoalCompletion("Tutorial_More_Advanced_Combat", "OnlyGoal");
   end
end

function MoreAdvCombatTutorial()

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
   TutorialDialog:SetTitle("Tutorial_Tutorial_More_Advanced_Title");
   -- "Welcome, my friend, to the Dueling Arena!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat1", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_03.mp3");
   -- "You wish to learn more of the Art of Dueling, no?"
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat2", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_04.mp3");
   -- "Outstanding! Approach the Puppet, and we shall begin your lesson."
   TutorialDialog:DoDialog("Tutorial_Tutorial_Adv_Combat3", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_05.mp3", true);
   -- Player now walks to the enemy and aggros it.

   local event = GetEvents("OnTeleported", "OnEnterCombat");
   if(event == "OnTeleported") then
      return false;
   end
   TutorialDialog:ShowWindow(false);

   -- ROUND 1
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
  -- Request 5 pips to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");
  -- Request Stormzilla 1 spell be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-002");
   clientTutorial.RequestAddQuest("WC-TUT-C10-002");
  -- "At your level of skill, now you are capable of a new result when you are dueling... the Critical!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat1", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_06.mp3");
  --"Before we witness a critical though, let's examine a normal spell.  Cast Stormzilla and take note of its damage."
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat30", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_07.mp3");
  -- Request pip update
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
   clientTutorial.RequestAddQuest("WC-TUT-C09-011");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   ReleasePlanningPhaseWindow();

   -- ROUND 2
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Request 5 pips to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");
  -- Request Stormzilla 2 spell be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-011");
   clientTutorial.RequestAddQuest("WC-TUT-C10-011");
   -- Stormzilla did its typical amount of damage. Now cast the spell again, and this round we will see the spell critical!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat31", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_08.mp3");
   -- Request pip update
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
   clientTutorial.RequestAddQuest("WC-TUT-C09-011");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 3
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Request 5 pips to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");
   -- Request Stormzilla 3 spell be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-012");
   clientTutorial.RequestAddQuest("WC-TUT-C10-012");
   -- Fire Shield is added to the enemies hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-009");
   clientTutorial.RequestAddQuest("WC-TUT-C10-009");
   -- "Remarkable! Stormzilla did twice its usual damage."
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat3", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_09.mp3");
   -- "Many spells, including attacks, heals, or even steals, can potentially Critical."
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat5", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_10.mp3");
   -- "A Critical damage spell can do great damage to your opponent, while a Critical heal is especially beneficial!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat6", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_11.mp3");
   local critImage = CreateGUIClass("MoreADV-CriticalRating.gui",true);
   -- "Your chance to achieve a Critical improves with your abilities, and equipment or enchantments can increase it further!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat7", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_12.mp3");
   critImage.DetachSelf();
   -- "But do not become carried away with your newfound power! There is a counter to the Critical... the Block!"
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat8", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_13.mp3");
   -- Request pip update
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
   clientTutorial.RequestAddQuest("WC-TUT-C09-011");
   -- "Cast this spell and observe the block."
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat9", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_14.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 4
   GetEvent("CombatHand");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Request 5 pips to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");

   -- A Block reduces the likelihood of a successful Critical. Blocks only affect Criticals... they have no effect on normal successes!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat10", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_15.mp3");
   local blockImage = CreateGUIClass("MoreADV-BlockRating.gui",true);
   -- Another important new abilitiy is Armor Piercing.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat11", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_16.mp3");
   -- Armor Piercing allows spells to breach shields, auras and even spell resistance!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat12", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_17.mp3");
   blockImage.DetachSelf();
   TutorialDialog:ShowWindow(false);
   
   -- This will end the round.
   ForcePass();
   -- Waiting on Execution phase to clear dummys hand so that cards are still there to cast on server.
   GetEvent("ExecutionPhase");
   
   -- Request to Clear the dummys hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-008");
   clientTutorial.RequestAddQuest("WC-TUT-C09-008");
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 5
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();

   -- Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Request 5 pips to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");
   -- Request Helephant spell be added to the Play Deck
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-003");
   clientTutorial.RequestAddQuest("WC-TUT-C10-003");
   -- Show the planning window
   HidePlanningPhase(false);
   -- Cast this spell and watch for armor piercing.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat13", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_18.mp3");
   -- Request pip update
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-011");
   clientTutorial.RequestAddQuest("WC-TUT-C09-011");
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 6
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Request 5 pips to be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-001");
   clientTutorial.RequestAddQuest("WC-TUT-C10-001");
   -- Request Amplify spell be given to player
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-004");
   clientTutorial.RequestAddQuest("WC-TUT-C10-004");
   GetEvent("CombatHand");
   local blockImage = CreateGUIClass("MoreADV-ArmorPierce.gui",true);
   -- Did you see that? Some of the spell’s damage breached the shield!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat14", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_19.mp3");
   blockImage.DetachSelf();
   -- Congratualtions, your studies have progressed far enough that you can learn a new form of magic, Astral Magic
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat15", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_20.mp3");
   -- Astral Magic consists of Sun spells, Moon spells and Star Spells.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat16", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_21.mp3");
   -- Star school spells allow you to train Auras which effect only you and last a limited number of rounds.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat17", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_22.mp3");
   -- Let’s cast a Star school spell. Cast Amplify now!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat18", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_23.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   -- Hide the planning window
   HidePlanningPhase(true);
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 7
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Requests to give this player the Fire Cat spell
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-005");
   clientTutorial.RequestAddQuest("WC-TUT-C10-005");
   -- Requests to give the player the Accurate spell
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-006");
   clientTutorial.RequestAddQuest("WC-TUT-C10-006");
   -- Amplify increases the damage of other spells by 15% for 4 rounds.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat29", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_24.mp3");
   -- Now let’s explore Sun school spells. Sun spells are trainable Enchantments that allow you to modify other spells in your hand.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat19", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_25.mp3");
   -- Let’s cast a Sun school spell. Use Accurate to Enchant the Fire Cat spell!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat20", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_26.mp3");
   -- Click on the Accurate spell...
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat21", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_27.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   DisableCard(0, true);
   -- repeat until player get's it right
   while(true) do
      DisableCard(0, true);
      RegisterEvent("TargetCardSelected");
      GetEvent("CombatCardSelected");
      DisableCard(0, false);
      RegisterEvent("InvalidSelection");
      -- "and now click on the Fire Cat."
      TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat22", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_28.mp3");
      local event = GetEvents("TargetCardSelected", "InvalidSelection");
      -- Player got it right, break out of the loop
      if(event == "TargetCardSelected") then break; end
      UnregisterEvent("InvalidSelection");
      -- "Whoops! You missed. Click on the Accurate card again..."
      TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat28", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_29.mp3");
   end
   UnregisterEvent("InvalidSelection");
   UnregisterEvent("TargetCardSelected");
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 8
   GetEvent("OpenPlanningPhase");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Requests to give this player the Transform Gobbler spell
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-007");
   clientTutorial.RequestAddQuest("WC-TUT-C10-007");
   -- Finally, the Moon School allows you to train Polymorphs which change your appearance, school, equipment and deck for a limited number of rounds.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat23", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_30.mp3");
   -- Let’s cast a Moon school spell. Cast the Polymorph Gobbler spell.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat24", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_31.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   -- Hide the planning window
   HidePlanningPhase(true);
   --Resets the mobs pips to 1
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-015");
   clientTutorial.RequestAddQuest("WC-TUT-C09-015");
   ReleasePlanningPhaseWindow();

   -- ROUND 9
   GetEvent("CombatHand");
   FindAndConfigurePlanningPhase();
   --Request to clear players hand
   clientTutorial.RequestRemoveQuest("WC-TUT-C09-003");
   clientTutorial.RequestAddQuest("WC-TUT-C09-003");
   -- Requests to give the player the Taco Toss spell
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-008");
   clientTutorial.RequestAddQuest("WC-TUT-C10-008");
   -- Now finish the puppet with a Taco Toss!
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat25", -1, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_32.mp3");
   -- Show the planning window
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetEvent("CombatCardSelected");
   TutorialDialog:ShowWindow(false);
   GetEvent("CombatTargetSelected");
   -- Hide the planning window
   HidePlanningPhase(true);
   GetEvent("OnLeaveCombat");
   ReleasePlanningPhaseWindow();

   -- Excellent! You have defeated him, and completed your lesson.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat26", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_33.mp3");
   -- I will give you this humble gift... a simple token to demonstrate how the Critical and the Block work.
   TutorialDialog:DoDialog("Tutorial_Tutorial_More_Advanced_Combat27", nil, "|Sound_Dialogue_AZT|WorldData|Sound/Dialogue/AdvancedTutorial/DiegoTheDuelmaster_AZT_34.mp3");
   clientTutorial.RequestRemoveQuest("WC-TUT-C10-010");
--   clientTutorial.RequestAddQuest("WC-TUT-C10-010");
   TutorialDialog:ShowWindow(false);
   FreezePlayer();

   -- Show the planning window in future combat
   -- HidePlanningPhase(false);

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
