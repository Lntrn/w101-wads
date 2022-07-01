Socia = 0;
Wizard = 1;

GAME = Wizard;

--Offsets for particle effects
SPO = {  combo_offsetx = 135,
         combo_offsety = 200,
         level_offsetx = 123,
         level_offsety = 350,
         points_offsetx = -120,
         points_offsety = 260,
         leveltext_offsetx = -75,
         leveltext_offsety = 315,
         warning_offsetx = 135,
         warning_offsety = 50
      }

WPO = {  combo_offsetx = 135,
         combo_offsety = 200,
         level_offsetx = 135,
         level_offsety = 185,
         points_offsetx = -85,
         points_offsety = 455,
         leveltext_offsetx = -70,
         leveltext_offsety = 485,
         warning_offsetx = 135,
         warning_offsety = 50
      }
      
PO = SPO; --Particle offsets
      
if (GAME == Wizard) then
   PO = WPO;
end

StartTime = 0;

function Socia_JoinSession(event)
   player = event.CharacterGID;
   StartTime = GetTime();
   
   ClientManager:AddClient(event.CharacterGID);
   ClientManager:RunClientProcess(event.CharacterGID, "Scripts/Client.lua");
end

function Wizard_JoinSession( event )   
   savedCharacterGID = event.CharacterGID;
   savedZoneID = GetZoneID( OwnerGID );
   
   LastTimeMSG_Moved = 0;
   WizGameTimer = Timer(); 

   ClientManager:AddClient( event.CharacterGID );
   ClientManager:RunClientProcess( event.CharacterGID, "Soblocks/Client.lua" );
end

function Socia_SendMessage(message, data)
   ClientManager:SendMessage(player, message, data);
end

function Wizard_SendMessage(message, data)
   ClientManager:SendMessage(savedCharacterGID, message, data);
end

function Socia_ClientProcessEnd(characterGID)
   FreeSlot(characterGID);
end

function Wizard_ClientProcessEnd(characterGID)
   Log("Soblocks Wizard_ClientProcessEnd, score=="..score);
   MinigameEnd(savedCharacterGID, score, savedZoneID); 
end

function Socia_EndGame(event)
   -- Update takes the following
   --   Name of the Game
   -- the id of the character
   -- whether or not the player won the game
   -- the score the player recieved
   -- the number of XP points for this game
   UpdateGameRegistry("SoBlocks", event.CharacterId, true, event.Score, 15);
   
   -- Update the ladder for this game..
   UpdateLadder( event.CharacterId, "SoblocksSolo", event.Score, 1, (GetTime() - StartTime) / 1000 );
end

function Wizard_EndGame(event)
   -- this runs server-side
   score = event.Score;
   Log("Soblocks Wizard_EndGame, score=="..score);
   MinigameRewards(savedCharacterGID, score, "Soblocks", 1000);
end

function Socia_StartSwap(event)
   if (not gameState.paused) then
      ClientManager:SendMessage(event.CharacterId, Messages.StartSwap, {});
   end
end

function Wizard_StartSwap(event)
   if (not gameState.paused) then
      ClientManager:SendMessage(event.CharacterId, Messages.StartSwap, {});
   end
   local currentTime = WizGameTimer:GetTime();
   if (currentTime - LastTimeMSG_Moved > 60000) then
      LastTimeMSG_Moved = currentTime;
      MinigameNotAFK(savedCharacterGID);
   end
end

function Socia_PreEndGame()
   GameOver.ShowWindow(true);
end

function Wizard_PreEndGame()
   -- Yes, BOTH of these DebugEndCriticalSection() calls are required!
   DebugEndCriticalSection();    
   DebugEndCriticalSection();    
end

function Socia_PostEndGame(a_score)
   SendProcessMessage(Messages.EndGame, {Score = a_score});
end

function Wizard_PostEndGame(a_score)
   -- this is on the client
   
   rewardInfo = {};
   rewardInfo.Score = a_score;   
   Log("Soblocks Wizard_PostEndGame with score = "..rewardInfo.Score);   
      
   -- Hide the GUI while the MG Interface is up   
   GameWindow.ShowWindow( false );
   if(DoPostGameInterface(Script_Name, rewardInfo, false, Messages.EndGame) == true) then      
      DebugBeginCriticalSection();
      SendProcessMessage(Messages.ResetGame, {});
   else
      Log("Soblocks Wizard_PostEndGame, do kill process id");
      Kill(GetProcessID());
   end
   GameWindow.ShowWindow( true );
end

function Socia_BeginMain()
   DebugBeginCriticalSection();
   GameWindow = CreateGUIClass("Soblocks.gui", false);
   GameWindow.ShowWindow(true);
   GameWindow = GameWindow.FindNamedWindow("SoblocksSolo");
   CoreInit();
   Init();
   
   -- Show the board now
   SendClientEvent("EndZoneTransition");
   DebugEndCriticalSection();
end

function Wizard_BeginMain()
   Script_Name = "Sorcery_Stones"

   if(DoPreGameInterface(Script_Name, false, Messages.EndGame, "Score") == false) then
      Kill(GetProcessID());
   end
   
   DebugBeginCriticalSection();
   GameWindow = CreateGUIClass("Soblocks.gui", false);
   CoreInit();
   Init();
   DebugEndCriticalSection();

end

function Socia_InitInfo()
   table.insert(info, "<center>Click to switch blocks inside the cursor frame!</center>");
   table.insert(info, string.format("<center>P pauses the game.\nZ makes blocks advance.</center>"));
end
function Wizard_InitInfo()
   table.insert(info, "<string;MinigameInstructions_Sorcery_Stones_Switch></string>");
   table.insert(info, "<string;MinigameInstructions_Sorcery_Stones_Advance></string>");
end

--Game-specific functions to use
JOINSESSION_FUNC   = Socia_JoinSession;
SENDMESSAGE_FUNC   = Socia_SendMessage;
CLIENTPROCEND_FUNC = Socia_ClientProcessEnd;
ENDGAME_FUNC       = Socia_EndGame;
STARTSWAP_FUNC     = Socia_StartSwap;
PRE_ENDGAME_FUNC   = Socia_PreEndGame;
POST_ENDGAME_FUNC  = Socia_PostEndGame;
BEGINMAIN_FUNC     = Socia_BeginMain;
INITINFO_FUNC      = Socia_InitInfo;

if (GAME == Wizard) then
   JOINSESSION_FUNC   = Wizard_JoinSession;
   SENDMESSAGE_FUNC   = Wizard_SendMessage;
   CLIENTPROCEND_FUNC = Wizard_ClientProcessEnd;
   ENDGAME_FUNC       = Wizard_EndGame;
   STARTSWAP_FUNC     = Wizard_StartSwap;
   PRE_ENDGAME_FUNC   = Wizard_PreEndGame;
   POST_ENDGAME_FUNC  = Wizard_PostEndGame;
   BEGINMAIN_FUNC     = Wizard_BeginMain;
   INITINFO_FUNC      = Wizard_InitInfo;
end
