--TutorialEquipment.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");


function TutorialEquipment()
	--If this phase of the tutorial is the first phase to be displayed, which would happen if the
	--player exited out of a previous tutorial session during this phase, then the spell book is
	--not already loaded by a previous phase.  This results in the screen window coordinates of the
	--inventory items not being in the correct spot when the bouncy arrow is created.  That means
	--the arrow is pointing to an incorrect position.  So, what we need to do is see if the
	--inventory windows are already present.  If they are not, then this is the first phase of this
	--tutorial session, so we need to make sure all of the screen positions of all windows are
	--correct.
   
   RegisterEvent("OnItemSelected");
   RegisterEvent("OnEquipItem");
   
	local rootWnd = OpenClass( GetRootWindow() );
	local itemOneButton = rootWnd.FindNamedWindow("Item_1");
	local startingPhase = false;
	if(itemOneButton == nil) then
		--This is indeed the starting phase of this tutorial session
		startingPhase = true;
	end

	-- Retrieve a reference to our client tutorial object.
	local clientTutorial = OpenClass(GetTutorial());
   clientTutorial.RequestUnequipWand();
   
  	-- The tabbed spellbook should be visible already, but lets make sure it is.
	-- (This also allows us to test just this section of the tutorial without all the other stuff)	
	local spellbookWindow = GetSpellbookWindow("DisplayInventory");
	local closeButton = spellbookWindow.FindNamedWindow("Close_Button");
	closeButton.ShowWindow(false);

   DisableSpellbookTabs(spellbookWindow);
   
	local inventoryPage = OpenClass(GetCurrentSpellBookPage());
   inventoryPage.ChangeTab("Weapon"); 

	-- temporarily disable the Item One button so the wand can't be selected yet
	itemOneButton = spellbookWindow.FindNamedWindow("Item_1");
	itemOneButton.SetEnable(false);
	
   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
	tutorialDialog:SetTitle("Tutorial_Title10");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");   
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment4"); -- "Click on the wand entry."
	tutorialDialog:HideNextButton();  
   tutorialDialog:MoveToBottom();
	
	-- Now, re-enable the Item One button
	itemOneButton.SetEnable(true);
   
	--Before we create the animated arrow, we need to make sure that the window components are all
	--in place.  They will be if this was not the starting phase, but if it is the starting phase,
	--we'll need to update their placement.
	if(startingPhase) then
		rootWnd.UpdatePlacement(true);
	end
   
	-- point arrow at Item_1 
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local itemOneArrow = TutorialArrow(itemOneButton, "Bottom", 64, 0.5, 0.5, false);
	itemOneArrow:ShowWindow(true);

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToSelectItem1");

	GetEvent("OnItemSelected");
   
   itemOneButton.SetEnable(false);
   itemOneArrow:ShowWindow(false);
   
   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
	tutorialDialog:SetTitle("Tutorial_Title10");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");   
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment5"); -- Now click this button to use it.
	tutorialDialog:HideNextButton();  
   tutorialDialog:MoveToTop();
   
	--local myArrow = CreateArrowOnButton(spellbookWindow,"Equip_Item");
	local equipItemButton = spellbookWindow.FindNamedWindow("Equip_Item");
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local myArrow = TutorialArrow(equipItemButton, "Top", 64, 0.5, 0.5, false);
   equipItemButton.SetGreyed(false); -- enable the equip item button
	myArrow:ShowWindow(true); 
   
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToEquipItem");

	GetEvent("OnEquipItem");
   
	myArrow:ShowWindow(false);
	
   -- Good! You can use this wand to conjure Firebolts if you ever run out of Spell Cards.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment6");
	tutorialDialog:ShowNextButton();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();

   --But these spells are limited during combat, so take care not to run out!
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment7");
	tutorialDialog:ShowNextButton();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();

   UnregisterEvent("OnItemSelected");
   UnregisterEvent("OnEquipItem");
   
	--tutorialDialog:DetachSelf();
end

function main()
	TutorialEquipment();
end


