-- TutorialCombat.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");


function CreateTopArrow(window)
	local myArrow = TutorialArrow(window,"Top",64,0.5,0.5,true);
	--local myArrow = CreateSpriteClass("Art/Art_Tutorial_Arrow.dds",MakeRectString(0,0,70,128),false,window);
	-- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	--myArrow.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	--myArrow.m_Flags = "VISIBLE|DOCK_TOP|DOCK_OUTSIDE|HCENTER";
	myArrow:ShowWindow(true);
	return myArrow;
end

function TutorialCombat() 
   gClientTutorial.RequestRemoveQuest("WC-TUT-C03-001");
   gClientTutorial.RequestAddQuest("WC-TUT-C03-001");
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","CloseDoor");   
	   
   RegisterEvent("OpenPlanningPhase");
   RegisterEvent("OnLeaveCombat");
   RegisterEvent("CombatHand");       
   RegisterEvent("CombatUiVisible");
   RegisterEvent("OnUpdatePips");
   RegisterEvent("HangingEffectTriggered");
   RegisterEvent("HangingEffectApplied");
   RegisterEvent("ExecutionPhase");
   
   gExpBar = gExpBar or OpenClass(FindNamedWindow("XPBar"));	
   
   local ambroseId = GetClientID(39394);
   local malistaireId = GetClientID(77831);
         
   gSkipOK = IsWorldReady();
   if(GetFirstCharacterCreation() == 0) then
      gFirstCharacterCreation = false;
   else
      gFirstCharacterCreation = true;
   end

   -- Camera cut to M.
   SetOverrideCameraByName("Cam_MalistaireMedium", 0);
      
   local healthInit 	=  GetGlobeValues(gHealthGlobe);
   -- if the health amount is less than it should be, add some health
   --healthInit.Amount;

   gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
   gTutorialDialog:SetConfirmationTitle("Tutorial_Tutorial_Confirmation_Title");
   gTutorialDialog:SetConfirmationMessage("Tutorial_Tutorial_Confirmation_Text");
   gTutorialDialog:SetConfirmationYesLabel("Tutorial_Tutorial_Confirmation_Yes");
   gTutorialDialog:SetConfirmationNoLabel("Tutorial_Tutorial_Confirmation_No");   
   gTutorialDialog:MoveToBottom();
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	
   ---gTutorialDialog:DoDialog("Who’s there...? Malistaire!!!", true);
   if (gSkipOK and not gFirstCharacterCreation) then
      gTutorialDialog:ShowSkipTutorialButton();
   end
   -- The reason I'm changing all of these delays to -1 is because they were already broken and I needed to change it to
   -- get the tutorial skip button to work.  I checked on Live:  Only the first dialog pane delays the next button on 
   -- a first character on a new account, the rest of the dialogs are not delaying the NextButton anyway, so there's no
   -- change for me to make them all -1.
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro014", -1, "Dialogue_Tutorial/TUT_Ambrose_014.mp3", false, ambroseId, 4.0);

   if(gTutorialDialog:WaitForNextButton() == true and
      gTutorialDialog:GetConfirmation() == true) then   
      Log("Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   gTutorialDialog:SetTitle("Tutorial_Title22"); -- "Malistaire"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");	
   ---gTutorialDialog:DoDialog("<ITALICS>Malistaire sneers. </ITALICS> Ambrose.", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro015", -1, "Dialogue_Tutorial/TUT_Malistaire_015.mp3", false, malistaireId, 2.0);    
   
   if(gTutorialDialog:WaitForNextButton() == true and
      gTutorialDialog:GetConfirmation() == true) then   
      Log("Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   -- Camera cut to A.
   SetOverrideCameraByName("Cam_AmbroseMedium", 0);
   gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	
   ---gTutorialDialog:DoDialog("You are no longer welcome here! Why have you returned?", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro016", -1, "Dialogue_Tutorial/TUT_Ambrose_016.mp3", false, ambroseId, 4.0);
   
   if(gTutorialDialog:WaitForNextButton() == true and
      gTutorialDialog:GetConfirmation() == true) then   
      Log("Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   -- Camera cut to M.
   SetOverrideCameraByName("Cam_MalistaireMedium", 0);
   
   gTutorialDialog:SetTitle("Tutorial_Title22"); -- "Malistaire"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");	
   ---gTutorialDialog:DoDialog("I’m here to resolve our unfinished business! Is this your latest student? My henchmen will see to your little friend!", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro017", -1, "Dialogue_Tutorial/TUT_Malistaire_017.mp3", false, malistaireId, 11.0);
 
   if(gTutorialDialog:WaitForNextButton() == true and
      gTutorialDialog:GetConfirmation() == true) then   
      Log("Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   -- Camera cut to A.
   SetOverrideCameraByName("Cam_AmbroseMedium", 0);
   gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	
   --gTutorialDialog:DoDialog("Hurry, young Wizard! Take this deck of spell cards and deal with those creatures while I tend to Malistaire himself!", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro018", -1, "Dialogue_Tutorial/TUT_Ambrose_018.mp3", false, ambroseId, 8.0);

   if(gTutorialDialog:WaitForNextButton() == true and
      gTutorialDialog:GetConfirmation() == true) then   
      Log("Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   -- Camera cut to M.
   SetOverrideCameraByName("Cam_MalistaireMedium", 0);
   
   gTutorialDialog:SetTitle("Tutorial_Title22"); -- "Malistaire"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");	
   ---gTutorialDialog:DoDialog("Don’t be so sure of yourself, old man!", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro019", -1, "Dialogue_Tutorial/TUT_Malistaire_019.mp3", false, malistaireId, 4.0);
   
   if(gTutorialDialog:WaitForNextButton() == true and
      gTutorialDialog:GetConfirmation() == true) then   
      Log("Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   -- Camera cut to back to player view
   SetOverrideCameraByName("", 0);
      
   gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	
   gTutorialDialog:HideSkipTutorialButton();
   ---gTutorialDialog:DoDialog("Run up and confront them! Be brave! I will guide you!", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro020", -1, "Dialogue_Tutorial/TUT_Ambrose_020.mp3", false, ambroseId, 5.0);
 
   UnfreezePlayer();
 
	-- Player now walks up and aggros the mobs	

   -- ROUND 1
   GetEvent("CombatUiVisible");     
   gTutorialDialog:SetTitle("Tutorial_Title6"); -- "Dueling"
   
   PlayMusic("Sound/Combat1Test.mp3");   
   
   -- Give 2 damage spells to player
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","player damage 1");
	FindAndConfigurePlanningPhase();	     
   HidePlanningPhase(true);
   HidePlanningPhase(false);
   ShowPassButton(false);
   
   ---gTutorialDialog:DoDialog("You’ve drawn these spells from your deck. Quickly! You must choose a spell and use it to attack one of Malistaire’s henchmen by clicking on him.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro021", -1, "Dialogue_Tutorial/TUT_Ambrose_021.mp3", false, ambroseId, 8.0);
   
   GetCardInteraction(true);  
   ReleasePlanningPhaseWindow();

   -- Wait for the ExecutionPhase to start to ensure we don't clear a mobs hand before
   -- they cast their spell. Otherwise, the spell cast will fail.
   GetEvent("ExecutionPhase");
    
   -- Clear mob 0's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 0");
   -- Clear mob 1's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 1");
   -- Give mob 0 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 2");
   -- Give mob 1 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 3");
   gTutorialDialog:ShowWindow(false);         
      
   
   --  Mob 0 Casts a spell at the player doing 50 points of damage
   -- Mob 1 casts a spell at the player doing 50 points fo damage
   -- Player casts a damage spell doing 105 (or 120) points of damage
	
   -- ROUND 2
   GetEvent("CombatHand");
   GetEvent("CombatUiVisible");
   FindAndConfigurePlanningPhase(); 
   HidePlanningPhase(true);
   -- Go thru the health & mana tutorial  
   TutorialHealthMana();
   
   gTutorialDialog:SetTitle("Tutorial_Title6"); -- "Dueling"
   gTutorialDialog:HideSkipTutorialButton();   
   ---gTutorialDialog:DoDialog("Where were we then? Right! Attack his henchmen again!", false);   
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro028", -1, "Dialogue_Tutorial/TUT_Ambrose_028.mp3", false, ambroseId, 5.0);   

   HidePlanningPhase(false);
   ShowPassButton(false);
   GetCardInteraction(true);
   ReleasePlanningPhaseWindow();

   -- Wait for the ExecutionPhase to start to ensure we don't clear a mobs hand before
   -- they cast their spell. Otherwise, the spell cast will fail.
   GetEvent("ExecutionPhase");
   
   -- Clear mob 0's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 0");
   -- Clear mob 1's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 1");
   -- Give mob 0 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 4");   
	--GetEvent("CombatTargetSelected");
	gTutorialDialog:ShowWindow(false);
   -- give heal spell for player to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","player heal");
	   
   -- Mob 0 Casts a spell at the player doing 90 points of damage
   -- Mob 1 Casts a spell at the player doing 105 points of damage
   -- Player casts a damage spell doing 120 (or 105) points of damage
   
   -- ROUND 3

   GetEvent("CombatHand");
   GetEvent("CombatUiVisible");
	FindAndConfigurePlanningPhase(); 
   HidePlanningPhase(true);
   
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");	
   ---gTutorialDialog:DoDialog("Aha! You doddering fool! Your student is no match for my forces!", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro029", 7.0, "Dialogue_Tutorial/TUT_Malistaire_029.mp3", false, malistaireId, 7.0);

   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	
   ---gTutorialDialog:DoDialog("Oh no! You’re in trouble! Quickly, use the [ name of spell – Heal ] spell and cast it on yourself. It will replenish your Health.", false);   
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro030", -1, "Dialogue_Tutorial/TUT_Ambrose_030.mp3", false, ambroseId, 9.0);   
   
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetCardInteraction(true);
   ReleasePlanningPhaseWindow();
   
   -- Wait for the ExecutionPhase to start to ensure we don't clear a mobs hand before
   -- they cast their spell. Otherwise, the spell cast will fail.
   GetEvent("ExecutionPhase");

   -- Clear mob 0's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 0");
   -- Clear mob 1's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 1");
   -- Give a debuff spell to mob 1 for NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob weakness"); 
	gTutorialDialog:ShowWindow(false);
   -- Give a spell for player to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","player damage 2");
   
   -- Mob 0 casts a spell at the player doing 85 points of damage   
   -- Mob 1 passes
   -- Player heals themself
      
   -- ROUND 4
   GetEvent("CombatUiVisible");
   FindAndConfigurePlanningPhase();   
   HidePlanningPhase(true);
   
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");	
   ---gTutorialDialog:DoDialog("Foolish creatures! You’ve let the young whelp heal! Defeat the whelp or you’ll suffer for it! Use your spells to weaken the young Wizard’s spells!", true);          
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro031", 13.0, "Dialogue_Tutorial/TUT_Malistaire_031.mp3", false, malistaireId, 11.0);            
   
   -- Camera cut to pips at player's feet
   SetOverrideCameraByName("Cam_PlayerFeet", 0.5);   
   
   Sleep (800);
   
   -- Give extra pips to player and update pips
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Give 3 pips to player");
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Update pips");
   -- UpdatePips triggers the UI to redisplay, so lets grab that event too
   GetEvent("OnUpdatePips");
   -- Update pips will have created a new planning phase window... we need to hide it again   
   HidePlanningPhase(true);
   
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
   ---gTutorialDialog:DoDialog("Here, young Wizard. Take this spell and some more Pips. They power your spells.", true);  
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro032", 5.0, "Dialogue_Tutorial/TUT_Ambrose_032.mp3", false, ambroseId, 5.0);  
   
   -- Camera cut back to planning phase view
   SetOverrideCameraByName("Cam_Planning", 0.5);

   ---gTutorialDialog:DoDialog("The more Pips you have, the stronger the spells you can cast!", true);  
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro033", 4.0, "Dialogue_Tutorial/TUT_Ambrose_033.mp3", false, ambroseId, 4.0);  
   
   ---gTutorialDialog:DoDialog("Quickly, now! Pick another spell and cast it at one of them!", false);   
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro034", -1, "Dialogue_Tutorial/TUT_Ambrose_034.mp3", false, ambroseId, 5.0);   
   
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetCardInteraction(true);
   ReleasePlanningPhaseWindow();
   
   -- Wait for the ExecutionPhase to start to ensure we don't clear a mobs hand before
   -- they cast their spell. Otherwise, the spell cast will fail.
   GetEvent("ExecutionPhase");

   -- Clear mob 0's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 0");
   -- Clear mob 1's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 1");
   -- Give mob 0 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 5");
   -- Give mob 1 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 6");
	gTutorialDialog:ShowWindow(false);    
   -- Give a blade to player for NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","player blade");
   
   -- Event driven dialog (audio only) when the hanging effect is triggered
   GetEvent("HangingEffectApplied");   
   Sleep(1000); 
   --gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
   ---gTutorialDialog:DoDialog("Oh my, that spell reduced the power of your own spell! ", true);        
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro034b", -1, "Dialogue_Tutorial/TUT_Ambrose_034b.mp3", false, ambroseId, 5.0);   
   Sleep(5000);
   --gTutorialDialog:ShowWindow(false);
   
   -- mob 0 passes
   -- Mob 1 casts weakness on player
   -- Player casts a spell for 300 damage - debuff
   
   -- ROUND 5
   GetEvent("CombatUiVisible");
	FindAndConfigurePlanningPhase();       
   HidePlanningPhase(true);
   
   --gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
   ---gTutorialDialog:DoDialog("Oh my, that spell reduced the power of your own spell! ", true);   
   --gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro034b", 5.0, "Dialogue_Tutorial/TUT_Ambrose_034b.mp3", false, ambroseId, 5.0);  
      
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");	
   ---gTutorialDialog:DoDialog("At last, you fools earn your keep! Now finish the child!", true);            
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro035", 5.0, "Dialogue_Tutorial/TUT_Malistaire_035.mp3", false, malistaireId, 5.0);           
   
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
   ---gTutorialDialog:DoDialog("Cast this Balanceblade spell on yourself. It will increase your next spell’s power!", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro036", -1, "Dialogue_Tutorial/TUT_Ambrose_036.mp3", false, ambroseId, 6.0);
   
   HidePlanningPhase(false);
   ShowPassButton(false);
   GetCardInteraction(true);
  
   -- Wait for the ExecutionPhase to start to ensure we don't clear a mobs hand before
   -- they cast their spell. Otherwise, the spell cast will fail.
   GetEvent("ExecutionPhase");

   -- Clear mob 0's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 0");
   -- Clear mob 1's play deck after this round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Clear hand mob 1");
   -- Give mob 0 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 7");
   -- Give mob 1 a damage spell to use NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","mob damage 8");
	gTutorialDialog:ShowWindow(false);    
   -- Give an AOE spell to player for NEXT round
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","player damage 3");
    
   -- Event driven dialog (audio only) when the hanging effect is triggered
   GetEvent("HangingEffectApplied");  
   Sleep(1000);   
   ---gTutorialDialog:DoDialog("This one learns fast, Malistaire! Two can play at that game!", false);  
   local soundID = gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro038b", -1, "Dialogue_Tutorial/TUT_Ambrose_038b.mp3", false, ambroseId, 4.0);
   FreezePlayer();
   local event = GetEvents("OnSoundFinished", "CombatUiVisible");
   if(event == "CombatUiVisible") then
      FindAndConfigurePlanningPhase();
      HidePlanningPhase(true);
	  if(soundID ~= 0) then
	     GetEvent("OnSoundFinished");
	  end
   else
      GetEvent("CombatUiVisible");
      FindAndConfigurePlanningPhase();
      HidePlanningPhase(true);
   end
   UnfreezePlayer();
   -- mob 0 casts a spell at the player doing 85 points of damage
   -- mob 1 casts a spell at the player doing 105 points of damage
   -- player casts a blade on themself
   
   -- ROUND 6
   DisableCard(0, true);
   -- Give extra pips to player and update pips
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","give 4 pips to player");
   gClientTutorial.RequestGoalCompletion("WC-TUT-C03-001","Update pips");
   -- UpdatePips triggers the UI to redisplay, so lets grab that event too
   
   GetEvent("OnUpdatePips"); 

   -- Update pips will have created a new planning phase window... we need to hide it again
   Sleep(2000);
   HidePlanningPhase(false);
   ShowPassButton(false);
   
   ---gTutorialDialog:DoDialog("I’ve got it! Use this Meteor Strike spell! It will strike both of the henchmen! Here are the Pips to cast it with!", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro037", 8.0, "Dialogue_Tutorial/TUT_Ambrose_037.mp3", false, ambroseId, 8.0);
   
   DisableCard(0, false);
   
   ---gTutorialDialog:DoDialog("With the [ name of spell – Blade ] spell you’ve already cast, the Meteor Strike spell should finish them off! Cast it now!", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro038", -1, "Dialogue_Tutorial/TUT_Ambrose_038.mp3", false, ambroseId, 7.0);
   GetCardInteraction(false);
   ReleasePlanningPhaseWindow();
	gTutorialDialog:ShowWindow(false);

   -- mob 0 casts a spell at the player doing 100 points of damage
   -- mob 1 casts a spell at the player doing 90 points of damage 
   -- player casts an AOE spell for 395 hp + buff, killing both mobs
   
   -- Both mobs should be dead now
   GetEvent("OnLeaveCombat");  
   RemoveInteraction(); -- Hide any UI elements that were created due to ending combat
   
   UnregisterEvent("OnLeaveCombat");
   UnregisterEvent("OpenPlanningPhase");   
   UnregisterEvent("CombatHand"); 
   UnregisterEvent("CombatUiVisible");
   UnregisterEvent("HangingEffectTriggered");
   UnregisterEvent("HangingEffectApplied");
   UnregisterEvent("ExecutionPhase");
   gClientTutorial.RequestRemoveQuest("WC-TUT-C03-001");  
end

