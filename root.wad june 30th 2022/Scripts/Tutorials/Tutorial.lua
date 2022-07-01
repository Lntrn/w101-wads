-- Tutorial.lua
-- Client side script that loads up the Tutorial gui and displays the dialog text allowing the user
-- to choose an item...

Include("Tutorials/TutorialMovement.lua")
Include("Tutorials/TutorialHealthMana.lua")
Include("Tutorials/TutorialCombat.lua")
Include("Tutorials/TutorialChat.lua")

function main()   
 
   RegisterEvent("OnTeleported"); 
   RegisterEvent("OpenSpellbook");
   RegisterEvent("CloseSpellbook");
   RegisterEvent("OnSoundFinished"); 

   -- Retrieve a reference to our client tutorial object.
   gClientTutorial = OpenClass(GetTutorial());
   Log("Entering tutorial at stage "..gClientTutorial.m_stage);
   gClientTutorial.SetTutuorialGUIState();

   RemoveInteraction();
   
   Sleep(1);
   
   -- Hide the bug reporter button if it isn't already hidden
   ShowGUIElements({"btnFeedback"}, false);
   ShowGUIElements({"btnMainWebPage"}, false);
      
   -- Set up and configure a global tutorial dialog for all tutorial scripts to use
   ResetTutorialDialog();           
   
   gClientTutorial.RequestRemoveQuest("WC-TUT-C05-001");
   gClientTutorial.RequestAddQuest("WC-TUT-C05-001");

   gClientTutorial.RequestAddQuest("WC-TUT-C08-001"); -- Add only. Don't remove this quest
   
   -- Only give the option to skip the tutorial if we have the zone data for Wizard City
   -- and if this is NOT the first character to be created
   gSkipOK = IsWorldReady();     
   if(GetFirstCharacterCreation() == 0) then
      gFirstCharacterCreation = false;
   else
      gFirstCharacterCreation = true;
   end
   
   --TODO: REMOVE THIS LINE FOR PRODUCTION:
   --gSkipOK = false;
   
   -- Currently, no need to call TestCannotPlayAnimation for malistaireId or gammaId (Therfore, the code for that future option is put in comment):
   
   local ambroseId = GetClientID(39394);   
   local cannotPlayAmbroseAnimation = TestCannotPlayAnimation(ambroseId);
    
   --local malistaireId = GetClientID(77831);   
   local cannotPlayMalistaireAnimation = 0; -- TestCannotPlayAnimation(malistaireId);
    
   --local gammaId = GetClientID(39396);
   local cannotPlayGammaAnimation = 0; -- TestCannotPlayAnimation(gammaId);
   
   if (cannotPlayAmbroseAnimation == 1 or cannotPlayMalistaireAnimation == 1 or cannotPlayGammaAnimation == 1) then
      if (cannotPlayAmbroseAnimation == 1) then
         Log("Error: Cannot play Ambrose animations"); 
      end
	  if (cannotPlayMalistaireAnimation == 1) then
         Log("Error: Cannot play Malistaire animations"); 
      end
	  if (cannotPlayGammaAnimation == 1) then
         Log("Error: Cannot play Gamma animations"); 
      end
   
	  Log("Error: Cannot play animations - Skipping Tutorial!");   
      UnfreezePlayer();
      SkipTutorial();
      return false;
   end

   if(gClientTutorial.m_stage == 0) then   
   
      local ambroseId = GetClientID(39394);
	  
      ConfigureHUD(gClientTutorial.m_stage);   
      FreezePlayer();
      
      gTutorialDialog:SetTitle("Tutorial_Title19"); -- "Tutorial"
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");      
      gTutorialDialog:SetConfirmationTitle("Tutorial_Tutorial_Confirmation_Title");
      gTutorialDialog:SetConfirmationMessage("Tutorial_Tutorial_Confirmation_Text");
      gTutorialDialog:SetConfirmationYesLabel("Tutorial_Tutorial_Confirmation_Yes");
      gTutorialDialog:SetConfirmationNoLabel("Tutorial_Tutorial_Confirmation_No");   
      gTutorialDialog:MoveToBottom();
	  
      ---gTutorialDialog:SetMessage("Well, hello! If it isn’t our newest student!");
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro001", -1, "Dialogue_Tutorial/TUT_Ambrose_001.mp3", false, ambroseId, 4.0);
	  
      if(gSkipOK and not gFirstCharacterCreation) then
         gTutorialDialog:ShowSkipTutorialButton();
      else
         Sleep(4000);
      end
	  
	  gFirstScreen = true;
	  
      if(gTutorialDialog:WaitForNextButton(ambroseId) == true      and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end
	  
	  gFirstScreen = false;

      
      TutorialMovement();  

      gClientTutorial.RequestAdvanceStage(1);
   end          
 
   if(gClientTutorial.m_stage == 1) then    
   
      local ambroseId = GetClientID(39394);
	  local gammaId = GetClientID(39396);
   
      --Stop any Camera Shake that may be running
      StopCameraShake();    
   
      -- Kill the rain in case it is still going on in the zone (from logging out and back in)
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","StopRain");       

      -- turn Ambrose to face Gamma     
      gClientTutorial.FaceClientObject(ambroseId, gammaId, 0.5);

      ConfigureHUD(gClientTutorial.m_stage);              
      
      gTutorialDialog:SetTitle("Tutorial_Title3"); -- "Gamma the Owl"
      
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");
      gTutorialDialog:MoveToBottom();  
	  
      -- Camera Zoom on Gamma
      SetOverrideCameraByName("Cam_GammaCU", 1);

      gTutorialDialog:SetTitle("Tutorial_Title19"); -- "Tutorial"  
      gTutorialDialog:SetConfirmationTitle("Tutorial_Tutorial_Confirmation_Title");
      gTutorialDialog:SetConfirmationMessage("Tutorial_Tutorial_Confirmation_Text");
      gTutorialDialog:SetConfirmationYesLabel("Tutorial_Tutorial_Confirmation_Yes");
      gTutorialDialog:SetConfirmationNoLabel("Tutorial_Tutorial_Confirmation_No");   

      if(gSkipOK and not gFirstCharacterCreation) then
         gTutorialDialog:ShowSkipTutorialButton();
      end

      ---gTutorialDialog:DoDialog("Hellooo! My name is Gamma the Owl, and I am quite pleased to meet yooou!", true);
      -- The reason I'm changing all of these delays to -1 is because they were already broken and I needed to change it to
      -- get the tutorial skip button to work.  I checked on Live:  Only the first dialog pane delays the next button on 
      -- a first character on a new account, the rest of the dialogs are not delaying the NextButton anyway, so there's no
      -- change for me to make them all -1.
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro006", -1, "Dialogue_Tutorial/TUT_Gamma_006.mp3", false, gammaId, 4.0);
	  
      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end
	  
      ---gTutorialDialog:DoDialog("Wizards test their skills by summoning fantastic creatures and dueling!", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro007", -1, "Dialogue_Tutorial/TUT_Gamma_007.mp3", false, gammaId, 5.0);
      
      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end
      
      ---gTutorialDialog:DoDialog("To become a Master Wizard, you must learn every spell in your class!", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro008", -1, "Dialogue_Tutorial/TUT_Gamma_008.mp3", false, gammaId, 4.0);
      
      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end
      
      ---gTutorialDialog:DoDialog("Wizards love to duel! The more spells you learn, the better a duelist you will become.", true);     
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro009", -1, "Dialogue_Tutorial/TUT_Gamma_009.mp3", false, gammaId, 5.0); 	  

      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end

      -- Back to player camera
      SetOverrideCameraByName("", 0);	
	   
      gTutorialDialog:ShowWindow(false);
      FreezePlayer();

      --  Trigger fx and state changes indicating M's arrival
      
      PlaySoundOnce("Ambient_Tutorial/tut_earthquake_start.mp3");
      Sleep(1000);
      
      -- Quake style camera shake for 8.5 seconds at mangitude 7
      StartCameraShake("Quake", 8.5, 7);            
      
      Sleep(2000);
      
      -- Trigger dramatic music, looping
      PlayMusic("Sound/Tutorial_Storm_Music.mp3");
      
      -- Camera pan to top of tower
      SetOverrideCameraByName("Cam_TowerMedium", 2);     
      
      Sleep(1000);
      
      -- Despawn the static Ambrose
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Despawn Ambrose Outside");  
      
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Trigger Storm");  
      
      Sleep(2000);
      
      -- move player to new location so they can see Ambrose walk to the tower
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Transplant Player");     

      -- Camera pan to window close-up
      SetOverrideCameraByName("Cam_WindowMal", 2); 
   
      Sleep(1000);
   
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Trigger Rubble"); 
      
      Sleep(2000);
      
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Trigger Silhouette");      
      
       Sleep(3000);
      
      -- Camera pan back to top of tower
      --SetOverrideCameraByName("Cam_TowerMedium", 2);         
      
      gTutorialDialog:SetTitle("Tutorial_Title3"); -- "Gamma the Owl"
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");
	  
      ---gTutorialDialog:DoDialog("Whoooo?!?", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro010", -1, "Dialogue_Tutorial/TUT_Gamma_010.mp3", false, gammaId, 1.0);            
      
      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end      
      
      -- Spawn the walking Ambrose
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Walk Ambrose");      
      
      -- Camera pan back to player view
      SetOverrideCameraByName("", 2);      
      
      -- turn Ambrose to face player
      --local playerId = GetCharacterGID();
      --local ambroseId = GetClientID(39394);
      --gClientTutorial.FaceClientObject(ambroseId, playerId, 0.5);
      
      gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");  
	  
      ---gTutorialDialog:DoDialog("How odd! Come along, young Wizard. Let’s investigate the matter! Meet me in the tower!", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro011", -1, "Dialogue_Tutorial/TUT_Ambrose_011.mp3", false, gammaId, 7.0);
      
      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end      
      
      gTutorialDialog:SetTitle("Tutorial_Title3"); -- "Gamma the Owl"
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");
	   
      ---gTutorialDialog:DoDialog("Yooou’d best follow the headmaster. You’re safe with him!", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro012", -1, "Dialogue_Tutorial/TUT_Gamma_012.mp3", false, gammaId, 4.0);           

      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end
      
      -- Stop listeneing for rewards so we don't tip off the player that we're giving the wand now
      StopListeningForRewards();
      
      UnfreezePlayer();    
      
      gClientTutorial.RequestAdvanceStage(2);
   end
   
   if(gClientTutorial.m_stage == 2) then   
   
      local gammaId = GetClientID(39396);
	  
      ConfigureHUD(gClientTutorial.m_stage);      
      	    
      PlayMusic("Sound/Tutorial_Storm_Music.mp3"); 
         
      -- turn on the golem tower quest light
      gClientTutorial.RequestRemoveQuest("WC-TUT-C03-002");
      gClientTutorial.RequestAddQuest("WC-TUT-C03-002");                      
      gClientTutorial.RequestRemoveQuest("WC-TUT-C03-002");        
         
      gTutorialDialog:SetTitle("Tutorial_Title3"); -- "Gamma the Owl"
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");             
      gTutorialDialog:HideSkipTutorialButton();
	   
      ---gTutorialDialog:DoDialog("To the tower!", false);      
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro013", -1, "Dialogue_Tutorial/TUT_Gamma_013.mp3", false, gammaId, 1.0);      
	        
      SetCanShowInteraction(false);             
      UnfreezePlayer();            
      
      GetEvent("OnTeleported"); 
      RemoveInteraction(); -- squash any unwanted UI elements that may have popped up
      SetCanShowInteraction(true);    
      ResetTutorialDialog();                        
      
      gClientTutorial.RequestAdvanceStage(3);
   end
   
   if(gClientTutorial.m_stage == 3) then   
      ConfigureHUD(gClientTutorial.m_stage);
      gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
      
      PlayMusic("Sound/Tutorial_Storm_Music.mp3"); 
      
      -- Refill mana and health to 100%
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
      gClientTutorial.RequestAddQuest("WC-TUT-C09-014");     
      gClientTutorial.RequestAddQuest("WC-TUT-C09-016");
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
	  
	  local ambroseId = GetClientID(39394);
	  local malistaireId = GetClientID(77831); 
      
      -- turn Ambrose to face Malistaire      
      gClientTutorial.FaceClientObject(ambroseId, malistaireId, 0.0);    
	    
      TutorialCombat();
      
      -- Resume listeneing for rewards 
      StartListeningForRewards(); 
       
      gClientTutorial.RequestAdvanceStage(4);
   end
   
   if(gClientTutorial.m_stage == 4) then            
   
	  local ambroseId = GetClientID(39394);
	  local malistaireId = GetClientID(77831); 
   
      ConfigureHUD(gClientTutorial.m_stage);
      gTutorialDialog:SetTitle("Tutorial_Title20"); -- "Victory!"
               
      -- Camera cut to A.
      SetOverrideCameraByName("Cam_AmbroseMedium", 1.5);
      
      -- turn Ambrose to face Malistaire      
      gClientTutorial.FaceClientObject(ambroseId, malistaireId, 0.5);      
   
      PlayMusic("Sound/Tutorial_Storm_Music.mp3", 1.0, 3.0, false);
            
      gTutorialDialog:MoveToBottom();
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");   
	   
      ---gTutorialDialog:DoDialog("Excellent work, young Wizard! Now let me see to Malistaire… I’ll show him... threatening a new student before orientation, no less! ", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro039", 11.0, "Dialogue_Tutorial/TUT_Ambrose_039.mp3", false, ambroseId, 11.0);                 
	  
      -- Camera cut to M.
      SetOverrideCameraByName("Cam_MalistaireMedium", 0);
      
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Mallistaire.dds");   
	  
      ---gTutorialDialog:DoDialog("Another time, old man... I have what I came for.", true);  
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro040", 5.0, "Dialogue_Tutorial/TUT_Malistaire_040.mp3", false, malistaireId, 5.0);                    
	   
      ---gTutorialDialog:DoDialog("And now, I’ll take my leave of this wretched place.", true);
	  -- Do not animate malistaire as he is being Despawn shortly after
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro041", -1, "Dialogue_Tutorial/TUT_Malistaire_041.mp3", false);      
	  
      FreezePlayer();
      
      -- STOP DANCING!!!
      local playerObjId = GetCharacterGID();
      PlayAnimation(playerObjId, "Idle");
      
      -- back to player cam
      SetOverrideCameraByName("", 3);
      
      Sleep(500);
      
      --Despawn Malistaire
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Despawn Malistaire");     
      
      Sleep(3500);   
      
      gTutorialDialog:ShowNextButton();
      gTutorialDialog:WaitForNextButton();
      
      UnfreezePlayer();
      
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
	   
      ---gTutorialDialog:DoDialog("He's gone, and none too soon! What sinister goal brought him here? Hmm...", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro041b", 8.0, "Dialogue_Tutorial/TUT_Ambrose_041b.mp3", false, ambroseId, 8.0);      
	   
      -- turn Ambrose to face player
      local playerId = GetCharacterGID();      
      gClientTutorial.FaceClientObject(ambroseId, playerId, 0.5);	  
      
      gClientTutorial.RequestAdvanceStage(5);
   end
   
   if(gClientTutorial.m_stage == 5) then   
   
      local ambroseId = GetClientID(39394);
	  	  
      ConfigureHUD(gClientTutorial.m_stage);
      gTutorialDialog:SetTitle("Tutorial_Title21"); -- "Experience"
      
      SetOverrideCameraByName("Cam_Staff", 1.5);            
      
      PlayMusic("Sound/Menu.mp3", 1.0, 10.0, false);
      
      -- temporarily hide the real XP bar
      gExpBar = gExpBar or OpenClass(FindNamedWindow("XPBar"));
      if(gExpBar == nil) then
         Log("ERROR: Could not find XPBar.");
      end
      gExpBar.SetVisible(false);      
            
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	  	 
	  	  
      gTutorialDialog:SetConfirmationTitle("Tutorial_Tutorial_Confirmation_Title");
      gTutorialDialog:SetConfirmationMessage("Tutorial_Tutorial_Confirmation_Text");
      gTutorialDialog:SetConfirmationYesLabel("Tutorial_Tutorial_Confirmation_Yes");
      gTutorialDialog:SetConfirmationNoLabel("Tutorial_Tutorial_Confirmation_No");

      ---gTutorialDialog:DoDialog("Oh my! You look a bit worse for wear. Here, let me restore you to your full Health and Mana.", true);                                             
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro042", 7.0, "Dialogue_Tutorial/TUT_Ambrose_042.mp3", false, ambroseId, 7.0);                                             
            
      -- Refill mana and health to 100%
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-016");
      gClientTutorial.RequestAddQuest("WC-TUT-C09-014");     
      gClientTutorial.RequestAddQuest("WC-TUT-C09-016");
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-014");
      gClientTutorial.RequestRemoveQuest("WC-TUT-C09-016");             

      ---gTutorialDialog:DoDialog("On the bright side, congratulations! Defeating Malistaire’s henchmen has earned you some experience.", true); 
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro043", 7.0, "Dialogue_Tutorial/TUT_Ambrose_043.mp3", false, ambroseId, 7.0); 
	 
      gTutorialDialog:ShowWindow(false);
      
      -- show experience bar in the middle of the screen, empty   
      local gExpBarPic = CreateSpriteClass("Art/Art_Bar_Exp02.dds",MakeRectString(0,0,504,19),false,nil);
      gExpBarPic.SetLocation( 50, 250 );
      gExpBarPic.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
      gExpBarPic.m_Flags = "HCENTER";
      gExpBarPic.SetVisible(true);
      
      --SetOverrideCameraByName("", 1.5);
      
      -- this experience bar will help you track   
      gTutorialDialog:MoveToTop(); 
	  
      ---gTutorialDialog:DoDialog("This experience bar will help you track your progress.", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro044", 4.0, "Dialogue_Tutorial/TUT_Ambrose_044.mp3", false, ambroseId, 4.0);	  
      
      gExpBar.SetVisible(true);
      gExpBarPic.SetVisible(false);
      gExpBar.SetLocation( 50, 250 );
      local expProgress = gExpBar.FindNamedWindow("progressXPSolid");
      if(expProgress == nil) then
         Log("ERROR: Could not find exp progress.");
      end      
      
      -- add the correct amount of exp for the kill on the bar   
      -- move and shrink it to the correct spot   
      local anim = MakeMoveAnimation( 0, GetScreenHeight() - 32, 0.3 );
      gExpBar.PushAnimation( anim );
      
      FreezePlayer();
      
      WaitForAnimationsToFinish( gExpBar );   
      
      -- when the bar fills up, you gain a level
      ---gTutorialDialog:DoDialog("When the bar fills up, you’ll gain a level and be able to learn new spells.", false);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro045", 5.0, "Dialogue_Tutorial/TUT_Ambrose_045.mp3", false, ambroseId, 5.0);
      
      gClientTutorial.RequestAdvanceStage(6);
   end   
   
   if(gClientTutorial.m_stage == 6) then             
      ConfigureHUD(gClientTutorial.m_stage);     
      gTutorialDialog:SetTitle("Tutorial_Title12"); -- "Chatting"      
      
      SetOverrideCameraByName("Cam_Staff", 0);
      
      PlayMusic("Sound/Menu.mp3");
      FreezePlayer();
      TutorialChat();           
      gClientTutorial.RequestAdvanceStage(8);
   end      
   
   if(gClientTutorial.m_stage == 8) then
   
      local ambroseId = GetClientID(39394);
   
      ConfigureHUD(gClientTutorial.m_stage);     
      gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
      
      gClientTutorial.RequestUnequipWand();
      
      FreezePlayer();

      local spellbookButton = OpenClass(FindNamedWindow("btnSpellbook"));
      if(spellbookButton == nil) then
         Log("Could not find spellbook button to hide!");
      else
         -- Spellbook is supposed to be hidden at this point, so make sure it's hidden.
         spellbookButton.SetVisible(false);
      end   
      
      GetSpellBookPage("Help", false);
      
      SetOverrideCameraByName("Cam_Staff", 0);
                  
      PlayMusic("Sound/Menu.mp3");         
      
      gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");               
	  
      ---gTutorialDialog:DoDialog("You'll also need a spellbook and a wand. Here you go. No young Wizard should ever be without them.", true);
      local soundID = gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro052", -1, "Dialogue_Tutorial/TUT_Ambrose_052.mp3", false, ambroseId, 6.0);
	  	  
	  if(soundID ~= 0) then
		GetEvent("OnSoundFinished");	
      else
        Sleep(3000);
      end		
      
      -- New Wand gets a glare effect
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Trigger Wand Effect");                     
      
      Sleep(300);
      
      -- Make sure the deck is equipped before this is called
      gClientTutorial.RequestEquipItems();  -- Equip the wand                    
              
      Sleep(1700);
      
      gTutorialDialog:ShowWindow(false);      
      
      -- Now display a large sprite of the spellbook.
      local spellbookImage = CreateSpriteClass("HUD/Button_Spellbook.dds",MakeRectString(0,0,128,128),false,nil);
      spellbookImage.SetLocation( (GetScreenWidth()/2) - 64, (GetScreenHeight()/2) - 64 );
      spellbookImage.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
      spellbookImage.SetVisible(true);
      
      Sleep(500);
      
      local anim = MakeScaleAnimation( 2.0, 0.2 );   
      spellbookImage.PushAnimation( anim );
      WaitForAnimationsToFinish( spellbookImage );
      
      Sleep(1000);
      
      anim = MakeScaleAnimation( 1.0, 0.3 );   
      spellbookImage.PushAnimation( anim );
      
      -- Animate the spellbook to the bottom corner of the screen
      anim = MakeMoveAnimation( GetScreenWidth() - (128), GetScreenHeight() - (128), 0.3 );
      spellbookImage.PushAnimation( anim );
      WaitForAnimationsToFinish( spellbookImage );
      
      Sleep(1000);     
      
      ---gTutorialDialog:DoDialog("I should say, young Wizard, that I was quite impressed with your courage. There is little doubt but that a great destiny awaits you.", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro053", 9.0, "Dialogue_Tutorial/TUT_Ambrose_053.mp3", false, ambroseId, 9.0);
      
      gTutorialDialog:ShowWindow(true);
      
      --gTutorialDialog:ShowNextButton();
      --gTutorialDialog:WaitForNextButton();      
      
      ---gTutorialDialog:DoDialog("Who knows? Maybe you will fill my shoes and become headmaster someday.", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro054", 5.0, "Dialogue_Tutorial/TUT_Ambrose_054.mp3", false, ambroseId, 5.0);
	  
      ---gTutorialDialog:DoDialog("But now, if you’ll excuse me, I have a mountain of duties to attend to right now, including readying your enrollment.", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro055", 7.0, "Dialogue_Tutorial/TUT_Ambrose_055.mp3", false, ambroseId, 7.0);
      
      ---gTutorialDialog:DoDialog("So if you don’t mind waiting for a moment or two, I’ll pop back to my office and straighten up.", true);
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro056", 5.0, "Dialogue_Tutorial/TUT_Ambrose_056.mp3", false, ambroseId, 5.0);
      
      ---gTutorialDialog:DoDialog("I’ll summon you when things are presentable. So many books and papers to tidy up… where did I put those forms… See you soon!", false);            
      gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro057", 12.0, "Dialogue_Tutorial/TUT_Ambrose_057.mp3", false, ambroseId, 10.0);                        
	  
      gTutorialDialog:HideNextButton();	  	 
      
      FreezePlayer();
	  
	  Sleep(500);
      
      -- Despawn Ambrose
      gClientTutorial.RequestGoalCompletion("WC-TUT-C05-001","Despawn Ambrose Inside");                
            
      Sleep(2500);
      -- pan back to player cam
      SetOverrideCameraByName("", 1.5);      
      Sleep(1500);
      UnfreezePlayer();
      
      -- restore the bug reporter button to it's pre-tutorial visibility
      RestoreGUIElements({"btnFeedback"});
      RestoreGUIElements({"btnMainWebPage"});
      
      gTutorialDialog:SetTitle("Tutorial_Title23"); -- "Please Wait..."
      gTutorialDialog:MoveToTop();
      
      
      local progressWindow = CreateGUIClass("ClientPatcherOverlay.gui", true);
      progressWindow.ShowWindow(false);       
      
      gTutorialProgressBar = gTutorialProgressBar or OpenClass(OpenWindow("TransferProgressBar"));
      local guiVisible = false;
      
      -- Sleep for totalSleep milliseconds or until the necessary WADs are patched, whichever is LONGER
      local sleepAmt = 250; -- in milliseconds
      local totalSleep = 5000; -- Wait at least this long before ending tutorial so Merle has time to despawn
      local sleepTillOverlay = 7000; -- Wait at least this long before displaying the patcher overlay
      local elapsedTime = 0;       
      while(elapsedTime < totalSleep or not IsWorldReady()) do
         local event = GetEvent("", false);
         if(event) then
            if (event.EventName == "OpenSpellbook") then
               -- hide the dialog
               gTutorialDialog:ShowWindow(false);
            elseif (event.EventName == "CloseSpellbook") then
               -- show the dialog
               gTutorialDialog:ShowWindow(true);            
            elseif (event.LUA_CallBack) then
               -- Allow lua Callback, if provided
               event.LUA_CallBack( event );              
            end
         end
         
         if(elapsedTime > sleepTillOverlay) then
            if(not guiVisible) then
               progressWindow.ShowWindow(true);              
               guiVisible = true;
               gTutorialDialog:HideNextButton();
            end            
            UpdatePatcherOverlay();
         end
         
         Sleep(sleepAmt);
         elapsedTime = elapsedTime + sleepAmt;
      end                                                           
      
      progressWindow.DetachSelf();  
      
      gClientTutorial.RequestGoalCompletion("WC-TUT-C08-001","Teleport");                        
      gClientTutorial.RequestRemoveQuest("WC-TUT-C05-001");
      GetEvent("OnTeleported");               
      gClientTutorial.UnsetTutuorialGUIState();
      ShowTips(true);
      RestoreInteraction(); 
      RestoreFriendsListButton();
      RemapKeys();       
      gClientTutorial.RequestGoalCompletion("Tutorial_Intro","OnlyGoal");
      SetFirstCharacterCreation(false);
      
      UnregisterEvent("OnTeleported"); 
      UnregisterEvent("OpenSpellbook");
      UnregisterEvent("CloseSpellbook");
   end
end

function TestCannotPlayAnimation(aClientObjectID)
   local cannotPlayAnimation = 0;
   if (aClientObjectID ~= 0) then
      local canPlayAnimation = 0;
	  local canPlayAnimationTries = 0;	  
	  while (canPlayAnimation == 0 and canPlayAnimationTries < 5) do
		canPlayAnimationTries = canPlayAnimationTries + 1;
		canPlayAnimation = CanPlayAnimation(aClientObjectID, "Gen_Dial_01");
		if (canPlayAnimation == 0) then
		   Sleep(250);
		end
	  end 
	  
	  if (canPlayAnimation == 0) then
         cannotPlayAnimation = 1;		 
      end
   end
   
   return cannotPlayAnimation;
end
