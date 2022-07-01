--TutorialEquipment.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");


--buttons in the spellbook prefs window:
--  Close_Button
--  Quest
--  Inventory
--  Deck
--  CharStats
--  World
--  Maps
--  Multiverse
--  Preferences

function TutorialMaps()
	-- The tabbed spellbook should be visible already, but lets make sure it is.
	-- (This also allows us to test just this section of the tutorial without all the other stuff)	
	local spellbookWindow = GetSpellbookWindow("DisplayMapWindow");
	
   RegisterEvent("OnInventoryOpened");
   	
   while(true) do -- loop here until we get a handle on the zoom button, then disable it
      local zoomButton = OpenClass(spellbookWindow.FindNamedWindow("PlusMinusButton"));
      if(zoomButton) then 
		zoomButton.SetEnable(false);
		break; 
      end
      Sleep(100);      
   end   
	
	-- disable the GoHome button if it's available
   local homeButton = OpenClass(spellbookWindow.FindNamedWindow("GoHomeButton"));
   if(homeButton) then
		homeButton.SetEnable(false);
   end	

	local closeButton = spellbookWindow.FindNamedWindow("Close_Button");
	closeButton.ShowWindow(false);
	local goHomeButton = spellbookWindow.FindNamedWindow("GoHomeButton");
	goHomeButton.ShowWindow(false);   
   local dormButton = spellbookWindow.FindNamedWindow("GotoDormButton");
	dormButton.ShowWindow(false);

   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);	
   tutorialDialog:SetTitle("Tutorial_Title9");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds"); 		   	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Map1"); --'This map shows you...'
	tutorialDialog:MoveToBottom();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();   
	
	-- show arrow pointing at inventory tab
	local inventoryButton = spellbookWindow.FindNamedWindow("Inventory");
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local myArrow = TutorialArrow(inventoryButton,"Bottom",64,0.5,0.5,false);
	myArrow:ShowWindow(true);

	--'This tab...'
	tutorialDialog:SetMessage("Tutorial_Tutorial_Map2");
	tutorialDialog:HideNextButton();
	
	spellbookWindow.EnableTabButton("Inventory", true);
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingForInventoryToBeOpened");

	GetEvent("OnInventoryOpened");
	myArrow:DetachSelf();
   
   
   -- first portion of Equipment tutorial moved to below to prevent accumulation of multiple wands
   
   
   local inventoryPage = OpenClass(GetCurrentSpellBookPage());
   inventoryPage.ChangeTab("Weapon");
   
   -- Request that our special tutorial equipment quest is added to the player.
	clientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
	clientTutorial.RequestAddQuest("WC-TUT-C02-001");

   DisableSpellbookTabs(spellbookWindow);
   
	-- Set the title
	tutorialDialog:SetTitle("Tutorial_Title10");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
	-- Display the dialog and wait for next
   
   -- ...to see your backpack screen.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment1");
	tutorialDialog:ShowWindow(true);

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();

   -- This is where you can wear and remove the items you find in the world.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment2");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	   
	tutorialDialog:SetProfessorImage("GUI/Art/Art_Quest_Tutorial_Wand.dds");

	RegisterEvent("OnItemAddedToInventory");
	-- Mister Licoln gives you a Novice Fire Wand.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Equipment3");
	clientTutorial.RequestGoalCompletion("WC-TUT-C02-001", "GiveWand");   
	clientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
	GetEvent("OnItemAddedToInventory");   
	clientTutorial.RequestAdvanceStage(8);
   
	-- temporarily disable the Item One button so the wand can't be selected yet
	local itemOneButton = spellbookWindow.FindNamedWindow("Item_1");
	itemOneButton.SetEnable(false);

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
   
   UnregisterEvent("OnInventoryOpened");
   
	--tutorialDialog:DetachSelf();
end
