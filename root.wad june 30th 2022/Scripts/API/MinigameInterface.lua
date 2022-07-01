--[[

   MinigameInterface.lua

	Provide a standard interface to minigame instructions and high scores 

	Author: Gem Kosan
	KingsIsle Entertainment
	Date: January 31, 2008
]]

-- Include classes that are needed for various UIs
Include( "API/Classes/class.lua");
Include( "API/ControlClasses.lua" );
Include( "API/Utilities.lua" );

Include("API/Debug.lua");
Include("API/Globals.lua");
Include("API/BitManip.lua");
Include("API/Classes/ControlMessageBox.lua");
Include("API/KeyCodes.lua");
Include("API/Classes/Timer.lua");

MG_INT_EVENTS = {};
MG_INT_GAME_NAME = nil;
MG_INT_INS_PAGE = 1;
MG_INT_NUM_INS_PAGES = 1;
MG_INT_INS_TEXT = {};
MG_INT_HIDE_SCORES = false;



-- "PUBLIC " INTERFACE METHODS

--[[
         IMPORTANT NOTE regarding use of a_sGameName string parameter in the methods  below:
         
         The a_GameName specifies the name of the minigame that is calling this interface API.  It also determines what Minigame Name Banner is displayed for the minigame interface and which instructions are displayed.
         If it doesn't match the sub-string of the banner image name or the key to the game's instructions in the proper string table, undesirable results WILL occur.
         
         Thus, the Title banner must be found under GameData/ZoneData/_Shared/WorldData/GUI/Titles, and its file name must be in the form "Title_<a_sGameName>_.dds", minus the quotes.
         Likewise, all minigame instruction strings must be located within the MinigameInstructions string table, and they keys must be in the form "<a_sGameName>_P_L" where P is the Page number on which to display the instruction and L is the Line number on that page. 
         In this way, instructions can be logically divided into multiple pages and lines within those pages.  Page and line numbers MUST be sequential for a given minigame, otherwise this script will stop looking after the first numerical gap.
         i.e. After displaying line 3 from page 1, it will look for line 4 on page 1.  If this cannot be found, it will try line 1 on page 2.  If this also cannot be found, the script will assume that all instructions for this game have been loaded from the string table.
--]]

-- Call from client.lua script immediately after starting, and pass the game name string
-- This presents the initial screen for all minigames and allows you to view instructions and high scores
function DoPreGameInterface(a_sGameName, a_bHideScores, a_rewardMessage, a_rewardScoreField)

   -- Freeze the player so you don't hear their footsteps in the phantom zone
   FreezePlayer();

   Log("Pre-Minigame Interface loaded for "..a_sGameName);
   MG_INT_GAME_NAME = a_sGameName;
   MG_INT_EVENTS["MinigameScores"] = INTERFACE_SCORES_EVENT;  
   
   if(a_bHideScores and a_bHideScores == true) then 
      MG_INT_HIDE_SCORES = true;
      Log("Minigame Interface Hiding high scores button");
   end
   
   if(initInterface() == false) then
      return false;
   end   
   showInterface();
   
   -- Send a dummy rewards message so we can get the hi scores list
   local rewardInfo = {};
   rewardInfo.gameName = a_sGameName;
   local scoreField = a_rewardScoreField or "score"; -- allow the reward message "score" field name to be overridden
   rewardInfo[scoreField] = -1;
   a_rewardMessage = a_rewardMessage or Messages.Rewards; -- allow the reward message name to be overridden.
   SendProcessMessage(a_rewardMessage, rewardInfo);
   
   return interfaceEventLoop();
end

-- Call from client.lua script immediately after requesting rewards, and pass the game name string
-- This presents the post-game screen for all minigames and allows you to view your high scores and game instructions
function DoPostGameInterface(a_sGameName, a_rewardInfo, a_bHideScores, a_rewardMessage)           
   MG_INT_EVENTS["MinigameScores"] = INTERFACE_SCORES_EVENT;   
   MG_INT_GAME_NAME = a_sGameName; 

   local score = a_rewardInfo.score or a_rewardInfo.Score or "NIL";
   Log("Post-Minigame Interface loaded for "..a_sGameName.." with score = "..score);
   if(a_bHideScores and a_bHideScores == true) then
      Log("Hiding Scores");
   end
   if(a_rewardMessage) then
      Log("Overriding default reward message with "..a_rewardMessage);
   end

   if(initInterface() == false) then
      Log("Error in MinigameInterface.lua: Unable to initialize interface");
      return false;
   end  
   
   if(a_bHideScores and a_bHideScores == true) then 
      MG_INT_HIDE_SCORES = true;
      Log("Minigame Interface Hiding high scores button");
   else
      MG_INT_INSMODE = false;
      MG_INT_PLAY_BUTTON.SetLabel("<string;MinigameInstructions_interface_play></string>");  
   end
   
   if(a_rewardInfo) then
      Log("Send process message rewards");
      a_rewardMessage = a_rewardMessage or Messages.Rewards;
      SendProcessMessage(a_rewardMessage, a_rewardInfo);
   else
      Log("No reward info passed into post-game interface");
   end
         
   return interfaceEventLoop();
end
-- END OF PUBLIC METHODS




-- "PRIVATE "  METHODS

function INTERFACE_SCORES_EVENT(a_event)
      --loading and displaying the high scores is handled in the graphical client due to Unicode issues
      if(a_event.Success == 0) then
         showInterface();
      end
end

function INTERFACE_BUTTONUP_EVENT(a_event)
   if (a_event.Name == "mg_int_toggle_mode") then
      interfaceOnMode();
   elseif(a_event.Name == "mg_int_play") then
      interfaceOnPlay();
   elseif(a_event.Name == "mg_int_exit") then
      interfaceOnExit();
   elseif(a_event.Name == "rewards_exit") then
      showInterface();
   elseif(a_event.Name == "mg_int_pg_left") then
      interfaceGotoInstructionsPage(MG_INT_INS_PAGE - 1);
   elseif(a_event.Name == "mg_int_pg_right") then
      interfaceGotoInstructionsPage(MG_INT_INS_PAGE + 1);
   end
end
MG_INT_EVENTS["WB_BUTTONUP"] = INTERFACE_BUTTONUP_EVENT;

function interfaceEventLoop()

   while(MG_INT_EXIT == false) do            
      event = GetEvent("");  
      local func = MG_INT_EVENTS[event.EventName];  
      if func then
         func(event);
      end      
   end   

   hideInterface();
   
   return MG_INT_RETVAL;
end

function interfaceOnMode()
   MG_INT_INSMODE = (not MG_INT_INSMODE);   
   updateInterface();
end

function interfaceOnPlay()
   MG_INT_EXIT = true;
   MG_INT_RETVAL = true;
end

function interfaceOnExit()
   MG_INT_EXIT = true;
   MG_INT_RETVAL = false;
   UnfreezePlayer();
end

function updateInterface()
   MG_INT_INSTRUCTIONS_FRAME.ShowWindow(MG_INT_INSMODE);
   MG_INT_SCORES_FRAME.ShowWindow(not MG_INT_INSMODE);
   if(MG_INT_HIDE_SCORE == true) then
      MG_INT_MODE_BUTTON.ShowWindow(false);
   end
   if(MG_INT_INSMODE == true) then
      MG_INT_MODE_BUTTON.SetLabel("<string;MinigameInstructions_interface_scores></string>");  
	  MG_INT_MODE_BUTTON.SetTip("<string;MinigameInstructions_interface_scores>", true);
   else
      MG_INT_MODE_BUTTON.SetLabel("<string;MinigameInstructions_interface_help></string>");  
	  MG_INT_MODE_BUTTON.SetTip("<string;MinigameInstructions_interface_help>", true); 
   end    
end

function showInterface()
   MG_INT_MAIN_WIN.ShowWindow(true);
   updateInterface();
end

function hideInterface()
   MG_INT_MAIN_WIN.ShowWindow(false);
   MG_INT_MAIN_WIN.DetachSelf();
end

function initInterface()
   MG_INT_EXIT = false;
   MG_INT_RETVAL = false;
   MG_INT_INSMODE = true; -- set to true when displaying instructions, false when displaying high scores

   -- Register all required events
   for eventName, _ in pairs( MG_INT_EVENTS ) do
      RegisterEvent( eventName );
   end    

   MG_INT_MAIN_WIN = CreateGUIClass("MinigameInterface.gui",false);
   if(not MG_INT_MAIN_WIN) then
      Log("Error in MinigameInterface.lua: Could not load resource 'MinigameInterface.gui'");
      return(false);
   end
   MG_INT_INSTRUCTIONS_FRAME = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_instructions_frame");
   if(not MG_INT_INSTRUCTIONS_FRAME) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_instructions_frame'");
      return(false);
   end
   MG_INT_INSTRUCTIONS = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_instructions");
   if(not MG_INT_INSTRUCTIONS) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_instructions'");
      return(false);
   end
   MG_INT_SCORES_FRAME = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_scores_frame");
   if(not MG_INT_SCORES_FRAME) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_scores_frame'");
      return(false);
   end
   MG_INT_HIGH_SCORES = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_high_scores");
   if(not MG_INT_HIGH_SCORES) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_high_scores'");
      return(false);
   end
   MG_INT_BACKGROUND = MG_INT_MAIN_WIN.FindNamedWindow("MGInterfaceBG");
   if(not MG_INT_BACKGROUND) then
      Log("Error in MinigameInterface.lua: Could not load resource 'MGInterfaceBG'");
      return(false);
   end
   MG_INT_MODE_BUTTON = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_toggle_mode");
   if(not MG_INT_MODE_BUTTON) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_toggle_mode'");
      return(false);
   end
   if(true == MG_INT_HIDE_SCORES) then
      MG_INT_MODE_BUTTON.ShowWindow(false);
   end
   MG_INT_PLAY_BUTTON = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_play");
   if(not MG_INT_PLAY_BUTTON) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_play'");
      return(false);
   end
   MG_INT_EXIT_BUTTON = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_exit");
   if(not MG_INT_EXIT_BUTTON) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_exit'");
      return(false);
   end
   MG_INT_PAGE_BUTTONS = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_page_buttons");
   if(not MG_INT_PAGE_BUTTONS) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_page_buttons'");
      return(false);
   end
   MG_INT_PG_LEFT_BUTTON = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_pg_left");
   if(not MG_INT_PG_LEFT_BUTTON) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_pg_left'");
      return(false);
   end
   MG_INT_PG_RIGHT_BUTTON = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_pg_right");
   if(not MG_INT_PG_RIGHT_BUTTON) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_pg_right'");
      return(false);
   end
   MG_INT_PAGE_IDX = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_page_idx");
   if(not MG_INT_PAGE_IDX) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_page_idx'");
      return(false);
   end
   
   MG_INT_PAGE_BUTTONS.ShowWindow(false);
   
   interfaceLoadTitle();
   interfaceGotoInstructionsPage(1);

   return true;
end

function interfaceLoadTitle()
   local titleString = "MinigamesCommon_Title_"..MG_INT_GAME_NAME;
   if(string.find(string.lower(GetString(titleString)), "<small>") ~= nil) then --is it small sized text?
      MG_INT_TITLE_TEXT = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_title_small");   
   else
      MG_INT_TITLE_TEXT = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_title");         
   end   
   
   if(MG_INT_TITLE_TEXT) then
      MG_INT_TITLE_TEXT.SetText("<string;"..titleString.."></string>");      
   end   

   MG_INT_BANNER = MG_INT_MAIN_WIN.FindNamedWindow("mg_int_banner");
   if(not MG_INT_BANNER) then
      Log("Error in MinigameInterface.lua: Could not load resource 'mg_int_banner'");
      return(false);
   end   
   local fileName = "Titles/Title_"..MG_INT_GAME_NAME..".dds";   
   MG_INT_TITLE_WIN = CreateSpriteClass(fileName, MakeRectString(0, 0, 600, 260), true, MG_INT_BANNER);
   MG_INT_TITLE_WIN.SetFlags(0x8201); -- HCENTER | DOCK_TOP | VISIBLE
end

function interfaceLoadScores()
	Log("LoadScore");
   local pageHeader = "<CENTER><LARGE><string;MinigamesCommon_HIGHSCORES></string></LARGE></CENTER>"
   MG_INT_HIGH_SCORES.SetText(pageHeader.."\n"..MG_INT_SCORES_TEXT);
end

function interfaceGotoInstructionsPage(a_pageNum)
   MG_INT_NUM_INS_PAGES = SetMinigameInstructionsPage(MG_INT_INSTRUCTIONS, "MinigameInstructions_"..MG_INT_GAME_NAME, a_pageNum);
   MG_INT_INS_PAGE = a_pageNum;     
   CLAMP(MG_INT_INS_PAGE, 1, MG_INT_NUM_INS_PAGES);   
   
   MG_INT_PG_RIGHT_BUTTON.SetGreyed(MG_INT_INS_PAGE >= MG_INT_NUM_INS_PAGES);
   MG_INT_PG_LEFT_BUTTON.SetGreyed(MG_INT_INS_PAGE <= 1);
   MG_INT_PAGE_BUTTONS.ShowWindow(MG_INT_NUM_INS_PAGES > 1);

   local pageIdx = "<center><string;MinigamesCommon_PAGE_PART;PAGENUM;"..MG_INT_INS_PAGE..";PAGECOUNT;"..MG_INT_NUM_INS_PAGES.."></center>";
   MG_INT_PAGE_IDX.SetText(pageIdx);
   
   MG_INT_PAGE_IDX.ShowWindow(MG_INT_NUM_INS_PAGES > 1);
end

-- END OF PRIVATE METHODS
