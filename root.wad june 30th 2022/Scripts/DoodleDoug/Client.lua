--[[ 
   Dig Dug
   Client-Side script

   Author: Gem
   KingsIsle Entertainment
   
   DIRECTIONS:
   

   Collect all the gems burried underground before time runs out!
   Watch out for monsters!  
   
   Use the arrow keys or W, A, S, & D to move your wizard around.
   Use Ctrl or the Space Bar to drop a bomb.
   Bombs will take out any monsters that are near by, but they will hurt you too if you are too close!
   
   Press P or the Pause key to pause the game.
]]

Include("API/Debug.lua");
Include("API/Utilities.lua");
Include("API/Globals.lua");
Include("API/ControlClasses.lua");
Include("API/BitManip.lua");
Include("API/Classes/ControlMessageBox.lua");
Include("API/KeyCodes.lua");
Include("API/Classes/Timer.lua");
Include("DoodleDoug/Messages.lua");
Include("DoodleDoug/DdCommandStack.lua");
Include("DoodleDoug/ParticleEffects.lua");
Include( "API/MinigameInterface.lua" );

Script_Name = "DoodleDoug";

-- Setup global variables (all globals begine with a capital letter)
do
   RegisteredEvents = {}; -- table of events to register   
   -- The KeyMap table determines what actions are triggred by what keys.       
   -- CreateReverseLookup is used so that we can key on the direction strings.
   -- The direction strings are taken directly from KeyCodes.lua.
   KeyMap = 
   {
   GO_LEFT = CreateReverseLookup{'A', 'LEFT_ARROW'}, 
   GO_RIGHT = CreateReverseLookup{'D', 'RIGHT_ARROW'}, 
   GO_UP = CreateReverseLookup{'W', 'UP_ARROW'}, 
   GO_DOWN = CreateReverseLookup{'S', 'DOWN_ARROW'}, 
   SHOOT = CreateReverseLookup{'SPACEBAR', 'CONTROL'}, 
   };        
   
   COMMAND = CreateReverseLookup{"up", "down", "left", "right", "shoot", "stop"};
   DIRECTIONS = CreateReverseLookup{"north", "south", "west", "east", "northwest", "northeast", "southwest", "southeast"};
   SPRITE_STATES = CreateReverseLookup{"normal", "immobilized", "falling", "dead", "teleport", "casting"};
   GAME_STATES = CreateReverseLookup{"normal", "levComplete", "playerDead", "gameOver", "scripting", "timeUp"};
   OBJECTS = CreateReverseLookup{"empty", "rock", "gem", "tunnel", "mob1", "mob2", "mob3", "mob4", "surprise", "debug"};

	AnyKeyPressed = 0;
	LastTimeMSG_Moved = 0;
end



-- These are User Events
do
   function GM_KEYDOWN(event)   
      if keyCodes[event.Key] then -- make sure the event is in KeyCodes.lua  before processing   
         if KeyMap.GO_LEFT[keyCodes[event.Key]] then 
            DdCommandStack:push(COMMAND.left);     
         elseif KeyMap.GO_RIGHT[keyCodes[event.Key]] then
            DdCommandStack:push(COMMAND.right);
         elseif KeyMap.GO_UP[keyCodes[event.Key]] then
            DdCommandStack:push(COMMAND.up);
         elseif KeyMap.GO_DOWN[keyCodes[event.Key]] then 
            DdCommandStack:push(COMMAND.down);
         elseif KeyMap.SHOOT[keyCodes[event.Key]] then 
            DdCommandStack:push(COMMAND.shoot);
         end
      end
   end

   function GM_KEYUP(event)
      if keyCodes[event.Key] then -- make sure the event is in KeyCodes.lua  before processing
         if KeyMap.GO_LEFT[keyCodes[event.Key]] then 
            DdCommandStack:pop(COMMAND.left);
         elseif KeyMap.GO_RIGHT[keyCodes[event.Key]] then 
            DdCommandStack:pop(COMMAND.right);
         elseif KeyMap.GO_UP[keyCodes[event.Key]] then 
            DdCommandStack:pop(COMMAND.up);
         elseif KeyMap.GO_DOWN[keyCodes[event.Key]] then 
            DdCommandStack:pop(COMMAND.down);
         elseif KeyMap.SHOOT[keyCodes[event.Key]] then 
            DdCommandStack:pop(COMMAND.shoot);
         end
      end
      AnyKeyPressed = 1;
   end
   
   function GM_MOUSEBTNDOWN(event)
      MouseX = event.X;
      MouseY = event.Y;
      if(event.Button == 0) then 
         --mouseMove(MouseX, MouseY);
      end
   end
   
   function WB_BUTTONUP_EVENT( event )
      if (event.Name == "CloseButton") then
         gameOver(); 
      end
   end
   
   function ON_FACING_NORTH(event)
      Log("RCV'D EVENT: ON_FACING_NORTH");
   end
   
   function ON_FACING_SOUTH(event)
      Log("RCV'D EVENT: ON_FACING_SOUTH");
      Log("test1: "..event.test1..", test2: "..event.test2..", test3: "..event.test3);
      Log("OID: "..event.OID);
      local mySprite = OpenClass(event.OID);
      
     
      mySprite.SetRotation(90);
      mySprite.FlipHorizontal(false);
     
   end
   
   function ON_FACING_WEST(event)
      Log("RCV'D EVENT: ON_FACING_WEST");      
   end
   
   function ON_FACING_EAST(event)
      Log("RCV'D EVENT: ON_FACING_EAST");
   end
   
   function RECONNECT_TIMEOUT( event )
      Log("Server Timed Out during mini game.");
      while(true) do
         Sleep(1000);
      end   
   end
   
   RegisteredEvents["GM_KEYDOWN"] = GM_KEYDOWN;
   RegisteredEvents["GM_KEYUP"] = GM_KEYUP;
   RegisteredEvents["GM_MOUSEBTNDOWN"] =  GM_MOUSEBTNDOWN;
   RegisteredEvents["WB_BUTTONUP"] = WB_BUTTONUP_EVENT;
   RegisteredEvents["DdOnFacingNorth"] = ON_FACING_NORTH;
   RegisteredEvents["DdOnFacingSouth"] = ON_FACING_SOUTH;
   RegisteredEvents["DdOnFacingWest"] = ON_FACING_WEST;
   RegisteredEvents["DdOnFacingEast"] = ON_FACING_EAST;   
   RegisteredEvents["AppReconnectTimeout"] = RECONNECT_TIMEOUT;
end


function main()

   if(DoPreGameInterface(Script_Name) == false) then
      exit();
   end
   
   Log("Starting DoodleDoug Script!");     

   -- Freeze the player in the 3D world -- Dont forget to unfreeze before quitting!
   FreezePlayer();
   UnmapKey("ToggleDeckConfig");

   initGame();     
   resetBoard(true);       
  
   -- Register all required events
   for eventName, _ in pairs( RegisteredEvents ) do
      RegisterEvent( eventName );
   end    
   
  
  -------------------Begin  Main Game Loop  --------------------
   while(QuitGame == false) do -- main game loop          
      event = GetEvent("", false);
      if (event) then
         local func = RegisteredEvents[event.EventName];
         if func then
            func(event);
         end      
      end

      -- use GameTimer to send a MSG_NOT_AFK to server once a minute
	  local currentTime = GameTimer:GetTime();
	  if (currentTime - LastTimeMSG_Moved > 60000) then
	  Log("DoodleDoug -- MSG_Moved, currentTime "..currentTime);
	     LastTimeMSG_Moved = currentTime;
	     if (AnyKeyPressed == 1) then
	        AnyKeyPressed = 0;
	        MovedInfo = {};
     	    SendProcessMessage(Messages.Moved, MovedInfo);
	     end
	  end

      if(PauseState == false and GameOver == false) then               
      
         --- TO_DO: CommandStack doesnt support multiplayer at this time!
         local command = nil;         
         command = DdCommandStack:top();                       
         if(not command) then
            command = COMMAND.stop;
         end
         
         Board.PlayersAct(command);      
 
         if(Board.GetGameState() == GAME_STATES.normal) then   
            if(LevelTimer.Paused == true) then
               LevelTimer:Pause(); -- unpause the level timer once the player is done scripting
            end   

            if(not SpawnTimer) then
               spawnRandomMob();
               SpawnTimer = Timer();
               SpawnTimer:Reset();
            elseif(SpawnTimer:GetTime() >= Config.SpawnDelay) then
               spawnRandomMob();
               SpawnTimer:Reset();
            end
            
            Board.MobsAct();                 
            Board.UpdateScore();       
            
            CurrentTimeVal = math.floor(Config.LevelTime - (LevelTimer:GetTime()/1000) + TimeAdjustment);
            if((not LastTimeVal or CurrentTimeVal ~= LastTimeVal) and CurrentTimeVal >= 0) then
               LastTimeVal = CurrentTimeVal;
               if(CurrentTimeVal <= Config.CriticalTimeVal and CurrentTimeVal > 0) then
                  PlaySoundOnce(string.format("MiniGames/DoodleDoug/TimerLow.wav"));
               end
               local deltaTime = Board.UpdateTime(CurrentTimeVal);  
               if(deltaTime ~= 0) then
                  TimeAdjustment = TimeAdjustment + deltaTime;
               end
               if(BonusSpawnTime > 0 and CurrentTimeVal == (BonusSpawnTime + TimeAdjustment)) then
                  local midRow = math.floor(NumRows/2);
                  local midCol = math.floor(NumCols/2);
                  Board.AddBonusGem(midCol..","..midRow, "DoodleDoug/Gem_Diamond.dds", Config.BonusGemPoints);
               end
            end            
         end          

         Board.UpdateLives();         
         Board.ManageSpriteStates();
         Board.ManageSurprises();
         manageGameState();         
                   
      end -- if(PauseState == false and GameOver == false)
   end -- while(QuitGame == false)
   -------------------End  Main Game Loop  --------------------  

end

-- perform only once to set up the initial game state and setup global variables (all globals begine with a capital letter)
function initGame()   
      
   -- connect to server
   SendProcessMessage(Messages.Connect, {});
        
   -- Create the main game board class in C++
   Board = CreateClass("class DoodleDoug");   
   if(not Board) then
      Log("ERROR: Unable to create main Board as member of class DoodleDoug!");
      exit();
   end

   -- Set up initial board properties: "Height,Width"
   local boardSize = "600,440"
   local gridSize = "40,40";
   local tileSize = "8,8";
   local tunnelSize = "40,40";
   Board.InitBoard(boardSize, gridSize, tileSize, tunnelSize); -- create the main playing board object
   
   -- Main Configuration table
   Config = 
   {
      GemFile = "DoodleDoug/Gem_Amethyst.dds",
      GemPoints = 50,
      BonusGemPoints = 200,
      LevelTime = 60, -- in seconds
      TimeBonus = 5, -- points per second remaining on the clock 
      BombBonus = 100, -- points per bomb remaining at level's end
      CriticalTimeVal = 10, -- start warning player about remaining time when the clock gets down to here
      PlayerSpawn = {row = 0, col = 0},
      SpawnDelay = 8000, -- milli-seconds between monster spawns
      NumSurprises = 8
   }
   
   -- System Variables   
   GameTimer = Timer(); 
   LevelTimer = Timer();
   SpawnTimer = nil;
   Level = 1; -- the current level
   QuitGame = false; -- set to true to break out of main loop
   PauseState = false;
   GameOver = false;
   NumRows = Board.GetNumRows();
   NumCols = Board.GetNumCols();   
   
   addParticleEffects();
   
   Script = generateMovementScript(DIRECTIONS.east, 7);
   Script = generateMovementScript(DIRECTIONS.south, 3, Script);     
   Board.AddPlayer(Config.PlayerSpawn.col..","..Config.PlayerSpawn.row, 100, Script); 
   
   PlayMusic("|Music|WorldData|MiniGames/DD_Music_LP.mp3");
   
   math.randomseed(os.time());
end

function reserveRealEstate(row1, col1, row2, col2, value)
   local row, col;
   local rStep = 1;
   local cStep = 1;
   
   if(FreeSlots <= 0) then
      return false;
   end
   
   if(not RealEstate) then
      RealEstate = {};
   end
   
   if(row1 > row2 ) then
      rStep = -1;
   end
   if(col1 > col2)  then
      cStep = -1;
   end
       
   for row = row1, row2, rStep do
      if(not RealEstate[row]) then
         RealEstate[row] = {};
      end
      for col = col1, col2, cStep do
          if(not RealEstate[row][col]) then
            RealEstate[row][col] = value;
            FreeSlots = FreeSlots - 1;
          else
            return false
          end
      end
   end   
   
   return true;
end

-- perform at the beginning of each level to reset board to an untouched state and prepare it for that level
function resetBoard(randomize) 
   Board.SetGameState(GAME_STATES.normal);
   CurrentTimeVal = Config.LevelTime;
   Board.UpdateTime(CurrentTimeVal);

   Board.DeleteAllBombs();
   Board.DeleteAllMobs();
   Board.DeleteAllRocks();
   Board.DeleteAllGems();
   Board.DeleteAllSurprises();
   Board.DeleteAllCaptions();


   Board.SetAllCells(-1);
   Board.InitPathGraph(); 
   
   TimeAdjustment = 0;
   BonusSpawnTime = -1;

   Board.TunnelRC(0, 0, 0, Board.GetNumCols(), 9); -- draw a top "sky" tunnel that is clear; this prevents visible tunneling above the ground   
   
   if(not RealEstate or randomize == true) then   
      FreeSlots = NumRows * NumCols; 
      RealEstate = {};   
      reserveRealEstate(1, 1, 1, NumCols, OBJECTS.empty); -- reserve the top row so no items generate there  
      -- reserve space in the game Real Estate for the player's scripted movment
      reserveRealEstate(2, 8, 4, 8, OBJECTS.empty);  
      -- reserve a space for the bonus gem
      local midRow = math.floor(NumRows/2);
      local midCol = math.floor(NumCols/2);
      reserveRealEstate(midRow + 1, midCol + 1, midRow + 1, midCol + 1, OBJECTS.empty);      
      local lastCol = NumCols - 1;
      reserveRealEstate(midRow - 1, 0, midRow + 1, 2, OBJECTS.empty);
      reserveRealEstate(midRow - 1, lastCol - 2, midRow + 1, lastCol, OBJECTS.empty);
      MobProbabilities = nil;
      setupLevel(Level);
   end
      
   Board.ResetPlayers(true, Script);
      
   spawnRealEstate();
   DdCommandStack:clearStack();  
   LevelTimer:Reset();
   if(LevelTimer.Paused == false) then
      LevelTimer:Pause();
   end
   Board.DisplayAnnouncement("<center><string;MinigamesCommon_DOUG_STARTING;LEVEL;"..Level.."></center>", 3000);
   PlayMusic("|Music|WorldData|MiniGames/DD_Music_LP.mp3");
end

function resetPlayers()
   LevelTimer:Pause();   
   Board.SetGameState(GAME_STATES.normal);
   Board.DeleteAllBombs();      
   Board.DeleteAllMobs();
   Board.ResetPlayers(false, Script); -- reset players but not their # of bombs
   if(SpawnTimer) then
      SpawnTimer:Reset();
   end
   PlayMusic("|Music|WorldData|MiniGames/DD_Music_LP.mp3");
end

function generateMovementScript(direction, distance, script)
   local i;
   local anim;
   
   if(not script) then
      script = CreateClass("class WinAnimContainer");
   end   
        
   for i = 1, distance do
      anim = CreateClass("class DdWinAnimMovePlayer");
      anim.InitializeAnimation(direction, direction, 100, Board);
      script.AddAnimation(anim);
      DestroyClass(anim);
   end    

   return script;
end

-- quit the game NOW!
function exit()
   UnfreezePlayer();
   RemapKey("ToggleDeckConfig");
   Kill(GetProcessID());   
end

-- send reward info message
function gameOver()
      Board.PlayDiggingSoundLoop(false);
      PlayMusic(""); -- stop the music

      rewardInfo = {};
      rewardInfo.gameName = Script_Name;
      rewardInfo.score = Board.GetScore();
         
      -- Hide the GUI while the MG Interface is up   
      Board.Show( false );
      if(DoPostGameInterface(Script_Name, rewardInfo) == false) then         
         exit();
      end
      Board.Show( true );
      
      Log("Restart the minigame");
      DestroyClass(Board);
      initGame();
      resetBoard(true);      
end

function manageGameState()   
   
   local state = Board.GetGameState();
   
   if(CurrentTimeVal and CurrentTimeVal <= 0) then
      Log("Time up!");
      PlayMusic(""); -- stop the music
      Board.PlayDiggingSoundLoop(false);
      PlaySoundOnce(string.format("MiniGames/DoodleDoug/TimeUp.wav"));
      AnnounceTimeout = wait(2);
      Board.DisplayAnnouncement("<center><string;MinigamesCommon_DOUG_TIMESUP></center>", -1);
      Board.DeleteAllBombs();
      Board.SpritesDance();
      Board.OutOfTime();
      while(AnnounceTimeout() == false) do end -- pause here if necessary
      Board.UndisplayAnnouncement();    
      state = Board.GetGameState();   
      if(state == GAME_STATES.playerDead) then
         state = GAME_STATES.timeUp;
      end            
   end   
   
   if(state == GAME_STATES.timeUp) then
      resetBoard(false);      
   elseif(state == GAME_STATES.playerDead) then
      Board.SetGameState(GAME_STATES.normal);
      resetPlayers();
   elseif(state == GAME_STATES.levComplete) then
      PlayMusic(""); -- stop the music
      Board.PlayDiggingSoundLoop(false);
      PlaySoundOnce(string.format("MiniGames/DoodleDoug/LevelComplete.wav"));
      Board.DisplayAnnouncement("<center><string;MinigamesCommon_DOUG_LEVELCOMPLETE;LEVEL;"..Level.."></center>", -1);
      Board.DeleteAllBombs();
      Board.SpritesDance();
      AnnounceTimeout = wait(2);      
      doTimeBonus();
      doBombBonus();
      Level = Level + 1;
      while(AnnounceTimeout() == false) do end -- pause here if necessary
      Board.UndisplayAnnouncement();
      resetBoard(true);   
   elseif(state == GAME_STATES.gameOver) then
      PlayMusic(""); -- stop the music
      PlaySoundOnce(string.format("MiniGames/DoodleDoug/GameOver.wav"));
      GameOver = true;
      Log("Doodle Doug Game Over");
      Board.DisplayAnnouncement("<center><string;MinigamesCommon_DOUG_GAMEOVER></center>", -1);
      Board.SpritesDance();
      AnnounceTimeout = wait(3);
      while(AnnounceTimeout() == false) do end -- pause here if necessary
      Board.UndisplayAnnouncement();
      gameOver(); 
   end   
end   

function doTimeBonus()
   local i;   
   local remain = math.floor(Config.LevelTime - (LevelTimer:GetTime()/1000) + TimeAdjustment);
   if(remain > 0) then
      for i = remain, 1, -1 do
         PlaySoundOnce("MiniGames/DoodleDoug/TimeBonus.wav");
         Board.UpdateTime(i);
         Board.DoTimeBonusEffect();
         Board.AddToScore(Config.TimeBonus);
         Board.UpdateScore();
         local sleep = GameTimer:GetTime() + 150;
         while(GameTimer:GetTime() < sleep) do end -- slow down the count
      end
      Board.UpdateTime(0);
   end
end

function doBombBonus()
   local remain = Board.GetNumBombs();      
   while(remain > 0) do
      local sleep = GameTimer:GetTime() + 400;
      while(GameTimer:GetTime() < sleep) do end -- slow down the count
      remain = remain - 1;
      PlaySoundOnce("MiniGames/DoodleDoug/BombBonus.wav");
      Board.DoBombBonusEffect();
      Board.UpdateBombs(remain);
      Board.AddToScore(Config.BombBonus);
      Board.UpdateScore();
   end
end

-- Call this to prepare the topography of a given level and spawn monsters 
function setupLevel(levNum)     
 Log("Starting level "..levNum); 
   if(levNum == 1) then
      generateRandomLevel{rocks = 5, gems = 10, surprises = 2};       
      generateRandomMobs(OBJECTS.mob1, 100, 60);
      Config.GemFile = "DoodleDoug/Gem_Ruby.dds";     
   elseif(levNum == 2) then
      generateRandomLevel{rocks = 10, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob1, 60, 60);
      generateRandomMobs(OBJECTS.mob2, 40, 60);
      Config.GemFile = "DoodleDoug/Gem_Sapphire.dds";
      BonusSpawnTime = 30;
   elseif(levNum == 3) then
      generateRandomLevel{rocks = 10, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob1, 50, 70);
      generateRandomMobs(OBJECTS.mob2, 50, 70);
      Config.GemFile = "DoodleDoug/Gem_Amethyst.dds";   
   elseif(levNum == 4) then
      generateRandomLevel{rocks = 15, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob1, 20, 75);
      generateRandomMobs(OBJECTS.mob2, 60, 75);
      generateRandomMobs(OBJECTS.mob3, 20, 50);
      Config.GemFile = "DoodleDoug/Gem_Jade.dds";   
      BonusSpawnTime = 12;
   elseif(levNum == 5) then
      generateRandomLevel{rocks = 15, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob1, 10, 75);
      generateRandomMobs(OBJECTS.mob2, 60, 75);
      generateRandomMobs(OBJECTS.mob3, 30, 60);
      Config.GemFile = "DoodleDoug/Gem_Citrine.dds";   
   elseif(levNum == 6) then
      generateRandomLevel{rocks = 20, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob2, 60, 85);
      generateRandomMobs(OBJECTS.mob3, 40, 70);
      Config.GemFile = "DoodleDoug/Gem_Peridot.dds";   
      BonusSpawnTime = 50;
   elseif(levNum == 7) then
      generateRandomLevel{rocks = 20, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob2, 50, 85);
      generateRandomMobs(OBJECTS.mob3, 40, 70);
      generateRandomMobs(OBJECTS.mob4, 10, 75);
      Config.GemFile = "DoodleDoug/Gem_Onyx.dds";     
   elseif(levNum == 8) then
      generateRandomLevel{rocks = 20, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob2, 40, 90);
      generateRandomMobs(OBJECTS.mob3, 40, 75);
      generateRandomMobs(OBJECTS.mob4, 20, 75);
      Config.GemFile = "DoodleDoug/Gem_Ruby.dds";
      BonusSpawnTime = 10;
   elseif(levNum == 9) then
      generateRandomLevel{rocks = 20, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob2, 30, 90);
      generateRandomMobs(OBJECTS.mob3, 40, 75);
      generateRandomMobs(OBJECTS.mob4, 30, 75);
      Config.GemFile = "DoodleDoug/Gem_Sapphire.dds";
   elseif(levNum == 10) then
      generateRandomLevel{rocks = 25, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob2, 10, 100);
      generateRandomMobs(OBJECTS.mob3, 40, 80);
      generateRandomMobs(OBJECTS.mob4, 50, 80);
      Config.GemFile = "DoodleDoug/Gem_Amethyst.dds";   
      BonusSpawnTime = 23;
   elseif(levNum == 11) then
      generateRandomLevel{rocks = 25, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob3, 50, 80);
      generateRandomMobs(OBJECTS.mob4, 50, 80);
      Config.GemFile = "DoodleDoug/Gem_Jade.dds";   
   elseif(levNum == 12) then
      generateRandomLevel{rocks = 25, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob3, 40, 85);
      generateRandomMobs(OBJECTS.mob4, 60, 90);
      Config.GemFile = "DoodleDoug/Gem_Citrine.dds";   
      BonusSpawnTime = 35;
   elseif(levNum == 13) then
      generateRandomLevel{rocks = 25, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob3, 30, 90);
      generateRandomMobs(OBJECTS.mob4, 70, 90);
      Config.GemFile = "DoodleDoug/Gem_Peridot.dds";   
   elseif(levNum == 14) then
      generateRandomLevel{rocks = 25, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob3, 20, 100);
      generateRandomMobs(OBJECTS.mob4, 80, 100);
      Config.GemFile = "DoodleDoug/Gem_Onyx.dds";         
      BonusSpawnTime = 40;
   else -- levNum > 14
      generateRandomLevel{rocks = 30, gems = 10, surprises = 2};
      generateRandomMobs(OBJECTS.mob1, 25, 150);
      generateRandomMobs(OBJECTS.mob2, 25, 150);
      generateRandomMobs(OBJECTS.mob3, 25, 120);
      generateRandomMobs(OBJECTS.mob4, 25, 120);
      Config.GemFile =  "DoodleDoug/Gem_Diamond.dds";
      BonusSpawnTime = 20;
   end
end

function generateRandomMobs(mobType, probability, speed)
   local totalProb = 0;
   local i;
   
   if(not MobProbabilities) then
      MobProbabilities = {};      
   else
      for i = 1, #MobProbabilities do
         totalProb = totalProb + MobProbabilities[i].probability;
      end
   end
   
   if(probability > 100 - totalProb) then
      probability = 100 - totalProb;
   end
   
   if(probability > 0) then
      MobProbabilities[#MobProbabilities + 1] = {mobType = mobType, probability = probability, speed = speed};
   else
      Log("Error in generateRandomMobs: Sum of probablities is > 100 or given probability is < 1");
   end  
end

function spawnMob(mob, speed)   
   local lastCol = NumCols - 1;
   if(mob == OBJECTS.mob1) then
      Board.AddMob("0,0", speed, false, false, 5);
   elseif(mob == OBJECTS.mob2) then
      Board.AddMob(lastCol..",0", speed, false, true, 15);
   elseif(mob == OBJECTS.mob3) then
      Board.AddMob(lastCol..",0", speed, true, false, 20);
   elseif(mob == OBJECTS.mob4) then
      Board.AddMob("0,0", speed, true, true, 50);
   end
end

function spawnRandomMob()
   local i;
   local rangeLo = 0;
   local rangeHi = 0;   
   local mobIdx = -1;
   local randPercent = math.random(1, 100);
   
   if(not MobProbabilities) then
      return;
   end

   
   for i = 1, #MobProbabilities do
      rangeLo = rangeHi;
      rangeHi = rangeHi + MobProbabilities[i].probability;
      if(randPercent > rangeLo and randPercent <= rangeHi) then
         mobIdx = i;
      end
   end   
   
   if(mobIdx > 0) then
      spawnMob(MobProbabilities[mobIdx].mobType, MobProbabilities[mobIdx].speed);
   else
      Log("Failed to spawn random mob!");
   end
end

function generateRandomLevel(params)
   local sprite;
   local row, col;

   if(params) then   
      if(params.rocks and params.rocks > 0) then      
         for i = 1,params.rocks do
            if(FreeSlots <= 0) then
               Log("WARNING: Could not generate new object because all board spaces are full!");
               break;
            end
            repeat
               row = math.random(1, NumRows);            
               col = math.random(1, NumCols);            
            until(reserveRealEstate(row, col, row, col, OBJECTS.rock) == true)                    
         end
      end
      
      if(params.gems and params.gems > 0) then      
         for i = 1,params.gems do
            if(FreeSlots <= 0) then
               Log("WARNING: Could not generate new object because all board spaces are full!");
               break;
            end
            repeat
               row = math.random(1, NumRows);            
               col = math.random(1, NumCols);            
            until(reserveRealEstate(row, col, row, col, OBJECTS.gem) == true)                    
         end
      end
      
      if(params.surprises and params.surprises > 0) then      
         for i = 1,params.surprises do
            if(FreeSlots <= 0) then
               Log("WARNING: Could not generate new object because all board spaces are full!");
               break;
            end
            repeat
               row = math.random(1, NumRows);            
               col = math.random(1, NumCols);            
            until(reserveRealEstate(row, col, row, col, OBJECTS.surprise) == true)                    
         end
      end
   end   
end

function spawnRealEstate()
   local row, col;

   for row = 1, NumRows do
      for col = 1, NumCols do
         if(RealEstate[row] and RealEstate[row][col]) then
            if(RealEstate[row][col] == OBJECTS.rock) then
               Board.AddRock((col - 1)..","..(row - 1), "DoodleDoug/Rock.dds");
            elseif(RealEstate[row][col] == OBJECTS.gem) then
               Board.AddGem((col - 1)..","..(row - 1), Config.GemFile, Config.GemPoints);
            elseif(RealEstate[row][col] == OBJECTS.surprise) then
               local type =  math.random(0, Config.NumSurprises - 1);
               Board.AddSurprise((col - 1)..","..(row - 1), type);                 
            elseif(RealEstate[row][col] == OBJECTS.debug) then
               Board.TunnelRC(row - 1, col - 1, row - 1, col - 1, 10);
            end
         end
      end   
   end
end

function randomTunnel(startRow, startCol, minLength, maxLength)
         local orientation = math.random(0, 1);
         local length = math.random(minLength, maxLength);         
         local endRow = startRow;
         local endCol = startCol;
         
         if(orientation == 1) then  -- horizontal tunnel
            endCol = startCol + length - 1;
         else  -- vertical tunnel
            endRow = startRow + length - 1;
         end   

         --Log("LUA DBG: Random Tunnel from ("..(startRow - 1)..", "..(startCol - 1)..") to ("..(endRow - 1)..", "..(endCol - 1)..")");
         Board.TunnelRC(startRow - 1, startCol - 1, endRow - 1, endCol - 1, -1); 
end
 
-- closure to return a function that will return true after a specified number of seconds 
-- this is used as a sort of "mini-timer" for timed game delays
function wait(delayTime)
   local startTime = GameTimer:GetTime();
   return   function()
               local currentTime = GameTimer:GetTime();  
               if(currentTime > startTime + delayTime*1000) then
                  return true;
               else
                  return false;
               end
            end
end

function pauseGame()   
   if(Board and Board.GetGameState() == GAME_STATES.normal)  then
      PlaySoundOnce(string.format("MiniGames/DoodleDoug/Pause.wav"));
      if(PauseState == false) then
         PauseState = true;
         Log("Game Paused");
      else
         PauseState = false;
         Log("Game Unpaused");
      end
   
      LevelTimer:Pause();      
      if(SpawnTimer) then
         SpawnTimer:Pause();
      end      
   end
end

