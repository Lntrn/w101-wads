-- TutorialDeck.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("Tutorials/API/TutorialArrow.lua")
Include("API/ControlClasses.lua");
Include("API/Classes/Timer.lua");
Include("API/Utilities.lua");

function main()
   Log("Starting Deck Config Tutorial");
         
   gClientTutorial = OpenClass(GetTutorial());   
   gClientTutorial.SetTutuorialGUIState();       
   
   RegisterEvent("OnSpellbookOpened");
   RegisterEvent("OnCardAddedToDeck");
   RegisterEvent("OnCardRemovedFromDeck");
   RegisterEvent("OnCardAddedToDeckMaxCount");     
   RegisterEvent("OnDeckConfigOpened");
   
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
   
   -- temporarily disable  npc interaction
   SetCanShowInteraction(false);
   UnmapKey("NPCInteract");
   
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
   
	-- Give the player a new temporary deck to use during the course of this tutorial - try to remove it first in case they already have it   
	gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
	gClientTutorial.RequestAddQuest("WC-TUT-C02-001");	
   gClientTutorial.RequestGoalCompletion("WC-TUT-C02-001","Remove Deck");  
   gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
   
   -- Pause to give time for the command to reach the client
   Sleep(500);
   
   -- if their backpack is full, this tutorial cannot continue
   --The BackpackFull function is a C function, so it can't return true or false to Lua.
   -- Instead, it will return a 1 or a 0, respectively.
   if(BackpackFull() == 1) then   
      ResetTutorialDialog();
      gTutorialDialog:SetTitle("Tutorial_Title10");
   	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
      gTutorialDialog:DoDialog("Tutorial_Backpack_Full", nil, "Dialogue_ADVTUT/Gamma_ADVTUT_01.mp3");
      gTutorialDialog:ShowWindow(false);
      doTeleport();
      -- Terminate the script without completing the tutorial
      Kill(GetProcessID());
   end   

   gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
   gClientTutorial.RequestAddQuest("WC-TUT-C02-001");	
   RegisterEvent("OnItemAddedToInventory");
   gClientTutorial.RequestGoalCompletion("WC-TUT-C02-001","Give Deck");
   GetEvent("OnItemAddedToInventory");   
   UnregisterEvent("OnItemAddedToInventory");  
   gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");

   -- Reconfigure the tutorial dialog
   ResetTutorialDialog();
   gTutorialDialog:SetTitle("Tutorial_Title15");
	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");   	    
   gTutorialDialog:DoDialog("Tutorial_Deck_01", nil, "Dialogue_ADVTUT/Gamma_ADVTUT_02.mp3"); -- 'Greetings, young Wizard..."  
   
   -- Open the spellbook to the deck  page
	GetSpellbookWindow("DisplayDeckConfig"); -- stores scipt object into gSpellbookWindow
   GetEvent("OnSpellbookOpened");

local disabledTabs = 
   {
   "Cards_Fire",
   "Cards_Ice",
   "Cards_Storm",
   "Cards_Myth",
   "Cards_Life",
   "Cards_Death",
   "Cards_Balance",
   "Cards_Treasure",   
   "PrevDeck",
   "NextDeck",
   "Quest",
   "Inventory",
   --"Deck",
   "CharStats",
   "Help",
   "Maps",
   "Multiverse",
   "Preferences",
   "Close_Button"
   };

   GetEvent("OnDeckConfigOpened");
   
   -- hide/show spellbook tabs appropriately to the tutorial
   DisableSpellbookTabs(disabledTabs);

   -- enable the Deck tab for aesthetics
   gSpellbookWindow.EnableTabButton("Deck", true);
   
   local deckPage = nil
   while(true) do -- loop here until we get the spellbook page
      deckPage = OpenClass(GetCurrentSpellBookPage());  
      if(deckPage) then
         break;
      end
      Sleep(100);
   end;   
	
   deckPage.ChangeSpellPage("All");      
   DestroyClass(deckPage);
   
   -- Put a mouse block over the deck tab. It needs to appear enabled, but not accept mouse clicks.
   -- Otherwise, the tutorial can be broken.
   local tab = OpenClass(FindNamedWindow("Deck"));   
   local tabMouseBlock = CreateClass("Window");
   tabMouseBlock.SetName("TabMouseBlock");
   tabMouseBlock.SetFlags(0x000c0281); -- (PARENT_SIZE | DOCK_LEFT|DOCK_TOP|VISIBLE)      
   tab.AttachWindow(tabMouseBlock);   
   DestroyClass(tab);   
   
   -- remove the blinking arrow
   --deckTabArrow:ShowWindow(false);
   
   -- Set up UI to configure the deck we gave them
   GotoDeck(126983);   
   
   -- temporarily disable the spell list window
   local spellListWindow = OpenClass(FindNamedWindow("SpellList"));
   spellListWindow.SetEnable(false);

   -- Within the spell list window, block mouse clicks on all available spells except the first
   for i = 1,5 do
      spellListWindow.SetSpellEnabled(i, false);
   end
   
	gTutorialDialog:DoDialog("Tutorial_Deck_02", nil, "Dialogue_ADVTUT/Gamma_ADVTUT_03.mp3"); -- "The spells you know..."

	local cardRect = spellListWindow.GetCardPosition(0);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local arrow = TutorialArrow(spellListWindow, "Bottom", 64, 0.5, 0.5, false, cardRect);
	arrow:ShowWindow(true);
	
	gTutorialDialog:DoDialog("Tutorial_Deck_03", -1, "Dialogue_ADVTUT/Gamma_ADVTUT_04.mp3"); --"to put a card in..."
   
	-- re-enable spell list window
	spellListWindow.SetEnable(true);
	
	GetEvent("OnCardAddedToDeck");
	
   -- temporarily disable the current deck window   
   local deckWindow = OpenClass(FindNamedWindow("CardsInDeck"));
   deckWindow.SetEnable(false);
   
	gTutorialDialog:DoDialog("Tutorial_Deck_04", -1, "Dialogue_ADVTUT/Gamma_ADVTUT_05.mp3"); -- "Click it once more..."

	GetEvent("OnCardAddedToDeck");
   arrow:ShowWindow(false);    

   -- temporarily disable the spell list window
   local spellListWindow = OpenClass(FindNamedWindow("SpellList"));
   spellListWindow.SetEnable(false);
   
	gTutorialDialog:DoDialog("Tutorial_Deck_05", nil, "Dialogue_ADVTUT/Gamma_ADVTUT_06.mp3"); -- "Wonderful! You've added two copies..."
	
	gTutorialDialog:DoDialog("Tutorial_Deck_06", -1, "Dialogue_ADVTUT/Gamma_ADVTUT_07.mp3"); -- "To remove a copy..."
	
   -- re-enable deck window
   deckWindow.SetEnable(true);

   local arrow2Rect = MakeRectString(25, 225, 95, 128 + 64 + 225);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
   local arrow2 = TutorialArrow(deckWindow, "Bottom", 64, 0.5, 0.5, false, arrow2Rect);
   arrow2.m_ArrowDock.m_Flags = "VISIBLE|DOCK_TOP|DOCK_OUTSIDE";
   arrow2:ShowWindow(true);

	GetEvent("OnCardRemovedFromDeck");
   
   deckWindow.SetEnable(false);
   
   arrow2:ShowWindow(false);	
	
   -- re-enable spell list window
   spellListWindow.SetEnable(true);
   
   arrow:ShowWindow(true);
   
	gTutorialDialog:DoDialog("Tutorial_Deck_07", -1, "Dialogue_ADVTUT/Gamma_ADVTUT_08.mp3"); -- "Now you can add..."
	
   GetEvent("OnCardAddedToDeckMaxCount");
   
   gTutorialDialog:ShowWindow(false);
   arrow:ShowWindow(false);
   
   gTutorialDialog:DoDialog("Tutorial_Deck_08", nil, "Dialogue_ADVTUT/Gamma_ADVTUT_09.mp3"); -- "Well done!..."   
	   
   UnregisterEvent("OnDeckConfigOpened");
   UnregisterEvent("OnSpellbookOpened");
   UnregisterEvent("OnCardAddedToDeck");
   UnregisterEvent("OnCardRemovedFromDeck");
   UnregisterEvent("OnCardAddedToDeckMaxCount");
      
   -- Remove the temporary deck from their inventory
   RegisterEvent("OnItemRemovedFromInventory");
	gClientTutorial.RequestAddQuest("WC-TUT-C02-001");	
   gClientTutorial.RequestGoalCompletion("WC-TUT-C02-001","Remove Deck");
   GetEvent("OnItemRemovedFromInventory");
   gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
   UnregisterEvent("OnItemRemovedFromInventory");
      
	-- close the spellbook for them.
   SendClientEvent("CloseSpellbook");        

   -- Teleport Player out of tutorial zone and restore the GUI to its normal state
   doTeleport();     
      
   Sleep(1000);      
      
   -- Complete the tutorial
   Log("Deck Config Tutorial Complete");
   gClientTutorial.RequestGoalCompletion("Tutorial_Deck","Complete");
end

-- Teleport Player out of tutorial zone and restore the GUI to its normal state
function doTeleport()   
   RegisterEvent("OnTeleported");
   gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
	gClientTutorial.RequestAddQuest("WC-TUT-C02-001");	
   gClientTutorial.RequestGoalCompletion("WC-TUT-C02-001","Teleport");				            
   gClientTutorial.RequestRemoveQuest("WC-TUT-C02-001");
   GetEvent("OnTeleported");
   UnregisterEvent("OnTeleported");
   
   -- re-enable  npc interaction
   SetCanShowInteraction(true);
   RemapKey("NPCInteract");   
   
   -- Show the UI elements and remap all key commands
   gClientTutorial.UnsetTutuorialGUIState(); 
   RestoreGUIElements(gGuiElements);
   RemapKeys();
end
