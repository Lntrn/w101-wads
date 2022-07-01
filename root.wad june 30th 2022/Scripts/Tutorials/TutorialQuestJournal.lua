-- TutorialQuest.lua
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");

function TutorialQuestJournal()		
	--If this phase of the tutorial is the first phase to be displayed, which would happen if the
	--player exited out of a previous tutorial session during this phase, then the spell book is
	--not already loaded by a previous phase.  This results in the screen window coordinates of the
	--quest button not being in the correct spot when the bouncy arrow is created.  That means the
	--arrow is pointing to an incorrect position.  So, what we need to do is see if the quest
	--button is already present.  If it is not, then this is the first phase of this tutorial
	--session, so we need to make sure all of the screen positions of all windows are correct.
   
   RegisterEvent("OnQuestListOpened");
   RegisterEvent("OnSpellbookClosed");
   
	local rootWnd = OpenClass( GetRootWindow() );
	local questButton = rootWnd.FindNamedWindow("Quest");
	local startingPhase = false;
	if(questButton == nil) then
		--This is indeed the starting phase of this tutorial session
		startingPhase = true;
	end

	-- Ensure the spellbook is up on the equipment screen.
	local spellbookWindow = GetSpellbookWindow("DisplayInventory");
	spellbookWindow.EnableTabButton("Quest", true);
   
   -- disable the Item One button so the wand can't be selected or unequipped
	itemOneButton = spellbookWindow.FindNamedWindow("Item_1");
	itemOneButton.SetEnable(false);

   DisableSpellbookTabs(spellbookWindow);
	local closeButton = spellbookWindow.FindNamedWindow("Close_Button");
	closeButton.ShowWindow(false);

	--Before we create the animated arrow, we need to make sure that the window components are all
	--in place.  They will be if this was not the starting phase, but if it is the starting phase,
	--we'll need to update their placement.
	if(startingPhase) then
		rootWnd.UpdatePlacement(true);
	end

	-- show arrow pointing at the quest journal tab.
	questButton = spellbookWindow.FindNamedWindow("Quest");
	--local questTabArrow = CreateArrowOnButton(spellbookWindow,"Quest");
	local questTabArrow = TutorialArrow(questButton,"Top",64, 0.5, 0.5,false);
	questTabArrow:ShowWindow(true);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
   
   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);	
	tutorialDialog:SetTitle("Tutorial_Title11");	
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
   tutorialDialog:SetMessage("Tutorial_Tutorial_Journal1"); -- 'lets look at the quest journal'
   tutorialDialog:HideNextButton();
   tutorialDialog:MoveToBottom();
	
   -- remove any pre-existing copies of this quest in case the player had to resume the tutuorial
   clientTutorial.RequestRemoveQuest("WC-TUT-C04-001");
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToOpenQuestList");

	-- wait for player to click the right tab
	GetEvent("OnQuestListOpened");
	-- at this point, the tutorial dialog is behind the quest list. try to put it in front	
	questTabArrow:ShowWindow(false);
	--tutorialDialog:DetachSelf();
	
   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
	tutorialDialog:SetTitle("Tutorial_Title11");		
	tutorialDialog:SetMessage("Tutorial_Tutorial_Journal2"); -- 'this shows all your current quests'
	tutorialDialog:ShowNextButton();
	--tutorialDialog:SetFocus();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	
	local clientTutorial = OpenClass(GetTutorial());
	-- Quest removed above before showing Quest List
   -- Request that the quest be added to the player.
	clientTutorial.RequestAddQuest("WC-TUT-C04-001");
	
	-- 'right now you dont have any, lemme give you one'
	tutorialDialog:SetMessage("Tutorial_Tutorial_Journal3");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	-- Retrieve a reference to our client tutorial object.	
	tutorialDialog:WaitForNextButton();	

   FreezePlayer();
	
	tutorialDialog:MoveToTop();

	-- 'there, now close your spellbook'
	tutorialDialog:SetMessage("Tutorial_Tutorial_Journal4");
	tutorialDialog:HideNextButton();
	
	--closeArrow = CreateArrowOnButton(spellbookWindow,"Close_Button");	
	closeButton.ShowWindow(true);
	local closeArrow = TutorialArrow(closeButton,"Top",64,0.5,0.5,false);
	closeArrow:ShowWindow(true);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToCloseSppelbook");


	GetEvent("OnSpellbookClosed");
	closeArrow:ShowWindow(false);	
   
   UnregisterEvent("OnQuestListOpened");
   UnregisterEvent("OnSpellbookClosed");
end

function main()
	TutorialQuestJournal();
end