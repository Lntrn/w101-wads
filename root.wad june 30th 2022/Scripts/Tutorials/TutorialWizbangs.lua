-- TutorialWizbangs.lua
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("API/ControlClasses.lua");

function TutorialWizbangs()	
   RegisterEvent("OnNPCInteractionShown");
   RegisterEvent("OnInteractWithNPC");
   RegisterEvent("OnNPCInteractionClosed");
   
   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
   tutorialDialog:SetTitle("Tutorial_Title7");
   tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
   tutorialDialog:SetMessage("Tutorial_Tutorial_Combat14"); -- "Speak to Mr. Lincoln..."
	tutorialDialog:HideNextButton();	
   tutorialDialog:MoveToBottom();   
	
   -- loop until we get an ID for Lincoln
   local entID = -1;
   local count = 0;
   local maxCount = 10;
   for count = 0, maxCount do
      -- get a ref to Gamma
      entID = FindClientObjectInWorldByTemplateID(43118);
      if(tonumber(entID) == nil) then  
         break;
      end;
      Sleep(500); -- sleep for 1/2 second
   end;   
   if(count == maxCount) then
      Log("WARNING - could not find client object for Mr. Lincoln in Wizbangs Tutorial!");
   end;
   
   SetWizbang(entID,3);
	
   UnfreezePlayer();
   
	local playerID = GetCharacterGID();	
	
	--SetCanShowInteraction(true);
	
 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingForMoveToRegistrar");

	-- Wait until we get close to him
	GetEvent("OnNPCInteractionShown");
	-- Hide our dialog window
	tutorialDialog:ShowWindow(false);	

 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingForInteraction");
   
   -- Hide the dialog if we are w/in range of NPC; show it again if we leave range w/out interacting w/NPC
	while(true) do   
		local event = GetEvent();
		if(event.EventName == "OnNPCInteractionClosed") then
			tutorialDialog:ShowWindow(true);
		elseif(event.EventName == "OnInteractWithNPC") then
			break;
		elseif(event.EventName == "OnNPCInteractionShown") then
			tutorialDialog:ShowWindow(false);

			--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
			--where we are in the tutorial
			SendEvent("Tutorial_WaitingForInteraction");
		end;
	end;   
   
    FreezePlayer();
	
	local clientTutorial = OpenClass(GetTutorial());
	
	--SetCanShowInteraction(false);

    -- if entity was found, proceed.
    if entID ~= nil then
        -- Display the dialog and wait for next
        tutorialDialog:SetMessage("Tutorial_Tutorial_Wizbang1");    -- Ahh I see you have won your first duel...
		tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
        tutorialDialog:ShowWindow(true);
		tutorialDialog:ShowNextButton();

	 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
		--where we are in the tutorial
		SendEvent("Tutorial_LectureText");

        tutorialDialog:WaitForNextButton();

        SetWizbang(entID, 3);
        tutorialDialog:SetMessage("Tutorial_Tutorial_Wizbang2");    -- You may notice the yellow question mark...
        tutorialDialog:ShowWindow(true);

	 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
		--where we are in the tutorial
		SendEvent("Tutorial_LectureText");

        tutorialDialog:WaitForNextButton();

        SetWizbang(entID, 1);
        tutorialDialog:SetMessage("Tutorial_Tutorial_Wizbang3");    -- A Yellow exclamation point would mean...
        tutorialDialog:ShowWindow(true);

	 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
		--where we are in the tutorial
		SendEvent("Tutorial_LectureText");

        tutorialDialog:WaitForNextButton();

        SetWizbang(entID, 2);
        tutorialDialog:SetMessage("Tutorial_Tutorial_Wizbang4");    -- A silver question mark means...
        tutorialDialog:ShowWindow(true);

	 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
		--where we are in the tutorial
		SendEvent("Tutorial_LectureText");

     tutorialDialog:WaitForNextButton();

     -- Clear the Wizbang
     SetWizbang(entID, 0);        
    end
	
   UnregisterEvent("OnNPCInteractionShown");
   UnregisterEvent("OnInteractWithNPC");
end

