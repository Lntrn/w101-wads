-- TutorialTraining.lua

Include("Tutorials/API/TutorialCommon.lua");
Include("Tutorials/API/TutorialUtility.lua");

maxOptionNumber = 8;

---------------------------------------------------------------------------------------------------------
-- Wait until we sense they have selected a spell from the list
---------------------------------------------------------------------------------------------------------
function WaitForSpellSelection()
   RegisterEvent("WB_BUTTONUP");
   while ( true ) do
      local event = GetEvent("WB_BUTTONUP");
      
      -- if we a get a button event, for an Option button, return
      if ( event.EventName == "WB_BUTTONUP" ) then
         for optionNum = 1, maxOptionNumber do
            if ( event.Name == "Option_"..optionNum ) then
               UnregisterEvent("WB_BUTTONUP");
               return;
            end
         end
      end
   end
   DebugLog("WaitForOptionSelection prematurely ended!");
end

---------------------------------------------------------------------------------------------------------
-- Wait until we sense they have selected the train button
---------------------------------------------------------------------------------------------------------
function WaitForTrainButton()
   RegisterEvent("WB_BUTTONUP");
   while ( true ) do
      local event = GetEvent("WB_BUTTONUP");
      if ( event.EventName == "WB_BUTTONUP" and event.Name == "Train" ) then
         break;
      end
   end   
   UnregisterEvent("WB_BUTTONUP");
end


---------------------------------------------------------------------------------------------------------
function TutorialTraining()
   DebugLog("TutorialTraining");

   RegisterEvent("OnTrainingOpened");      
   RegisterEvent("OnTrainingComplete");
   
   -- temporarily disable npc interaction
   SetCanShowInteraction(false);
   UnmapKey("NPCInteract");

   -- Block mouse clicks to entire scene (except for dialogs)
   local worldWin = OpenClass(GetWorldWindow());
   local mouseBlock = CreateClass("Window");
   mouseBlock.SetName("MouseBlock");
   mouseBlock.SetFlags(0x000c0001); -- (PARENT_SIZE | VISIBLE)
   worldWin.AttachWindow(mouseBlock);    

   -- Display large image depicting other worlds
	local tutorialCard = CreateSpriteClass("Backgrounds/Background_Subscribe.dds",MakeRectString(0,0,590,386),false,nil);
	tutorialCard.SetLocation(((GetScreenWidth()/2) - (590/2)), ((GetScreenHeight()/2) - (396/2)-100));
	tutorialCard.SetStyle(0x1300); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	tutorialCard.ShowWindow(true);   
   
   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
   tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");      
   tutorialDialog:SetTitle("Tutorial_Title14");   
   tutorialDialog:SetMessage("Tutorial_Tutorial_Training1"); -- 'Participating in Duels gives you experience points. With enough experience points, you will gain a new level.'
   tutorialDialog:MoveToBottom();
   
 	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();      
   
   --------------------------------------------------------------------------
   -- Set Message 'Every time you gain a level, you earn Training Points.'
   tutorialDialog:SetMessage("Tutorial_Tutorial_Training2");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
   
   tutorialCard.ShowWindow(false);
   
   -- Un-block mouse clicks
   if(mouseBlock) then
      mouseBlock.DetachSelf();   
   end
   
   UnfreezePlayer();
   
   -- 'Walk up to me and hit X'
   tutorialDialog:MoveToTop();
   
   tutorialDialog:SetMessage("Tutorial_Tutorial_Training3");
   tutorialDialog:HideNextButton();

   -- Re-Enable NPC interaction
   SetCanShowInteraction(true);
   RemapKey("NPCInteract");
   
  	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingForInteraction");
   
	GetEvent("OnTrainingOpened");
   
	----------- configure the training GUI for the tutorial -------------
   local npcTrainingGUI = OpenClass(FindNamedWindow("NPCTrainingGUI"));   
   if(not npcTrainingGUI) then
      Log("WARNING - Training Tutorial unable to get a handle on npcTrainingGUI!");
   end
   --disable the train button
   local trainButton = npcTrainingGUI.FindNamedWindow("Train");
   if(trainButton) then
      trainButton.SetEnable(false);
   end   
   -- remoive the close button
   local trainingSelection = npcTrainingGUI.FindNamedWindow("TrainingSelection");
   local closeTrainButton = trainingSelection.FindNamedWindow("Exit");
   if(closeTrainButton) then
      closeTrainButton.ShowWindow(false);
      closeTrainButton.DetachSelf();
   end   
   -- disable all non-free options
   for i = 2, 8 do
      local optionWindow = npcTrainingGUI.FindNamedWindow("Option_"..i);
      optionWindow.SetGreyed(true);
   end   
   npcTrainingGUI.m_neverGoBackToTraining = true;   
   --------------------------------------------------------------------------

   UnregisterEvent("OnTrainingOpened");
   
   FreezePlayer();
   
   local dialogWindowThing = OpenClass(FindNamedWindow("wndDialogMain"));
   dialogWindowThing.ShowWindow(false);
   
   -- temporarily disable  npc interaction
   SetCanShowInteraction(false);
   UnmapKey("NPCInteract");
   
   tutorialDialog:SetTitle("Tutorial_Title14");
   tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");   
   tutorialDialog:MoveToTop();
      
   -- Set Message 'You don't have any Training Points yet, but you may train spells in your School of Focus for free.'
   tutorialDialog:SetMessage("Tutorial_Tutorial_Training4");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
   
   -- Enable the train button now
   if(trainButton) then
      trainButton.SetEnable(true);
   end
   
   --------------------------------------------------------------------------
   -- Set Message 'Choose the free spell and click 'Train'.'
   tutorialDialog:SetMessage("Tutorial_Tutorial_Training5");
   tutorialDialog:HideNextButton();
   
   -- Point arrows at the first spell in the list. This will be the free spell.
   local optionWindow = npcTrainingGUI.FindNamedWindow("Option_1");
   local spellListArrow = TutorialArrow(optionWindow, "Right", 64, 0.5, 0.5, false);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
   

   -- Player must click on a spell to select it
   --WaitForSpellSelection();   
   
   --------------------------------------------------------------------------
   --tutorialDialog:HideNextButton();   
   
   -- Show an arrow pointing at the Train button   
   local trainArrow = TutorialArrow(trainButton, "Top", 64, 0.5, 0.5, false);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToCompleteTraining");

	-- Player must click 'Train'
   --WaitForTrainButton();
   GetEvent("OnTrainingComplete");
   --npcTrainingGUI.ShowWindow(false);
   
   -- We need to advance the tutorial stage here immediately, in case they log out after training.
   clientTutorial.RequestAdvanceStage(13);
   dialogWindowThing.ShowWindow(false);
   
   -- Detach arrows
   spellListArrow:DetachSelf();
   trainArrow:DetachSelf();
   
   -- Block mouse clicks to entire scene (except for dialogs)   
   mouseBlock.SetName("MouseBlock");
   mouseBlock.SetFlags(0x000c0001); -- (PARENT_SIZE | VISIBLE)
   worldWin.AttachWindow(mouseBlock);    
   
   --------------------------------------------------------------------------
   -- Set Message 'Good. Be sure to check with your professors every time you gain a level so you can learn new Spells!'
   tutorialDialog:SetMessage("Tutorial_Tutorial_Training7");
   tutorialDialog:MoveToBottom();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();      
   
   -- Un-block mouse clicks
   if(mouseBlock) then
      mouseBlock.DetachSelf();   
   end
   -- re-enable   npc interaction
   SetCanShowInteraction(true);
   RemapKey("NPCInteract");
   
   UnregisterEvent("OnTrainingComplete");
end

function main()
   TutorialTraining();
end

