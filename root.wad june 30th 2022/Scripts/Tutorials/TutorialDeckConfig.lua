-- TutorialQuest.lua
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");

function TutorialDeckConfig()
   local clientTutorial = OpenClass(GetTutorial());   
   -- Block mouse clicks to entire scene (except for dialogs)
   local worldWin = OpenClass(GetWorldWindow());
   local mouseBlock = CreateClass("Window");
   mouseBlock.SetName("MouseBlock");
   mouseBlock.SetFlags(0x000c0001); -- (PARENT_SIZE | VISIBLE)
   worldWin.AttachWindow(mouseBlock);  
   
   RegisterEvent("OnSpellbookOpened");
   RegisterEvent("OnCardAddedToDeck");
   RegisterEvent("OnCardRemovedFromDeck");
   RegisterEvent("OnCardAddedToDeckMaxCount");

   -- temporarily disable  npc interaction
   SetCanShowInteraction(false);
   UnmapKey("NPCInteract");

	-- unequip any cards that may be in  your deck
	clientTutorial.RequestRemoveQuest("WC-TUT-C06-002");
	clientTutorial.RequestAddQuest("WC-TUT-C06-002");	

	-- Show arrow pointing at the spellbook button.
	local hudWindow = OpenClass(FindNamedWindow("windowHUD"));
	if(hudWindow == nil) then
		Log("Could not find windowHUD!");
	end
   
   -- re-attach spellbook so it is on top of mouse block 
	local spellbookButton = hudWindow.FindNamedWindow("btnSpellbook");
   -- make and attach acopy of the spellbook button so that it goes on top of the mouseblock window
   local spellbookButtonCopy = CreateClass("class ControlButton");
   spellbookButtonCopy.SetWindow(spellbookButton.GetWindow());
   spellbookButtonCopy.SetWindowStyle(spellbookButton.GetWindowStyle());
   spellbookButtonCopy.SetName("btnSpellbook");
   spellbookButtonCopy.SetColor(0x00000000);
   
   worldWin.AttachWindow(spellbookButtonCopy);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local spellbookArrow = TutorialArrow(spellbookButton, "Top", 64, 0.5, 0.5, false);
	spellbookArrow:ShowWindow(true);
	
   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);	
   tutorialDialog:SetTitle("Tutorial_Title15");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");   	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck1");	--'now that you've learned your first spell, lets learn how to put it into your deck'
	tutorialDialog:HideNextButton();
	tutorialDialog:MoveToTop();
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingForOpenSpellBook");

	GetEvent("OnSpellbookOpened");
	spellbookButtonCopy.SetVisible(false);
	spellbookButtonCopy.DetachSelf();
   DestroyClass(spellbookButtonCopy);
	spellbookButton.SetVisible(false);
	
	spellbookArrow:ShowWindow(false);

	-- Ensure the spellbook is up on the quest screen.
	local spellbookWindow = GetSpellbookWindow("OpenQuestList");
   
	local closeButton = spellbookWindow.FindNamedWindow("Close_Button");
	closeButton.SetVisible(false);
	
   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);
   tutorialDialog:SetTitle("Tutorial_Title15");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");      
   tutorialDialog:SetMessage("Tutorial_Tutorial_Deck2"); -- 'and go to the Deck page'
   tutorialDialog:HideNextButton();
   
	-- show arrow pointing at the deck config tab
	local deckTab = spellbookWindow.FindNamedWindow("Deck");
   Sleep(250); -- sometimes the arrow goes in the wrong place.  This will prevent that.
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local deckTabArrow = TutorialArrow(deckTab, "Bottom", 64, 0.5, 0.5, false);
	deckTabArrow:ShowWindow(true);  
   RegisterEvent("OnDeckConfigOpened");
   spellbookWindow.EnableTabButton("Deck", true);
	
   --Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
   --where we are in the tutorial
   SendEvent("Tutorial_WaitingToOpenDeckConfig");

   -- player must click on Deck tab
   GetEvent("OnDeckConfigOpened");
   DisableSpellbookTabs(spellbookWindow);   

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
   
   -- remove the blinking arrow
   deckTabArrow:ShowWindow(false);
   
   -- temporarily disable the spell list window
   local spellListWindow = OpenClass(FindNamedWindow("SpellList"));
   spellListWindow.SetEnable(false);

   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
   tutorialDialog:SetTitle("Tutorial_Title15");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");   	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck3"); -- 'On the right you'll see the spells you know'
	tutorialDialog:ShowNextButton();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	
	local cardRect = spellListWindow.GetCardPosition(0);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local arrow = TutorialArrow(spellListWindow, "Bottom", 64, 0.5, 0.5, false, cardRect);
	arrow:ShowWindow(true);
	
	-- To add one copy, left click the card
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck4");
	tutorialDialog:HideNextButton();
   
	-- re-enable spell list window
	spellListWindow.SetEnable(true);
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToAddCardToDeck");
	
	GetEvent("OnCardAddedToDeck");
	
   -- temporarily disable the current deck window   
   local deckWindow = OpenClass(FindNamedWindow("CardsInDeck"));
   deckWindow.SetEnable(false);
   
   -- Click it again and you'll add another copy...
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck5");
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToAddCardToDeck");

	GetEvent("OnCardAddedToDeck");
   arrow:ShowWindow(false);    

   -- temporarily disable the spell list window
   local spellListWindow = OpenClass(FindNamedWindow("SpellList"));
   spellListWindow.SetEnable(false);
   
	--'good, you've added two copies of the spell to your deck.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck6");
	tutorialDialog:ShowNextButton();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck7");
	tutorialDialog:HideNextButton();
	
   -- re-enable deck window
   deckWindow.SetEnable(true);

   local arrow2Rect = MakeRectString(25, 225, 95, 128 + 64 + 225);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
   local arrow2 = TutorialArrow(deckWindow, "Bottom", 64, 0.5, 0.5, false, arrow2Rect);
   arrow2.m_ArrowDock.m_Flags = "VISIBLE|DOCK_TOP|DOCK_OUTSIDE";
   arrow2:ShowWindow(true);

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToRemoveCardFromDeck");

	GetEvent("OnCardRemovedFromDeck");
   arrow2:ShowWindow(false);
	
	--'perfect, remember you have a limited #, etc'
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck8");
	tutorialDialog:ShowNextButton();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	tutorialDialog:HideNextButton();
   
   -- re-enable spell list window
   spellListWindow.SetEnable(true);
   
   arrow:ShowWindow(true);
	
	-- 'Now add as many copies of the spell as your book allows'
	tutorialDialog:SetMessage("Tutorial_Tutorial_Deck9");
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToMaxOutDeck");
	
	GetEvent("OnCardAddedToDeckMaxCount");
   
   arrow:ShowWindow(false);
	
	-- close the spellbook for them.
	closeButton.SetVisible(true);
   	SendClientEvent("CloseSpellbook");
   
   -- Un-block mouse clicks
   if(mouseBlock) then
      mouseBlock.DetachSelf();   
   end

   -- re-enable  npc interaction
   SetCanShowInteraction(true);
   RemapKey("NPCInteract");
   
   UnregisterEvent("OnDeckConfigOpened");
   UnregisterEvent("OnSpellbookOpened");
   UnregisterEvent("OnCardAddedToDeck");
   UnregisterEvent("OnCardRemovedFromDeck");
   UnregisterEvent("OnCardAddedToDeckMaxCount");
      
	--tutorialDialog:DetachSelf();
	--end
end

function main()
	TutorialDeckConfig();
end