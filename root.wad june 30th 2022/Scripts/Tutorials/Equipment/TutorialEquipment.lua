-- TutorialEquipment.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("Tutorials/API/TutorialArrow.lua")
Include("API/ControlClasses.lua");
Include("API/Classes/Timer.lua");
Include("API/Utilities.lua");


function main()
   Log("Starting Equipment Tutorial");
   -- Hide all UI elements and unmap all key commands   
   
   -- Play music manually.  We don't want to alter the zone music
   -- since the zone is shared with the intro tutorial.
   PlayMusic("|Sound|WorldData|Sound/WizardCity2M.mp3");
   
   RegisterEvent("OnItemSelected");
   RegisterEvent("OnEquipItem");
   RegisterEvent("OnSpellbookOpened");
      
   -- Set up the GUI and keyboard commands to prepare for the tutorial
   gGuiElements = 
   {
      "btnFriends",
      "btnFeedback",
      "btnSpellbook",
      "btnPotions",
      "spriteHealthBkg",
      "spriteManaBkg",
      "btnRadialQuickChat",
      "XPBar",
      "compassAndTeleporterButtons",
      "btnEarnCrowns",
      "TradeRequestWindow",
      "btnHelpChat",
      "PermShopButton"      
   };      
   ShowGUIElements(gGuiElements, false);
   UnmapKeys();      
      
   -- Retrieve a reference to our client tutorial object.
	gClientTutorial = OpenClass(GetTutorial());      
   gClientTutorial.SetTutuorialGUIState();    
   
   -- If the player is in queue to play a pvp match and they elected to remain in queue, quit the tutorial
   -- They can resume it later if they return to the tutorial zone.
   if(CheckPvpStatus() == false) then
      if(gTutorialDialog) then
         gTutorialDialog:ShowWindow(false);
      end
      doTeleport();
      -- Terminate the script without completing the tutorial
      Kill(GetProcessID());
   end
   
   -- Give the player an item to equip during this tutorial - try to remove it first in case they already have it   	
   gClientTutorial.RequestRemoveQuest("WC-TUT-C01-001");
	gClientTutorial.RequestAddQuest("WC-TUT-C01-001");	
   gClientTutorial.RequestGoalCompletion("WC-TUT-C01-001","Remove Item");	
   gClientTutorial.RequestRemoveQuest("WC-TUT-C01-001");

   -- Pause to give time for the command to reach the client
   Sleep(500);
   
   -- if their backpack is full, this tutorial cannot continue
   --The BackpackFull function is a C function, so it can't return true or false to Lua.
   -- Instead, it will return a 1 or a 0, respectively.
   if(BackpackFull() == 1) then
      ResetTutorialDialog();
      gTutorialDialog:SetTitle("Tutorial_Title10");
   	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
      gTutorialDialog:DoDialog("Tutorial_Backpack_Full", nil);
      gTutorialDialog:ShowWindow(false);
      doTeleport();
      -- Terminate the script without completing the tutorial
      Kill(GetProcessID());
   end  
   
   gClientTutorial.RequestRemoveQuest("WC-TUT-C01-001");
   gClientTutorial.RequestAddQuest("WC-TUT-C01-001");
   RegisterEvent("OnItemAddedToInventory");
   gClientTutorial.RequestGoalCompletion("WC-TUT-C01-001","Give Item");				               
   GetEvent("OnItemAddedToInventory");
   UnregisterEvent("OnItemAddedToInventory");      
   gClientTutorial.RequestRemoveQuest("WC-TUT-C01-001");
   
      -- Reconfigure the tutorial dialog
   ResetTutorialDialog();
	gTutorialDialog:SetTitle("Tutorial_Title10");
	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");   
   gTutorialDialog:MoveToBottom();
   
   gTutorialDialog:DoDialog("Tutorial_Equipment_01", nil, "Dialogue_ADVTUT/MrLincoln_ADVTUT_01.mp3"); -- "Good day, young Wizard!..."
   
  	-- Open the spellbook to the inventory page
	GetSpellbookWindow("DisplayInventory"); -- stores scipt object into gSpellbookWindow
   GetEvent("OnSpellbookOpened");
	--gCloseButton = gSpellbookWindow.FindNamedWindow("Close_Button");
	--gCloseButton.ShowWindow(false);

   local disabledTabs = 
   {
   "Tab_All",
   "Tab_Hat",
   "Tab_Robe",
   "Tab_Shoes",
   --"Tab_Weapon",
   "Tab_Athame",
   "Tab_Amulet",
   "Tab_Ring",
   "Tab_Pet",
   "Tab_Deck",
   "Quest",
   --"Inventory",
   "Deck",
   "CharStats",
   "Help",
   "Maps",
   "Multiverse",
   "Preferences",
   "Close_Button"
   };
   DisableSpellbookTabs(disabledTabs);
   
   -- Put a mouse block over the inventory tab. It needs to appear enabled, but not accept mouse clicks.
   -- Otherwise, the tutorial can be broken.
   local tab = OpenClass(FindNamedWindow("Inventory"));   
   local tabMouseBlock = CreateClass("Window");
   tabMouseBlock.SetName("TabMouseBlock");
   tabMouseBlock.SetFlags(0x000c0281); -- (PARENT_SIZE | DOCK_LEFT|DOCK_TOP|VISIBLE)      
   tab.AttachWindow(tabMouseBlock);   
   DestroyClass(tab);   
   
	gInventoryPage = OpenClass(GetCurrentSpellBookPage());
   gInventoryPage.ChangeTab("Weapon"); 

	-- temporarily disable the Item One button so the wand can't be selected yet
	gItemOneButton = gItemOneButton or gSpellbookWindow.FindNamedWindow("Item_1");
	gItemOneButton.SetEnable(false);
	
   Sleep(1000);   
   
   gTutorialDialog:DoDialog("Tutorial_Equipment_02", -1, "Dialogue_ADVTUT/MrLincoln_ADVTUT_02.mp3"); -- "Click on the wand..."
	
	-- Now, re-enable the Item One button
	gItemOneButton.SetEnable(true);
   
	--Before we create the animated arrow, we need to make sure that the window components are all in place.
   gRootWindow = OpenClass( GetRootWindow() );
   gRootWindow.UpdatePlacement(true);
   
	-- point arrow at Item_1 
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local itemOneArrow = TutorialArrow(gItemOneButton, "Bottom", 64, 0.5, 0.5, false);
	itemOneArrow:ShowWindow(true);

	GetEvent("OnItemSelected");
   
   gItemOneButton.SetEnable(false);
   itemOneArrow:ShowWindow(false);
   
   -- Reconfigure the tutorial dialog
   ResetTutorialDialog();
	gTutorialDialog:SetTitle("Tutorial_Title10");
	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");  
   gTutorialDialog:MoveToTop();   
	
   gTutorialDialog:DoDialog("Tutorial_Equipment_03", -1, "Dialogue_ADVTUT/MrLincoln_ADVTUT_03.mp3"); -- "Now click the blue button..."
   
	--local myArrow = CreateArrowOnButton(gSpellbookWindow,"Equip_Item");
	local equipItemButton = gSpellbookWindow.FindNamedWindow("Equip_Item");
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local myArrow = TutorialArrow(equipItemButton, "Top", 64, 0.5, 0.5, false);
   equipItemButton.SetGreyed(false); -- enable the equip item button
	myArrow:ShowWindow(true); 
   
	GetEvent("OnEquipItem");
   
	myArrow:ShowWindow(false);
	
	gTutorialDialog:DoDialog("Tutorial_Equipment_04", nil, "Dialogue_ADVTUT/MrLincoln_ADVTUT_04.mp3"); -- "You're learning fast!..."

	gTutorialDialog:DoDialog("Tutorial_Equipment_05", nil, "Dialogue_ADVTUT/MrLincoln_ADVTUT_05.mp3"); -- "However, only a limited number..."
   
   gTutorialDialog:ShowWindow(false);

   UnregisterEvent("OnItemSelected");
   UnregisterEvent("OnEquipItem");  
   UnregisterEvent("OnSpellbookOpened");
   
   -- close the spellbook for them.	
   SendClientEvent("CloseSpellbook");   

   -- Teleport Player out of tutorial zone and restore the GUI to its normal state
   doTeleport();
   
   Sleep(1000);      
   
   -- Complete the tutorial
   Log("Equipment Tutorial Complete");
   gClientTutorial.RequestGoalCompletion("Tutorial_Equipment","Complete");
end

-- Teleport Player out of tutorial zone and restore the GUI to its normal state
function doTeleport()   
   RegisterEvent("OnTeleported");
   gClientTutorial.RequestRemoveQuest("WC-TUT-C01-001");
	gClientTutorial.RequestAddQuest("WC-TUT-C01-001");	
   gClientTutorial.RequestGoalCompletion("WC-TUT-C01-001","Teleport");				            
   gClientTutorial.RequestRemoveQuest("WC-TUT-C01-001");
   GetEvent("OnTeleported");
   UnregisterEvent("OnTeleported");
   
   -- Show the UI elements and remap all key commands
   gClientTutorial.UnsetTutuorialGUIState(); 
   RestoreGUIElements(gGuiElements);
   RemapKeys();
end
