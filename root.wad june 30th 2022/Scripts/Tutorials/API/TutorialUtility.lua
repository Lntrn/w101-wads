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
   -- make sure the player is frozen except when we explicitely allow them to move
   FreezePlayer();
   
   -- Try to reuse the same script objects if possible 
   gQuickChatButton = gQuickChatButton or OpenClass(FindNamedWindow("btnRadialQuickChat"));
   gHelpChatButton = gHelpChatButton or OpenClass(FindNamedWindow("btnHelpChat"));   
        gHealthGlobe = gHealthGlobe or OpenClass(OpenWindow("spriteHealthBkg"));
        gManaGlobe = gManaGlobe or OpenClass(OpenWindow("spriteManaBkg"));

   gExpBar = gExpBar or OpenClass(FindNamedWindow("XPBar"));
   
   if(phase >= 4) then
      if(gHealthGlobe) then
         gHealthGlobe.SetVisible(true);
      end
      if(gManaGlobe) then
         gManaGlobe.SetVisible(true);
      end
   end
   
   if(phase >= 6) then
      if(gExpBar) then
         gExpBar.SetVisible(true);
      end
      if(gQuickChatButton) then
         gQuickChatButton.SetVisible(true);
      end
   end

   UnfreezePlayer();
end

function RemoveInteraction()
   -- Try to reuse the same script objects if possible 
   gFriendsListButton = gFriendsListButton or OpenClass(FindNamedWindow("btnFriends"));
   gCompassButton = gCompassButton or OpenClass(FindNamedWindow("compassAndTeleporterButtons"));
     gSpellbookButton = gSpellbookButton or OpenClass(FindNamedWindow("btnSpellbook"));  
   gQuickChatButton = gQuickChatButton or OpenClass(FindNamedWindow("btnRadialQuickChat"));
   gHelpChatButton = gHelpChatButton or OpenClass(FindNamedWindow("btnHelpChat"));  
   gHealthGlobe = gHealthGlobe or OpenClass(OpenWindow("spriteHealthBkg"));
   gManaGlobe = gManaGlobe or OpenClass(OpenWindow("spriteManaBkg"));
   gEnergyGlobe = gEnergyGlobe or OpenClass(OpenWindow("spriteEnergyBkg"));
   gExpBar = gExpBar or OpenClass(FindNamedWindow("XPBar"));
   gTradeWindow = gTradeWindow or OpenClass(FindNamedWindow("TradeRequestWindow"));
   gEarnCrownsWindow = gEarnCrownsWindow or OpenClass(FindNamedWindow("btnEarnCrowns"));
   gPermShopButton = gPermShopButton or OpenClass(FindNamedWindow("PermShopButton"));
   gSubscribeButton = gSubscribeButton or OpenClass(FindNamedWindow("btnSubscribe"));
        
   UnmapKeys();
   
   ShowTips(false);   
   
   if(gSpellbookButton) then
      gSpellbookButton.SetVisible(false);
   end
   if(gCompassButton) then
      gCompassButton.SetVisible(false);
   end
   if(gFriendsListButton) then
      gFriendsListButton.SetVisible(false);
   end
   if(gHealthGlobe) then
      gHealthGlobe.SetVisible(false);
   end
   if(gManaGlobe) then
      gManaGlobe.SetVisible(false);
   end
   if(gEnergyGlobe) then
      gEnergyGlobe.SetVisible(false);
   end
   if(gExpBar) then
      gExpBar.SetVisible(false);
   else
   end
   if(gQuickChatButton) then      
      gQuickChatButton.SetVisible(false);
   end
   if(gHelpChatButton) then      
      gHelpChatButton.SetVisible(false);
   end
   if(gTradeWindow) then      
      gTradeWindow.SetVisible(false);
   end
   if(gEarnCrownsWindow) then      
      gEarnCrownsWindow.SetVisible(false);
   end
   if(gPermShopButton) then
      gPermShopButton.SetVisible(false);
   end
   if(gSubscribeButton) then
      gSubscribeButton.SetVisible(false);
   end   
end

function RestoreInteraction()   
   RestoreCompassButton();
   RestoreGlobes();
   RestoreExpBar();
   RestoreQuickChatButton();
   RestoreHelpChatButton();
   RestoreTradeWindow();
  -- RestoreCrownsWindow();
   RestorePermShopButton();
   if(gClientTutorial) then
      gClientTutorial.RestoreSubscribeButton();
   end
end

function RestoreSpellbookButton()
   gSpellbookButton = gSpellbookButton or OpenClass(FindNamedWindow("btnSpellbook"));  
   if(gSpellbookButton) then
      gSpellbookButton.SetVisible(true);
   end
end

function RestoreCompassButton()
   gCompassButton = gCompassButton or OpenClass(FindNamedWindow("compassAndTeleporterButtons"));
   if(gCompassButton) then
      gCompassButton.SetVisible(true);
   end
end

function RestoreGlobes()
   gHealthGlobe = gHealthGlobe or OpenClass(OpenWindow("spriteHealthBkg"));
   gManaGlobe = gManaGlobe or OpenClass(OpenWindow("spriteManaBkg"));
   gEnergyGlobe = gEnergyGlobe or OpenClass(OpenWindow("spriteEnergyBkg"));

   if(gHealthGlobe) then
      gHealthGlobe.SetVisible(true);
   end
   if(gManaGlobe) then
      gManaGlobe.SetVisible(true);
   end
   if(gEnergyGlobe) then
      gEnergyGlobe.SetVisible(true);
   end
end

function RestoreExpBar()
   gExpBar = gExpBar or OpenClass(FindNamedWindow("XPBar"));
   if(gExpBar) then
      gExpBar.SetVisible(true);
   end
end

function RestoreQuickChatButton()
   gQuickChatButton = gQuickChatButton or OpenClass(FindNamedWindow("btnRadialQuickChat"));
   if(gQuickChatButton) then
      gQuickChatButton.SetVisible(true);
   end
end

function RestoreHelpChatButton()
   gHelpChatButton = gHelpChatButton or OpenClass(FindNamedWindow("btnHelpChat"));
   if(gHelpChatButton) then
      gHelpChatButton.SetVisible(true);
   end
end

function RestoreTradeWindow()
   gTradeWindow = gTradeWindow or OpenClass(FindNamedWindow("TradeRequestWindow"));
   if(gTradeWindow) then
      gTradeWindow.SetVisible(true);
   end
end

function RestoreCrownsWindow()
   Log("restore Earn Crowns Window");
   gEarnCrownsWindow = gEarnCrownsWindow or OpenClass(FindNamedWindow("btnEarnCrowns"));
   if(gEarnCrownsWindow) then
      gEarnCrownsWindow.SetVisible(true);
   end
end

function RestorePermShopButton()
   gPermShopButton = gPermShopButton or OpenClass(FindNamedWindow("PermShopButton"));
   if(gPermShopButton) then
      gPermShopButton.SetVisible(true);
   end
end


function RestoreFriendsListButton()
   gFriendsListButton = gFriendsListButton or OpenClass(FindNamedWindow("btnFriends"));
   if(gFriendsListButton) then
      gFriendsListButton.SetVisible(true);
   end
end

function ShowTips(a_bool)
   gWorldWin = gWorldWin or OpenClass(GetWorldWindow());
   gTipFrame = gTipFrame or OpenClass(FindNamedWindow("TipWindow"));
   if(gTipFrame) then
      gTipFrame.ShowTips(a_bool);
   else
      Log("Error in TutorialUtility::ShowTips(): Unable to find GUI element for 'TipWindow'");
   end
end

function DisableSpellbookTabs(a_tabList)
   GetSpellbookWindow();
   
   for _,tab in pairs(a_tabList) do
      gSpellbookWindow.EnableTabButton(tab, false);
   end   
end

function EnableSpellbookTabs()      
   GetSpellbookWindow();
   --gSpellbookWindow.EnableTabButton("CharStats", true);
   --gSpellbookWindow.EnableTabButton("Inventory", true);
   --gSpellbookWindow.EnableTabButton("Deck", true);
   --gSpellbookWindow.EnableTabButton("Quest", true);
   --gSpellbookWindow.EnableTabButton("Maps", true);
   --gSpellbookWindow.EnableTabButton("Multiverse", true);
   gSpellbookWindow.EnableTabButton("Preferences", true);
   gSpellbookWindow.EnableTabButton("Help", true);      
end

-- If aBool is true, disable the user from clicking on the specified cards   
function DisableCard(cardNum, aBool)
   DisableCards(cardNum, cardNum, aBool);
end
    
-- If aBool is true, disable the user from clicking on the specified cards; cards specified by range
function DisableCards(cardNum1, cardNum2, aBool)   
   GetPlanningPhaseWindow();
   gSpellSelectionWindow = gSpellSelectionWindow or gPlanningPhaseWindow.FindNamedWindow("SpellSelection");   
   if(cardNum1 <= cardNum2) then   
      local num;
      for num = cardNum1, cardNum2 do
         local curSpell = gSpellSelectionWindow.FindNamedWindow("Card"..tostring(num+1));
         if(curSpell) then
            if(aBool == true) then
               curSpell.BlockMouse(true);
            else
               curSpell.BlockMouse(false);
            end
            DestroyClass(curSpell);
         else
            Log("Error in DisableCards: curSpell is nil when cardNum is "..num);
         end
      end
   else
      Log("Error in DisableCards: param1 must be <= param2!");
   end   
end

function WaitForMobGID()
   Log("Waiting on Mob GID...");
   RegisterEvent("CombatAddMob");
   local event = GetEvent("CombatAddMob");
   MobID = event.OwnerID;
   if(MobID) then
      Log("Got Mob OwnerID "..MobID);
   else
      Log("Got Mob with NIL OwnerID!");
   end
   UnregisterEvent(eventName);
end

function CreateDockedArrow(window)
   local myArrow = TutorialArrow(window,"Bottom",64,0.5,0.5,true);
   --local myArrow = CreateSpriteClass("Art/Art_Tutorial_Arrow.dds",MakeRectString(0,0,70,128),false,window);
   -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   --myArrow.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
   --myArrow.m_Flags = "VISIBLE|DOCK_TOP|DOCK_OUTSIDE|HCENTER";
   myArrow:ShowWindow(true);
   return myArrow;
end

-- Query for the Planning Phase window and turn on and off buttons, etc.   
function FindAndConfigurePlanningPhase()
   GetEvent("OpenPlanningPhase");

   -- Reset all script object pointers to the planning phase window and its children
   if(gPlanningPhaseWindow) then
      DestroyClass(gPlanningPhaseWindow);
      gPlanningPhaseWindow = nil;
   end
   GetPlanningPhaseWindow();      
   if(gPassButton) then
      DestroyClass(gPassButton);
   end
   gPassButton = gPlanningPhaseWindow.FindNamedWindow("Focus");
   gPassButton.SetVisible(false);   
   if(gFleeButton) then
      DestroyClass(gFleeButton);
   end
   gFleeButton = gPlanningPhaseWindow.FindNamedWindow("Flee");
   gFleeButton.SetVisible(false);   
   if(gHelpButton) then
      DestroyClass(gHelpButton);
   end
   gHelpButton = gPlanningPhaseWindow.FindNamedWindow("HelpText");
   gHelpButton.SetVisible(false);   
   if(gCountText) then
      DestroyClass(gCountText);
   end
   gCountText = gPlanningPhaseWindow.FindNamedWindow("CountText");   
   gCountText.SetVisible(false);   
   if(gSpellSelectionWindow) then
      DestroyClass(gSpellSelectionWindow);
   end
   gSpellSelectionWindow = gPlanningPhaseWindow.FindNamedWindow("SpellSelection");   
end

-- This function prevents the script engine from holding a reference to the 
-- stale planning phase window so it can be deleted
-- Thus it fixes the bug where one can click on a mob during the cinematics
-- and a selection sound would play.
function ReleasePlanningPhaseWindow()  
   if(gPlanningPhaseWindow) then
      DestroyClass(gPlanningPhaseWindow);
      gPlanningPhaseWindow = nil;
   end
end

function ShowPassButton(aBool)
   GetPlanningPhaseWindow();
   gSpellSelectionWindow = gSpellSelectionWindow or gPlanningPhaseWindow.FindNamedWindow("SpellSelection");
   gPassButton = gPassButton or gPlanningPhaseWindow.FindNamedWindow("Focus");
   gPassButton.SetVisible(aBool);
   
   if(aBool == true) then
      PassArrow = CreateDockedArrow(gPassButton);
   elseif(PassArrow) then
      PassArrow:ShowWindow(false);
   end

end

function ForcePass()
   GetPlanningPhaseWindow();
   gPassButton = gPassButton or gPlanningPhaseWindow.FindNamedWindow("Focus");
   gPlanningPhaseWindow.SetVisible(true);
   gPassButton.SetVisible(true);
   -- "Click" the pass button 
   gPassButton.SetButtonDown(true);
   -- Pause 250 milliseconds
   Sleep(250); 
   gPassButton.SetButtonDown(false);   
   Log("Forcing the player to pass...");
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
   Log("RestoreGUIElements");
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

-- Expand the indicated card to its full mouse-over size if aBool is true, or return it to normal size if aBool is false
function ExpandCard(cardNum, aBool)
   ExpandCards(cardNum, cardNum, aBool);
end

-- Expand the indicated card to its full mouse-over size if aBool is true, or return it to normal size if aBool is false; cards specified by range
function ExpandCards(cardNum1, cardNum2, aBool)   
   GetPlanningPhaseWindow();
   gSpellSelectionWindow = gSpellSelectionWindow or gPlanningPhaseWindow.FindNamedWindow("SpellSelection");   
   if(cardNum1 <= cardNum2) then   
      local num;
      for num = cardNum1, cardNum2 do
         local spellBalloon = gSpellSelectionWindow.FindNamedWindow("Card"..tostring(num+1)).Parent();
         if(spellBalloon) then
            if(aBool == true) then
               spellBalloon.Inflate(num);
            else
               spellBalloon.Deflate(num);
            end
            DestroyClass(spellBalloon);
         else
            Log("Error in ExpandCards: spellBalloon is nil when cardNum is "..num);
         end
      end
   else
      Log("Error in ExpandCards: param1 must be <= param2!");
   end   
end

function CreateIllustration(imageFile)
   local image = CreateSpriteClass(imageFile,MakeRectString(0,0,618,404),false,nil);
   image.SetLocation( 0, 0 );
   image.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
   image.m_Flags = "HCENTER|DOCK_BOTTOM";
   image.SetVisible(true);
   
   return image;
end

function Sleep(aNumMilliSeconds)
   local gameTimer = Timer();
   local startTime = gameTimer:GetTime();
   while(gameTimer:GetTime() < startTime + aNumMilliSeconds) do end
end    

-- Wait for and return one of two expected events
function GetEvents(event1, event2)
   local oneOrTwo = false;  -- false = one, true = two
   
   while ( true ) do
      local event = GetEvent(event1, false);
      if ( event ~= nil) then
        oneOrTwo = false;
        break;
      end
      
      event = GetEvent(event2, false);
      if(event ~= nil) then
        oneOrTwo = true;
        break;
      end
      Sleep(100);
   end
   
   if( oneOrTwo == true ) then
      return event2;
   else
      return event1;
   end
end

g_WorldPackages = 
{
   "Mob-WorldData",
   "GUI-WorldData",
   "Sound_Dialogue-WorldData",
   "Sound_Dialogue_KT-WorldData",
   "Sound_Dialogue_MB-WorldData",
   "Sound_Dialogue_MS-WorldData",
   "Sound_Dialogue_DS-WorldData",
   "Sound_Dialogue_GH-WorldData",
   "Sound_Dialogue_CL-WorldData",
   "Sound_Dialogue_GDN-WorldData",
   "Sound_Dialogue_TRI-WorldData",
   "Sound_Dialogue_GH1-WorldData",
   "Sound_Dialogue_GH2-WorldData",
   "Sound_MusicPreview_GH2-WorldData",
   "Sound_Dialogue_WYS-WorldData",
   "Sound_Dialogue_ZF-WorldData",
   "Sound_Dialogue_AVA-WorldData",
   "HousingObject-WorldData",
   "_Shared-WorldData",
   "WizardCity-WC_Hub",
   "WizardCity-WorldData",
   "WizardCity-Interiors-WC_Headmaster_Tower",
   "WizardCity-Interiors-WC_Headmistress_House"
}; 

-- Returns the percent progress patching all of WorldPackages
-- Note: Equipment and _Shared WorldData contain >90% of the overall file size
function GetWorldReadyPercentage()
   local totalElements = table.getn(g_WorldPackages);
   if(totalElements == 0) then
      return 0;
   end
   
   local patchedElements = 0;  
   for _,elem in pairs(g_WorldPackages) do
      if( TestIfPackageIsPatched(elem) == true) then         
         patchedElements = patchedElements + 1;
      end
   end   
      
   return patchedElements / totalElements;
end
  
-- Returns true if all the necessary game data has patched and we are ready to let them leave the tutorial
function IsWorldReady()
   local ready = true;
   for _,elem in pairs(g_WorldPackages) do
      ready = ready and TestIfPackageIsPatched(elem);
   end   
   return ready;
end

--The IsPackagePatched function is a C function, so it can't return false to Lua.
--Instead, it returns a 0, which is what false get's converted to.  So, we have to check for
--that case and return the proper boolean value.
function TestIfPackageIsPatched(pkg)   
   if(IsPackagePatched(pkg) == 0) then
      return false;
   else
      return true;
   end
end

function UpdatePatcherOverlay()
   gTutorialProgressBar = gTutorialProgressBar or OpenClass(FindNamedWindow("TransferProgressBar"));
   if(not gTutorialProgressBar) then
      return false;
   end
   
   gTutorialProgressBar.SetPosition(GetWorldReadyPercentage());        
   return true;   
end

-- keep trying to get a handle on the Planning Phase Window into the global gPlanningPhaseWindow
-- Don't get a new handle if we already have one; just return
function GetPlanningPhaseWindow()
   local timeOut = 10000; -- in milliseconds
   local count = 0;
   local sleepAmt = 250;
   while(count < timeOut) do -- keep trying to get a handle on the window until we get it
      gPlanningPhaseWindow = gPlanningPhaseWindow or OpenClass(FindNamedWindow("PlanningPhase"));
      if(gPlanningPhaseWindow) then break; end;
      
      Log("WARNING: Could not find the planning phase window!");
      count = count + sleepAmt;
      Sleep(sleepAmt);        
   end   
end

-- keep trying to get a handle on the Spellbook Window into the global gSpellbookWindow
-- Don't get a new handle if we already have one; just return
function GetSpellbookWindow(whichTab)
   SendClientEvent(whichTab);
   local timeOut = 10000; -- in milliseconds
   local count = 0;
   local sleepAmt = 250;
   while(count < timeOut) do -- keep trying to get a handle on the window until we get it
      gSpellbookWindow = gSpellbookWindow or OpenClass(FindNamedWindow("DeckConfiguration"));
      if(gSpellbookWindow) then break; end;
      
      Log("WARNING: Could not find the spell book window!");
      count = count + sleepAmt;
      Sleep(sleepAmt);        
   end
end

function DisplayArrowsOnCards()   
   gSpellSelectionWindow = gSpellSelectionWindow or gPlanningPhaseWindow.FindNamedWindow("SpellSelection");
   
   if(not gSpellArrows) then
      gSpellArrows = {};
   end
   
   for i=0,6,1 do
      local curSpell = gSpellSelectionWindow.FindNamedWindow("Card"..tostring(i+1));      
      if(not gSpellArrows[i]) then
         local newArrow = CreateTopArrow(curSpell);
         gSpellArrows[i] = newArrow;
      end
      gSpellArrows[i]:ShowWindow(true);
      DestroyClass(curSpell);
   end
end

function ClearArrowsFromCards()
   for i=0,6,1 do      
      gSpellArrows[i]:ShowWindow(false);
   end
end

function DestroyArrowsOnCards()
   for i=0,6,1 do      
      if(gSpellArrows[i]) then
         gSpellArrows[i]:DetachSelf();
         DestroyClass(gSpellArrows[i]);
      end
   end
   gSpellArrows = {};
end

--  repeat displaying arrows on cards until a target is selected (if waitForTarget is true)
function GetCardInteraction(waitForTarget)
   RegisterEvent("CombatCardSelected");
   RegisterEvent("CombatTargetSelected");   
   
   DisplayArrowsOnCards(); 
   PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));   
   GetEvent("CombatCardSelected");
   ClearArrowsFromCards();   
   
   while(waitForTarget) do    
      RegisterEvent("InvalidSelection");
      local event = GetEvents("CombatTargetSelected", "InvalidSelection");
      if(event == "CombatTargetSelected") then
         UnregisterEvent("InvalidSelection");
         break;
      else
         UnregisterEvent("InvalidSelection");
         DisplayArrowsOnCards();   
         GetEvent("CombatCardSelected");
         ClearArrowsFromCards();
      end
   end   
   
   -- Cut off any playing dialog sounds
   StopDialogSound();
   
   DestroyArrowsOnCards();

   UnregisterEvent("CombatCardSelected");
   UnregisterEvent("CombatTargetSelected");   
end

function ResetTutorialDialog()
   if(gTutorialDialog) then
      gTutorialDialog:DetachSelf();
      DestroyClass(gTutorialDialog);
   end
   gTutorialDialog = TutorialDialog();      
   gTutorialDialog:ShowWindow(false);
end

function PlayDelayDialog(a_sound)
   --Sleep(250);   
   PlayDialogSound(a_sound);
end

function GetClientID(a_templateID)
-- loop until we get an ID
   local ID = -1;
   local count = 0;
   local maxCount = 10;
   for count = 0, maxCount do
      ID = FindClientObjectInWorldByTemplateID(a_templateID);
      if(tonumber(ID) == nil) then  
         break;
      end;
      Sleep(500); -- sleep for 1/2 second
   end;   
   if(count == maxCount) then
      Log("ERROR - could not find client object for Gamma in Movement Tutorial!");
   end;
   
   return ID;
end


function RemapKeys()
   RemapKey("ToggleGUI");
   RemapKey("ToggleQuestList");
   RemapKey("ToggleCraftingPage");
   RemapKey("ToggleCharStats");
   RemapKey("TogglePetStats");
   RemapKey("ToggleMapWindow");
   RemapKey("ToggleWorldWindow");
   RemapKey("ToggleInventory");
   RemapKey("DisplayBuddyList");
   RemapKey("DisplayLogin");
   RemapKey("ToggleDeckConfig");   
   RemapKey("TogglePvPStatus"); 
   RemapKey("ChatBoxReply");
   RemapKey("RecallLocation");
   RemapKey("GoHub");
   RemapKey("GoHome");
   RemapKey("ToggleCombatInfo");
   RemapKey("ToggleFurniture");   
   RemapKey("TogglePermanentCrownShop");   
   RemapKey("DisplayNewBuddyList");   
   RemapKey("OpenMonsterTome");   
   RemapKey("ToggleJewelInventory");   
   RemapKey("ToggleSelfieCameraMode");   
   RemapKey("DisplayFishBasket");
   RemapKey("DisplayPhotography");
end

function UnmapKeys()
   UnmapKey("ToggleGUI");
   UnmapKey("ToggleQuestList");
   UnmapKey("ToggleCraftingPage");
   UnmapKey("ToggleCharStats");
   UnmapKey("TogglePetStats");
   UnmapKey("ToggleMapWindow");
   UnmapKey("ToggleWorldWindow");
   UnmapKey("ToggleInventory");
   UnmapKey("DisplayBuddyList");
   UnmapKey("DisplayLogin");
   UnmapKey("ToggleDeckConfig");
   UnmapKey("TogglePvPStatus");
   UnmapKey("ChatBoxReply");
   UnmapKey("RecallLocation");
   UnmapKey("GoHub");
   UnmapKey("GoHome");
   UnmapKey("ToggleCombatInfo");
   UnmapKey("ToggleFurniture");   
   UnmapKey("TogglePermanentCrownShop");
   UnmapKey("DisplayNewBuddyList");
   UnmapKey("OpenMonsterTome");
   UnmapKey("ToggleJewelInventory");
   UnmapKey("ToggleSelfieCameraMode");
   UnmapKey("DisplayFishBasket");
   UnmapKey("DisplayPhotography");
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

      ResetTutorialDialog();
      gTutorialDialog:SetConfirmationTitle("Tutorial_Title24");
      gTutorialDialog:SetConfirmationMessage("Tutorial_InPvP");
      gTutorialDialog:SetConfirmationYesLabel("Tutorial_Tutorial_Confirmation_Yes");
      gTutorialDialog:SetConfirmationNoLabel("Tutorial_Tutorial_Confirmation_No");   
      gTutorialDialog:MoveToBottom();
      
      if(gTutorialDialog:GetConfirmation() == true) then
         PvpLeaveTeam();
         return true; -- player left pvp queue, proceed as normal
      end
      
      return false; -- player chose to remain in pvp queue and take tutorial another time; calling function should terminate the tutorial immediately 
end

function SkipTutorial()
      -- Stop listeneing for rewards so we don't tip off the player that we're giving the wand now
      StopListeningForRewards();

      Log("Skipping Tutorial at stage "..gClientTutorial.m_stage);

      if  (gClientTutorial.m_stage < 4) then
         gClientTutorial.RequestGoalCompletion("WC-TUT-C08-001","SkipTutorialGoal");
      else
         gClientTutorial.RequestGoalCompletion("WC-TUT-C08-001","Teleport");
      end

      gClientTutorial.RequestRemoveQuest("WC-TUT-C05-001");        
      GetEvent("OnTeleported");

      if (gClientTutorial.m_stage < 4) then
         gClientTutorial.RequestEquipItems();
      end
      gClientTutorial.RequestAdvanceStage(8);

      RestoreInteraction(); 
      -- restore the bug reporter button to it's pre-tutorial visibility
      RestoreGUIElements({"btnFeedback"});
      RestoreFriendsListButton();
      RemapKeys();      
      gClientTutorial.UnsetTutuorialGUIState();
      ShowTips(true);        
      
      -- Resume listeneing for rewards
      StartListeningForRewards();
      
      -- Complete the tutorial
      gClientTutorial.RequestGoalCompletion("Tutorial_Intro","OnlyGoal");
end
