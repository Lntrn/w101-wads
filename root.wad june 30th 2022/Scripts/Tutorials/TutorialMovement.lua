-- TutorialMovement.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");

function TutorialMovement()   
   FreezePlayer();
   
   gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"

   -- get an ID for Gamma
   local entID = GetClientID(39396);
   local ambroseId = GetClientID(39394);
   
	-- hide his wizbang.
	SetWizbang(entID, 0);
	SetCanShowInteraction(false); 

   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds"); 

   -- Camera Zoom on Merle
   SetOverrideCameraByName("Cam_Ambrose_CU", 1);

   ---gTutorialDialog:Display("My name is Merle Ambrose. I am the headmaster of the Ravenwood School of Magical Arts.", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro002", -1, "Dialogue_Tutorial/TUT_Ambrose_002.mp3", false, ambroseId, 7.0);
   
      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end

	---gTutorialDialog:Display("We’re expecting great things from you. But first things, first.", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro003", -1, "Dialogue_Tutorial/TUT_Ambrose_003.mp3", false, ambroseId, 5.0);

      if(gTutorialDialog:WaitForNextButton() == true and
         gTutorialDialog:GetConfirmation() == true) then   
         Log("Skipping Tutorial!");   
         UnfreezePlayer();
         SkipTutorial();
         return false;
      end

    -- back to player cam
    SetOverrideCameraByName("", 0);

	-- display pic of arrow keys
	local keyboardImage = CreateSpriteClass("Art/Art_Keyboard_Arrows.dds",MakeRectString(0,0,204,118),false,nil);
	keyboardImage.SetLocation( (GetScreenWidth()/2) - (204/2), GetScreenHeight()/9 );--((GetScreenHeight()/2) - (118/2))+100 );
	keyboardImage.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	keyboardImage.ShowWindow(true);
	-- allow player to move around
	-- cycle through pictures
	
   gTutorialDialog:SetTitle("Tutorial_Title2"); -- "Movement"
   
   RegisterEvent("OnInteractWithNPC");
   RegisterEvent("OnNPCInteractionShown");
   RegisterEvent("OnNPCInteractionClosed");     
   
   RegisterEvent("OnPlayerMoved");
   UnfreezePlayer();
   
   gTutorialDialog:HideSkipTutorialButton();  
   
   ---gTutorialDialog:Display("To move around, use the arrow keys on your keyboard. Try it, now.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro004", -1, "Dialogue_Tutorial/TUT_Ambrose_004.mp3", true, ambroseId, 5.0);
   
   if(not gSkipOK) then
      Sleep(5000);
   end
   
   SetCanShowInteraction(true);   
   

	GetEvent("OnPlayerMoved");
	UnregisterEvent("OnPlayerMoved");
   
	-- remove pic
	keyboardImage.DetachSelf();		
	
	-- place a wizbang over gamma's head	
	SetWizbang(entID, 3);
	
	---gTutorialDialog:Display("My owl friend would like to speak with you. Walk up to him and follow his instructions to talk.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro005", -1, "Dialogue_Tutorial/TUT_Ambrose_005.mp3", true, ambroseId, 8.0);
   UnfreezePlayer();

   -- Hide the dialog if we are w/in range of NPC; show it again if we leave range w/out interacting w/NPC
	while(true) do   
		local event = GetEvent();
		if(event.EventName == "OnNPCInteractionClosed") then
			gTutorialDialog:ShowWindow(true);
		elseif(event.EventName == "OnInteractWithNPC") then
			break;
		elseif(event.EventName == "OnNPCInteractionShown") then
			gTutorialDialog:ShowWindow(false);
		end;
	end;
      
   UnregisterEvent("OnNPCInteractionShown");
   UnregisterEvent("OnNPCInteractionClosed");
   UnregisterEvent("OnNPCInteractWithNPC");
	
   FreezePlayer();
   gTutorialDialog:ShowWindow(false);
	SetWizbang(entID, 0);	
   UnregisterEvent("OnPlayerMoved");
end
