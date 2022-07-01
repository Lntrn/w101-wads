-- This was split off from TutorialUtility.lua to prevent changes required by the intro tutorial from effecting the behavior of the Advanced Combat Tutorial
-- The Advanced Combat Tutorial should include this instead of TutorialUtility.lua

function Sleep(aNumMilliSeconds)
   local gameTimer = Timer();
   local startTime = gameTimer:GetTime();
   while(gameTimer:GetTime() < startTime + aNumMilliSeconds) do end
end    

function WaitForEvent(eventName)
   Log("USE OF THIS FUNCTION LED TO RACE CONDITIONS AND IS NOW DEPRECATED.");
   return nil;
end

function WaitForEvents(event1, event2)
	Log("USE OF THIS FUNCTION LED TO RACE CONDITIONS AND IS NOW DEPRECATED.");
   return nil;
end

function GetSpellbookWindow(whichTab)
	SendClientEvent(whichTab);
	local spellbookWindow = OpenClass(FindNamedWindow("DeckConfiguration"));
	if(spellbookWindow == nil) then		
		spellbookWindow = OpenClass(FindNamedWindow("DeckConfiguration"));
	end	
	if(spellbookWindow == nil) then
		Log("Could not find spellbook window");
	end
	
	return spellbookWindow;
end

function MakeMoveAnimation( a_posX, a_posY, a_timeToPerform )
	local moveTime = CreateClass("WinAnimMoveToLocationTimeEase");
	moveTime.SetTargetLocation(a_posX, a_posY);
	moveTime.SetTime(a_timeToPerform);
	moveTime.SetEaseInPercent(0.15);
	moveTime.SetEaseOutPercent(0.15);
	
	return moveTime;
end

function MakeScaleAnimation( a_scale, a_time )
	local scaleTime = CreateClass("WinAnimScaleTime");
	scaleTime.SetScale(a_scale);
	scaleTime.SetTime(a_time);
	
	return scaleTime;
end

function WaitForAnimationsToFinish( a_targetWindow )
	while( a_targetWindow.GetAnimationCount() > 0 ) do
		Sleep(100);
	end
end

-- Based on the phase of the tutorial, configure which HUD elements are visible.
function ConfigureHUD( phase )
   UnmapKey("ToggleQuestList");
	UnmapKey("ToggleCharStats");
	UnmapKey("ToggleMapWindow");
	UnmapKey("ToggleWorldWindow");
	UnmapKey("ToggleInventory");
	UnmapKey("DisplayBuddyList");
	UnmapKey("DisplayLogin");
	UnmapKey("ToggleDeckConfig");
   UnmapKey("ToggleCraftingPage");
   FreezePlayer();
   ShowTips(false);
	
	-- Friends list is not visible until phase 14
	local friendsListButton = OpenClass(FindNamedWindow("btnFriends"));
	if(friendsListButton) then
		if(phase > 13) then		
			friendsListButton.SetVisible(true);
		else
			friendsListButton.SetVisible(false);
		end
	end
	
	-- Quick Chat button is not visible until phase 10     
	local quickChatButton = OpenClass(FindNamedWindow("btnRadialQuickChat"));
   local helpChatButton = OpenClass(FindNamedWindow("btnHelpChat"));
	if(quickChatButton) then
		if(phase > 10) then
			quickChatButton.SetVisible(true);
		else
			quickChatButton.SetVisible(false);
		end
	end
   if(helpChatButton) then
		if(phase > 10) then
			helpChatButton.SetVisible(true);
		else
			helpChatButton.SetVisible(false);
		end
	end
  
  -- Secure chat is not visible until phase 14
	-- local secureChatButton = OpenClass(FindNamedWindow("btnSecureChat"));
	-- if(secureChatButton) then
	--	if(phase > 13) then
	--		secureChatButton.SetVisible(true);
	--	else
	--		secureChatButton.SetVisible(false);
	--	end
	-- end
	
	-- Feedback button now visible until phase 14
	local reportBugButton = OpenClass(FindNamedWindow("btnFeedback"));
	if(reportBugButton) then
		if(phase > 13) then
			reportBugButton.SetVisible(true);
		else
			reportBugButton.SetVisible(false);
		end
	end
	
	local compassButton = OpenClass(FindNamedWindow("compassAndTeleporterButtons"));
	if(compassButton) then
		if(phase > 11) then
			compassButton.SetVisible(true);
		else
			compassButton.SetVisible(false);
		end
	end
	
	local spellbookButton = OpenClass(FindNamedWindow("btnSpellbook"));
	if(spellbookButton) then
		if(phase > 9) then
			spellbookButton.SetVisible(true);
		else
			spellbookButton.SetVisible(false);
		end
	end
	
	if(phase > 13) then
      ShowTips(true);
		RemapKey("ToggleQuestList");
		RemapKey("ToggleCharStats");
		RemapKey("ToggleMapWindow");
		RemapKey("ToggleWorldWindow");
		RemapKey("ToggleInventory");
		RemapKey("DisplayBuddyList");
		RemapKey("DisplayLogin");
    	RemapKey("ToggleDeckConfig");
      RemapKey("ToggleCraftingPage");
      UnfreezePlayer();
	end
end

function ShowTips(a_bool)
   local worldWin = OpenClass(GetWorldWindow());
   local tipFrame = worldWin.FindNamedWindow("TipWindow");
   if(tipFrame) then
      tipFrame.ShowTips(a_bool);
   else
      Log("Error in TutorialUtility::ShowTips(): Unable to find GUI element for 'TipWindow'");
   end
end

function DisableSpellbookTabs(a_spellbookWindow)
   a_spellbookWindow.EnableTabButton("Tab_All", false);
   a_spellbookWindow.EnableTabButton("Tab_Hat", false);
   a_spellbookWindow.EnableTabButton("Tab_Robe", false);
   a_spellbookWindow.EnableTabButton("Tab_Shoes", false);
   a_spellbookWindow.EnableTabButton("Tab_Athame", false);
   a_spellbookWindow.EnableTabButton("Tab_Amulet", false);
   a_spellbookWindow.EnableTabButton("Tab_Ring", false);
   a_spellbookWindow.EnableTabButton("Tab_Pet", false);
   a_spellbookWindow.EnableTabButton("Tab_Deck", false);
   a_spellbookWindow.EnableTabButton("Cards_Fire", false);
   a_spellbookWindow.EnableTabButton("Cards_Ice", false);
   a_spellbookWindow.EnableTabButton("Cards_Storm", false);
   a_spellbookWindow.EnableTabButton("Cards_Myth", false);
   a_spellbookWindow.EnableTabButton("Cards_Life", false);
   a_spellbookWindow.EnableTabButton("Cards_Death", false);
   a_spellbookWindow.EnableTabButton("Cards_Balance", false);
   a_spellbookWindow.EnableTabButton("Cards_Treasure", false);
end

-- If aBool is true, disable the user from clicking on the specified cards   
function DisableCard(cardNum, aBool)
   DisableCards(cardNum, cardNum, aBool);
end
    
-- If aBool is true, disable the user from clicking on the specified cards; cards specified by range
function DisableCards(cardNum1, cardNum2, aBool)   
   local planningPhaseWindow = OpenClass(FindNamedWindow("PlanningPhase"));
   local spellSelectionWindow = planningPhaseWindow.FindNamedWindow("SpellSelection");   
   if(cardNum1 <= cardNum2) then   
      local num;
      for num = cardNum1, cardNum2 do
         local curSpell = spellSelectionWindow.FindNamedWindow("Card"..tostring(num+1));
         if(curSpell) then
            if(aBool == true) then
               curSpell.BlockMouse(true);
            else
               curSpell.BlockMouse(false);
            end
         else
            Log("Error in DisableCards: curSpell is nil when cardNum is "..num);
         end
      end
   else
      Log("Error in DisableCards: param1 must be <= param2!");
   end   
end

-- Show/Hide all GUI elements as specified by a list of window names
-- Added new functionality to preserve the visiblity state (visible or invisible) of all UI elements from
-- before this function was first called.  Use along with RestoreGUIElements to avoid any persistent changes to the UI
function ShowGUIElements(elemList, visibility)
   if(not gUIOriginalState) then
      gUIOriginalState = {};
   end
   for _,elem in pairs(elemList) do
      local window = OpenClass(FindNamedWindow(elem));
      if(window) then
         if(gUIOriginalState[elem] == nil) then
            gUIOriginalState[elem] = window.IsVisible();
         end
         window.SetVisible(visibility);
      end
      DestroyClass(window);
   end
end   

-- Use this along with ShowGUIElements to restore elements to their original state 
-- This is meant to replace the old ShowGUIElements({elements}, true) in that it restores the visibility of the desired UI elements
-- to the state they were in (visible or invisible) before ShowGUIElements was first called
function RestoreGUIElements(elemList)
   if(not gUIOriginalState) then
      gUIOriginalState = {};
   end
   for _,elem in pairs(elemList) do
      local window = OpenClass(FindNamedWindow(elem));
      if(window) then
         if(gUIOriginalState[elem]) then
            window.SetVisible(gUIOriginalState[elem]);
         end
      end
      DestroyClass(window);
   end
end

-- This function checks whether the player is in a pvp queue.
-- If they are, they are given the option to drop out of the PvP queue or 
-- take the tutorial later.
-- This will prevent the awkward situation where the player's UI is configured for tutorial
-- and they are pulled out to play PvP without the script knowing.
--
-- Return value: true - to continue the tutorial (CheckPvpStatus will remove the player from the pvp queue
--                         false - indicates the player does not wish to take the tutorial at this point.  To be handled in the calling function.
function CheckPvpStatus()
      --IsInPvP returns 0 for false, 1 for true
      if(IsInPvP() == 0) then
         return true; -- Player not in pvp queue, proceed as normal
      end

      TutorialDialog:ShowWindow(false);
            
   	TutorialDialog:SetConfirmationTitle("Tutorial_Title24");
   	TutorialDialog:SetConfirmationMessage("Tutorial_InPvP");
   	TutorialDialog:SetConfirmationYesLabel("Tutorial_Tutorial_Confirmation_Yes");
   	TutorialDialog:SetConfirmationNoLabel("Tutorial_Tutorial_Confirmation_No");   
   	TutorialDialog:MoveToBottom();
      
      if(TutorialDialog:GetConfirmation() == true) then
         PvpLeaveTeam();
         return true; -- player left pvp queue, proceed as normal
      end
      
      return false; -- player chose to remain in pvp queue and take tutorial another time; calling function should terminate the tutorial immediately 
end